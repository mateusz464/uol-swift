//
//  ViewController.swift
//  GuessDice
//
//  Created by Mateusz Golebiowski on 04/10/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var guessField: UITextField!
        
    @IBOutlet weak var rolledLabel: UILabel!
    
    @IBOutlet weak var rolledImg: UIImageView!
    
    @IBAction func guessBtn(_ sender: Any) {
        
        guessField.resignFirstResponder()
        
        let diceRoll = Int.random(in: 1..<7) // Value between 1-6
        let userGuess = Int(guessField.text!)
        
        var output = "The dice rolled a " + String(diceRoll) + ".\n"
        
        if (diceRoll == userGuess) {
            output = output + "Congratulations you guessed correctly!"
        } else {
            output = output + "Unlucky, you guessed wrong!"
        }
     
                
        if (diceRoll == 1){
            rolledImg.image = UIImage(named: "dice1")
        } else if (diceRoll == 2) {
            rolledImg.image = UIImage(named: "dice2")
        } else if (diceRoll == 3) {
            rolledImg.image = UIImage(named: "dice3")
        } else if (diceRoll == 4) {
            rolledImg.image = UIImage(named: "dice4")
        } else if (diceRoll == 5) {
            rolledImg.image = UIImage(named: "dice5")
        } else {
            rolledImg.image = UIImage(named: "dice6")
        }
        
        rolledLabel.text = output    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

