//
//  GameOverViewController.swift
//  WheelOfFortune
//
//  Created by Mateusz Golebiowski on 10/11/2022.
//

import UIKit

class GameOverViewController: UIViewController {
    
    var hasWon = false
    
    let titleText = "Better luck next time"
    let lossText = "You lost!"
    
    var finalScore = 0

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var winLossLabel: UILabel!
    
    
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
