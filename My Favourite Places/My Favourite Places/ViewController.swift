//
//  ViewController.swift
//  My Favourite Places
//
//  Created by Mateusz Golebiowski on 15/11/2022.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(currentPlace)
    }


}

