//
//  DetailViewController.swift
//  TableAndDetail
//
//  Created by Mateusz Golebiowski on 24/10/2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var personName: String = ""
    var room: String = ""
    var email: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLabel.text = personName
        roomLabel.text = room
        emailLabel.text = email

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
