//
//  GameOverViewController.swift
//  WheelOfFortune
//
//  Created by Mateusz Golebiowski on 10/11/2022.
//

import UIKit

class GameOverViewController: UIViewController {
    
    var hasWon = false
    
//    These will only be used if the user has lost the game.
    let titleText = "Better luck next time"
    let lossText = "You lost!"
    var username = ""
    
    var finalScore = 0

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var winLossLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBAction func submitBtn(_ sender: Any) {
//        Removes the keyboard once the button has been pressed
        nameField.resignFirstResponder()
//        If the user did not write a name the scoreboard will show Anonymous
        username = nameField.text ?? "Anonymous"
        if (username == "") {
            username = "Anonymous"
        }
        
        let userDefaults = UserDefaults.standard
        
        var nameArr = [String]()
        var scoreArr = [Int]()
        
//        Checking if the data we need exists
        let data = userDefaults.object(forKey: "nameArray")
        
//        If the data does not exist then new data is created
        if (data == nil){
            nameArr.append(username)
            scoreArr.append(finalScore)
            
            userDefaults.set(nameArr, forKey: "nameArray")
            userDefaults.set(scoreArr, forKey: "scoreArray")
            
//            Else if it does exist, fetch it, update it and overwrite it.
        } else {
            var names = userDefaults.object(forKey: "nameArray") as? [String]
            names?.append(username)
            var scores = userDefaults.object(forKey: "scoreArray") as? [Int]
            scores?.append(finalScore)
            
            userDefaults.set(names, forKey: "nameArray")
            userDefaults.set(scores, forKey: "scoreArray")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        scoreLabel.text = scoreLabel.text! + " " + String(finalScore)
        
        if (!hasWon) {
            titleLabel.text = titleText
            winLossLabel.text = lossText
        }
        
    }

}
