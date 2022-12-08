//
//  ViewController.swift
//  New Brighton Murals
//
//  Created by Mateusz Golebiowski on 29/11/2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    var favourites: [String] = []
    var selectedMural = 0
    var murals: muralsData? = nil
    var isData = true
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var table: UITableView!
    
    // MARK: Map & Location related stuff
    
    var locationManager = CLLocationManager()
    var firstRun = true
    var startTrackingUser = false
    
    func updateTheTable() {
        table.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Returns an array of locations, generally we want the first one (usually there's only 1 anyway)
        let locationOfUser = locations[0]
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        // Gets the user's location
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if (firstRun) {
            firstRun = false
            let latDelta: CLLocationDegrees = 0.0025
            let lonDelta: CLLocationDegrees = 0.0025
            // A span defines how large an area is depicted on the map
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            
            // A region defines a centre and a size of area covered
            let region = MKCoordinateRegion(center: location, span: span)
            
            // Make the map show the defined region
            self.map.setRegion(region, animated: true)
            
            
            // Following code prevents a zooming bug
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startUserTracking), userInfo: nil, repeats: false)
        }
        
        if (startTrackingUser == true) {
            map.setCenter(location, animated: true)
            
        }
        
    }
    
    // This method sets the startTrackingUser bool to true. Once it's true, subsequent calls to didUpdateLocations will cause the map to centre on the user's location.
    @objc func startUserTracking(){
        startTrackingUser = true
    }
    
    // MARK: Table related stuff
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (murals?.newbrighton_murals.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! CustomCell
        var content = UIListContentConfiguration.subtitleCell()
        content.text = murals?.newbrighton_murals[indexPath.row].title ?? "No Title"
        content.secondaryText = murals?.newbrighton_murals[indexPath.row].artist ?? "No Authors"
        
        let isFav = checkFavourites(id: (murals?.newbrighton_murals[indexPath.row].id)!)
        
        if (isFav){
            let starBtn = UIImage(named: "gold-star.png")
            let imageView = UIImageView(image: starBtn)
            cell.accessoryView = imageView
        }
        
//        let starBtn = UIImage(named: "gold-star.png")
//        let imageView = UIImageView(image: starBtn)
//        cell.accessoryView = imageView
        
//        let starButton = UIButton(type: .system)
//        starButton.setImage(UIImage(named: "grey_star.png"), for: .normal)
//        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        cell.accessoryView = starButton
        
        if (murals?.newbrighton_murals[indexPath.row].thumbnail != nil) {
            var image: UIImage?
            let urlString = murals?.newbrighton_murals[indexPath.row].thumbnail

            let url = NSURL(string: urlString!)! as URL
            if let imageData: NSData = NSData(contentsOf: url){
                image = UIImage(data: imageData as Data)
            }

            content.image = image
        }
        
//        if (murals?.newbrighton_murals[indexPath.row].thumbnail != nil) {
//            var image: UIImage?
//            let urlString = murals?.newbrighton_murals[indexPath.row].thumbnail
//            let url = NSURL(string: urlString!)! as URL
//
//            URLSession.shared.dataTask(with: url){ (data, response, error) in
//                if error != nil {
//                    print(error!)
//                }
//
//                image = UIImage(data: data! as Data)
//            }
//
//            content.image = image
//
//        }
        
        cell.contentConfiguration = content
        return cell
    }
    	
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        selectedMural = indexPath.row
        performSegue(withIdentifier: "viewMural", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mvc = segue.destination as! MuralViewController
        mvc.currentTitle = murals?.newbrighton_murals[selectedMural].title
        mvc.artist = murals?.newbrighton_murals[selectedMural].artist
        mvc.info = murals?.newbrighton_murals[selectedMural].info
        mvc.images = murals?.newbrighton_murals[selectedMural].images
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let favouriteAction = UITableViewRowAction(style: .normal, title: "Favourite") { [self] _, indexPath in
            let id = (murals?.newbrighton_murals[selectedMural].id)!
            changeFavourite(id: id)
        }
        
        favouriteAction.backgroundColor = .systemBlue
        
        return [favouriteAction]
    }
    
    func checkFavourites(id: String) -> Bool{
        if favourites.contains(id){
            return true
        } else {
            return false
        }
    }
    
    func changeFavourite(id: String){
        if favourites.contains(id) {
            let newFavs = favourites.filter { $0 != id }
            favourites = newFavs
            UserDefaults.standard.set(favourites, forKey: "favArr")
        } else {
            favourites.append(id)
            UserDefaults.standard.set(favourites, forKey: "favArr")
        }
        print(id)
        updateTheTable()
    }
    
    // MARK: View related stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        let favData = userDefaults.object(forKey: "favArr")
        
        if (favData == nil){
            isData = false
        } else {
            favourites = favData as! [String]
        }
        
        // Make this view controller a delegate of the Location Manager, so that it is able to call functions provided in this view controller
        locationManager.delegate = self as CLLocationManagerDelegate
        
        // Set the level of accuracy for the user's location
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        
        // Ask the location manager to request authorisation from the user.
        locationManager.requestWhenInUseAuthorization()
        
        // Once the user's location is being provided then ask for updates when the user moves around
        locationManager.startUpdatingLocation()
        
        // Configures the map to show the user's location (with a blue dot)
        map.showsUserLocation = true
        
        
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/nbm/data2.php?class=newbrighton_murals") {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else {
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let muralsList = try decoder.decode(muralsData.self, from: jsonData)
                    self.murals = muralsList
                    DispatchQueue.main.async {
                        self.updateTheTable()
                    }
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
                
            }.resume()
        }
        
        
    }
    
    
    
    
}
