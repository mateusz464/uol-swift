//
//  ViewController.swift
//  Multiplication Table
//
//  Created by Mateusz Golebiowski on 11/10/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    var userNum : Int?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return "Multiplication"
        } else {
            return "Division"
        }
    }

    @IBOutlet weak var numberField: UITextField!
    
    @IBOutlet weak var multTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        
        if (indexPath.section == 0){
            content.text = "\(indexPath.row + 1) x \(userNum ?? 0) = \((indexPath.row + 1) * (userNum ?? 0))"
        } else {
            let result = Double(userNum ?? 0) / Double((indexPath.row + 1))
            content.text = "\(userNum ?? 0) / \(indexPath.row + 1) = \(String(format: "%.4f", result))"
        }
        
        aCell.contentConfiguration = content
        return aCell
    }
    
    // Rejects any non-numeric input values
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    
    @IBAction func goBtn(_ sender: Any) {
        userNum = Int(numberField.text!)
        multTable.reloadData()
        numberField.resignFirstResponder()
        
        multTable.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberField.delegate = self
        // Do any additional setup after loading the view.
    }


}

