//
//  ViewController.swift
//  Hello You
//
//  Created by Mateusz Golebiowski on 04/10/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameBox: UITextField!
    
    @IBOutlet weak var outputMessage: UILabel!
    
    @IBAction func okBtn(_ sender: Any) {
        let userName = nameBox.text!
        let outputString = "Hello " + userName
        
        outputMessage.text = outputString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

