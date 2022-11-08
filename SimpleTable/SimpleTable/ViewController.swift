//
//  ViewController.swift
//  SimpleTable
//
//  Created by Mateusz Golebiowski on 11/10/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return "Friends"
        } else {
            return "Racers"
        }
    }
    
    let my2DArray = [["Dylan", "Tom", "James", "Adam"],["Leclerc", "Vettel", "Hamilton", "Verstappen"]]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return my2DArray[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        var content = UIListContentConfiguration.cell()
        content.text = "\(my2DArray[indexPath.section][indexPath.row])"
        aCell.contentConfiguration = content
        
        return aCell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

