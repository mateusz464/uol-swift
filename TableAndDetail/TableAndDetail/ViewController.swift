//
//  ViewController.swift
//  TableAndDetail
//
//  Created by Mateusz Golebiowski on 24/10/2022.
//

import UIKit

var selectedPerson = ("", "", "")

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let staff = [("Phil","A1.20","phil@liverpool.ac.uk"),("Terry","A2.18","trp@liverpool.ac.uk"),("Valli","A2.12","V.Tamma@liverpool.ac.uk"),("Boris","A1.15","Konev@liverpool.ac.uk")]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staff.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        var content = UIListContentConfiguration.cell()
        (content.text,_,_) = staff[indexPath.row]
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPerson = staff[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

