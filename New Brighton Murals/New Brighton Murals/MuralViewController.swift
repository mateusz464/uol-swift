//
//  MuralViewController.swift
//  New Brighton Murals
//
//  Created by Mateusz Golebiowski on 07/12/2022.
//

import UIKit
import MapKit

class MuralViewController: UIViewController {
    
    let baseImgURL = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/nbm_images/"
    var currentTitle: String?
    var artist: String?
    var info: String?
    var images: [image]?
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var imageBox: UIImageView!
    
    @IBOutlet weak var scOutlet: UISegmentedControl!
    
    @IBAction func scAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        
        titleLabel.text = currentTitle ?? "No Title"
        artistLabel.text = artist ?? "No Artist"
        infoLabel.text = info ?? "No Info"
        
//        if images != nil {
//            var image: UIImage?
//            let urlString = baseImgURL + images![0].filename
//
//            let url = NSURL(string: urlString)! as URL
//            if let imageData: NSData = NSData(contentsOf: url){
//                image = UIImage(data: imageData as Data)
//            }
//
//            imageBox.image = image
//        }
        
        let urlString = baseImgURL + images![0].filename
        let url = NSURL(string: urlString)! as URL
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            guard
                let data = data,
                let newImage = UIImage(data: data) else {
                print("Couldn't load image from URL")
                return
            }

            DispatchQueue.main.async {
                self.imageBox.image = newImage
                print("SET IMAGE")
            }
        }
        task.resume()
        
    }
    
}
