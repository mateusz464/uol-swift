//
//  MuralViewController.swift
//  New Brighton Murals
//
//  Created by Mateusz Golebiowski on 07/12/2022.
//

import UIKit
import MapKit

class MuralViewController: UIViewController {
    
    var currentTitle: String?
    var artist: String?
    var info: String?
    var images: [String]?
    
    
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
        
        if images != nil {
            var image: UIImage?
            let urlString = images![0]
            
            let url = NSURL(string: urlString)! as URL
            if let imageData: NSData = NSData(contentsOf: url){
                image = UIImage(data: imageData as Data)
            }
            
            imageBox.image = image
        }
        
    }
    
}
