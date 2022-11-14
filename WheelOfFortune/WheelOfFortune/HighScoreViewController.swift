//
//  HighScoreViewController.swift
//  WheelOfFortune
//
//  Created by Mateusz Golebiowski on 11/11/2022.
//

import UIKit

class HighScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nameArr = [String]()
    var scoreArr = [Int]()
    var isData = true
    
//    Bubble sort method to sort by the highest score on the high scores.
    func bubbleSort(){
        let lastPos = scoreArr.count - 1
        var swap = true
        
        while (swap == true) {
            swap = false
            
            for i in 0..<lastPos {
                if (scoreArr[i] < scoreArr[i+1]){
                    let tempScore = scoreArr[i+1]
                    scoreArr[i+1] = scoreArr[i]
                    scoreArr[i] = tempScore
                    
                    let tempName = nameArr[i+1]
                    nameArr[i+1] = nameArr[i]
                    nameArr[i] = tempName
                    
                    swap = true
                }
            }
        }
    }
    
//    Only shows top 10 highest scores
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "myTableCell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        
//        If there is data in the array then sort it and display it else don't display anything.
        if (isData) {
            bubbleSort()
            
            let count = nameArr.count
            
            if (indexPath.row >= count) {
                content.text = nil
            } else {
                let data = nameArr[indexPath.row] + " = " + String(scoreArr[indexPath.row])
                content.text = data
            }
            
        } else {
            content.text = nil
        }
            
        aCell.contentConfiguration = content
        return aCell

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = UserDefaults.standard
        let data = userDefaults.object(forKey: "nameArray")
        
        if (data == nil){
            isData = false
        } else {
            let names = userDefaults.object(forKey: "nameArray") as? [String]
            let scores = userDefaults.object(forKey: "scoreArray") as? [Int]
            
            nameArr = names!
            scoreArr = scores!
        }
        
    }

}

