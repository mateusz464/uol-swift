//
//  GameViewController.swift
//  WheelOfFortune
//
//  Created by Mateusz Golebiowski on 09/11/2022.
//

import UIKit

// Imported from Stack Overflow: Allows me to get a character from a string by writing string[i]
extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var wordResult: (word: String, length: Int, genre: String) = ("", 0, "")
    var wrongTries = 0
    var letterArr = [String]()
    var uniqueLetters = 0
    var score = 0
    var reward = 0
    var hasWon = false
    
    @IBOutlet weak var tableView: UICollectionView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var noMatchesNumLabel: UILabel!
    
    @IBOutlet weak var letterField: UITextField!
    
    @IBOutlet weak var rewardScoreLabel: UILabel!
    
    @IBOutlet weak var usedLettersLabel: UILabel!
    
    
    func getFilesInBundleFolder(named fileOrFolderName:String,withExt: String) -> [URL] {
        var fileURLs = [URL]() //the retrieved file-based URLs will be placed here
        let path = Bundle.main.url(forResource: fileOrFolderName, withExtension: withExt)
        //get the URL of the item from the Bundle (in this case a folder
        //whose name was passed as an argument to this function)
        do {// Get the directory contents urls (including subfolders urls)
            fileURLs = try FileManager.default.contentsOfDirectory(at: path!, includingPropertiesForKeys: nil, options: [])
        } catch {
            print(error.localizedDescription)
        }
        return fileURLs
    }
    
    func getJSONDataIntoArray() -> ([String],String) {
        var theGamePhrases = [String]() //empty array which will evenutally hold our phrases
        //and which we will use to return as part of the result of this function.
        var theGameGenre = ""
        //get the URL of one of the JSON files from the JSONdatafiles folder, at random
        let aDataFile = getFilesInBundleFolder(named: "JSONdatafiles", withExt: "").randomElement()
        do {
            let theData = try Data(contentsOf: aDataFile!) //get the contents of that file as data
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: theData,options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                let theTopicData = (jsonResult as? NSDictionary)
                let gameGenre = theTopicData!["genre"] as! String
                theGameGenre = gameGenre //copied so we can see the var outside of this block
                let tempArray = theTopicData!["list"]
                let gamePhrases = tempArray as! [String]
                //compiler complains if we just try to assign this String array to a standard Swift one
                //so instead, we extract individual strings and add them to our larger scope var
                for aPhrase in gamePhrases { //done so we can see the var outside of this block
                    theGamePhrases.append(aPhrase)
                }
            } catch {
                print("couldn't decode JSON data")
            }
        } catch {
            print("couldn't retrieve data from JSON file")
        }
        return (theGamePhrases,theGameGenre) //tuple composed of Array of phrase Strings and genre
    }
    
//    Creates a word tuple from calling the getJSONDataIntoArray method and then gets a random word from that tuple. It then creates a new tuple with the chosen word, the length of the word (count) and then the genre of the word.
    func getWord() -> (String, Int, String) {
        let wordsTuple: (phrases: [String], genre: String) = getJSONDataIntoArray()
        let arrLength = wordsTuple.phrases.count
        let randomNum = Int.random(in: 0..<arrLength)
        let chosenWord = wordsTuple.phrases[randomNum]
        let wordLength = chosenWord.count
        return (chosenWord, wordLength, wordsTuple.genre)
    }
    
//    For every character in a string it checks if the char is in uniqueString. If it is not then it is added there and if one already is then it is not added. This gets a string of unique characters in the string.
    func getUniqueCharacters(from string: String) -> String {
        var uniqueString = ""
        for character in string {
            if uniqueString.uppercased().contains(character.uppercased()) == false {
                if character.isLetter {
                    uniqueString += String(describing: character)
                }
            }
        }
        return uniqueString
    }
    
//    Calculates the score from the letter provided. The more duplicates of the letter the higher the score.
    func getScore(letter: String) -> (Int){
        let str = wordResult.0.lowercased().filter { $0 == Character(String(letter).lowercased())}
        let tempScore = str.count * reward
        return tempScore
    }
    
    func checkForLetter(letter: String){
//        If the word, either higher or lowercase, is in the word then add it to the array and calculate score.
        if ((wordResult.0.contains(letter)) || (wordResult.0.contains(letter.lowercased()))){
            
            if (letterArr.contains(letter)){
//                do nothing
                return
            } else {
                letterArr.append(letter)
                score += getScore(letter: letter)
            }
            
//            add the letters to the used letters label
            usedLettersLabel.text = usedLettersLabel.text! + letter + ", "
            
        } else {
            
//              Increment wrongTries and update it on the label
            if (!usedLettersLabel.text!.contains(letter)){
                usedLettersLabel.text = usedLettersLabel.text! + letter + ", "
                
                wrongTries += 1
                noMatchesNumLabel.text = String(wrongTries)
            }

//            if the user had 10 wrong tries then it ends the game
            if (wrongTries == 10){
                performSegue(withIdentifier: "gameOverSegue", sender: self)
                return
            }
        }
    }
    
    
    @IBAction func enterLetterBtn(_ sender: Any) {
        letterField.resignFirstResponder()
        let guess = letterField.text
        var letter = ""
        
        if (guess! == "") {
            letterField.placeholder = "Enter a letter"
        } else if (guess!.count > 1){
            letterField.placeholder = "Enter one letter"
        } else {
            letter = (guess?.uppercased())!
            checkForLetter(letter: letter)
            tableView.reloadData()
        }
        
        if (letterArr.count == uniqueLetters){
            hasWon = true
            performSegue(withIdentifier: "gameOverSegue", sender: self)
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let goVC = segue.destination as! GameOverViewController
        goVC.finalScore = score
        goVC.hasWon = hasWon
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 56
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! customCell
        
//        DISPLAY ONLY IF IN ARR
        if (indexPath.row < wordResult.1){
            let num: Int = indexPath.row
            let letter = wordResult.0[num].uppercased()
            
            if (letterArr.contains(letter)){
                aCell.letterImage.image = UIImage(named: letter.uppercased())
            } else if (letter.contains(" ")) {
                aCell.letterImage.image = UIImage(named: "-")
            } else {
                aCell.letterImage.image = UIImage(named: "+")
            }
        } else {
            aCell.letterImage.image = nil
        }
     
//        HIDES THE EDGES
        
//        if ((indexPath.row == 0) || (indexPath.row == 13) || (indexPath.row == 42) || (indexPath.row == 55)) {
//            aCell.contentView.isHidden = true
//        }

        return aCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0001
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0001
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 24, height: 30)
        return size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordResult = getWord()
        uniqueLetters = getUniqueCharacters(from: wordResult.0).count
        
        categoryLabel.text = categoryLabel.text! + " " + wordResult.2
        let scoreArr = [1,2,5,10,20]
        reward = scoreArr[Int.random(in: 0..<5)]
        rewardScoreLabel.text! += String(reward)
        
        print(wordResult.0)
        
    }
    
}
