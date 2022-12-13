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
    var numberOfImg = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var imageBox: UIImageView!
    @IBOutlet weak var scOutlet: UISegmentedControl!
    
    @IBAction func scAction(_ sender: Any) {
        /// If the segmented control is pressed then switch to the image of same index as the button that was pressed
        let index = scOutlet.selectedSegmentIndex
        loadImage(index: index)
    }
    
    func loadImage(index: Int){
        /// Sets up a URLSession and gets the data from the URL, if there is data then the image retrieved is set as the image in the ImageView
        let urlString = baseImgURL + images![index].filename
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
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        /// Forces dark mode
        overrideUserInterfaceStyle = .dark
        
        titleLabel.text = currentTitle ?? "No Title"
        artistLabel.text = artist ?? "No Artist"
        infoTextView.text = info ?? "No Info"
        
        /// If there is only one image, hide the image selector
        if images != nil {
            if images!.count == 1 {
                scOutlet.isHidden = true
            }
        }
        
        numberOfImg = images?.count ?? 0
        
        /// If there are more than 2 images then add more segments
        if numberOfImg > 2 {
            for x in 3...numberOfImg {
                scOutlet.insertSegment(withTitle: "Image \(x)", at: x, animated: true)
            }
        }
        
        /// Loads the image into the ImageView
        loadImage(index: 0)
        
    }
    
}
