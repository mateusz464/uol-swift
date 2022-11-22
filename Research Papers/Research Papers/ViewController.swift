//
//  ViewController.swift
//  Research Papers
//
//  Created by Mateusz Golebiowski on 22/11/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var paperTitle: String? = nil
    var year: String? = nil
    var author: String? = nil
    var email: String? = nil
    var abstract: String? = nil
    var url: URL? = nil
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var abstractTextView: UITextView!
    
    @IBOutlet weak var urlTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        titleLabel.text! += paperTitle!
        yearLabel.text! += year!
        authorLabel.text! += author!
        emailLabel.text! += email!
        abstractTextView.text! += abstract!
        
        if (url != nil){
            urlTextView.text = url!.absoluteString
        } else {
            urlTextView.text = "No URL"
        }
    }


}

