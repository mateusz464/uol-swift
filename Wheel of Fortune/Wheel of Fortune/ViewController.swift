//
//  ViewController.swift
//  Wheel of Fortune
//
//  Created by Mateusz Golebiowski on 25/10/2022.
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

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var wordResult: (word: String, length: Int) = ("", 0)
    var publicWord: String = ""
    var wrongTries = 0
    var letterArr = [String]()
    
    @IBOutlet weak var theTableView: UICollectionView!
    
    @IBOutlet weak var letterField: UITextField!
    
    @IBOutlet weak var wrongGuessLabel: UILabel!
    
    
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
    
    func getWord() -> (String, Int) {
        let wordsTuple: (phrases: [String], genre: String) = getJSONDataIntoArray()
        let arrLength = wordsTuple.phrases.count
        let randomNum = Int.random(in: 0..<arrLength)
        let chosenWord = wordsTuple.phrases[randomNum]
        let wordLength = chosenWord.count
        return (chosenWord, wordLength)
    }
    
    func checkForLetter(letter: String){
        if ((wordResult.0.contains(letter)) || (wordResult.0.contains(letter.lowercased()))){
            letterArr.append(letter)
//            publicWord = publicWord.replacingOccurrences(of: "-", with: letter, options: .literal, range: nil)
//            for i in 0...wordResult.1-1{
//
//                if (letter == wordResult.0[i]){
//                    let lowerIndex = publicWord.index(publicWord.startIndex, offsetBy: i)
//                    let higherIndex = publicWord.index(publicWord.startIndex, offsetBy: i+1)
//                    publicWord.replaceSubrange(lowerIndex..<higherIndex, with: letter)
//                }
//            }
        } else {
            wrongTries += 1
            wrongGuessLabel.text = String(wrongTries)
        }
    }
    
    @IBAction func enterBtn(_ sender: Any) {
        theTableView.isHidden = false
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
            print("LETTER= " + letter)
            checkForLetter(letter: letter)
//            print("PUBLIC WORD= " + publicWord)
            print(letterArr)
            theTableView.reloadData()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 56;
//        return wordResult.1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! customCell
          
//        ACTUAL WORD
//        if (indexPath.row < wordResult.1){
//            let word = wordResult.0
//            let num: Int = indexPath.row
//            let index = word.index(word.startIndex, offsetBy: num)
//            aCell.letterImage.image = UIImage(named: String(word[index]).uppercased())
//        }
        
//        JUST DISPLAY WORD
//        if (indexPath.row < wordResult.1){
//            let num: Int = indexPath.row
//            let index = publicWord.index(publicWord.startIndex, offsetBy: num)
//            aCell.letterImage.image = UIImage(named: String(publicWord[index].uppercased()))
//        }
        
//        DISPLAY ONLY IF IN ARR
        if (indexPath.row < wordResult.1){
            let num: Int = indexPath.row
            let letter = wordResult.0[num].uppercased()
            if (letterArr.contains(letter)){
                aCell.letterImage.image = UIImage(named: letter.uppercased())
            } else {
                aCell.letterImage.image = UIImage(named: "-")
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
        theTableView.isHidden = true
        wordResult = getWord()
        
        for _ in 1...wordResult.1 {
            publicWord += "-"
        }
        
        print(wordResult.0)
        print(publicWord)
        
    }

}
