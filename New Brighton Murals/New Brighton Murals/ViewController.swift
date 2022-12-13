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
    var murals: muralsData?
    var isData = true
    var muralImage: UIImage?
    var currentLocation: CLLocation?
    
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
        currentLocation = locationOfUser
        sortMurals()
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
        
        if (self.startTrackingUser == true) {
            self.map.setCenter(location, animated: true)
            
        }
        
    }
    
    // This method sets the startTrackingUser bool to true. Once it's true, subsequent calls to didUpdateLocations will cause the map to centre on the user's location.
    @objc func startUserTracking(){
        self.startTrackingUser = true
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        let muralIndex = murals?.newbrighton_murals.firstIndex(where: {$0.title == annotation.title})
        selectedMural = muralIndex!
        performSegue(withIdentifier: "viewMural", sender: self)
    }
    
    // MARK: Table related stuff
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (murals?.newbrighton_murals.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! CustomCell
        
        if (murals?.newbrighton_murals[indexPath.row].enabled == "0"){
            cell.isHidden = true
        }
        
        cell.titleLbl.text = murals?.newbrighton_murals[indexPath.row].title ?? "No Title"
        cell.artistLbl.text = murals?.newbrighton_murals[indexPath.row].artist ?? "No Authors"
        
        /// Setting favourites using image inside accessory view
        
        let isFav = checkFavourites(id: (murals?.newbrighton_murals[indexPath.row].id)!)
        
        if (isFav){
            cell.favImg.isHidden = false
        } else {
            cell.favImg.isHidden = true
        }
        
        if (murals?.newbrighton_murals[indexPath.row].thumbnail != nil) {
            let urlString = murals?.newbrighton_murals[indexPath.row].thumbnail
            
            cell.setImage(urlString: urlString!)
            
        }
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
            let id = (murals?.newbrighton_murals[indexPath.row].id)!
            changeFavourite(id: id)
        }
        
        favouriteAction.backgroundColor = .systemBlue
        
        return [favouriteAction]
    }
    
    //    MARK: Helper functions
    
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
        updateTheTable()
    }
    
    func sortMurals(){
        
        let original = self.murals
        
        self.murals?.newbrighton_murals.sort(by: { CLLocation(latitude: Double($0.lat!)!, longitude: Double($0.lon!)!).distance(from: currentLocation!) < CLLocation(latitude: Double($1.lat!)!, longitude: Double($1.lon!)!).distance(from: currentLocation!)})
        
        if original?.newbrighton_murals != self.murals?.newbrighton_murals {
            updateTheTable()
        }
    }
    
    func removeNonEnabled(){
        let countNum = (murals?.newbrighton_murals.count)! - 1
        var remove: [Int] = []
        for x in 0...countNum {
            if murals?.newbrighton_murals[x].enabled == "0" {
                remove.append(x)
            }
        }
        
        if remove.count > 0 {
            for r in remove {
                murals?.newbrighton_murals.remove(at: r)
            }
        }
    }
    
    func saveMuralData(){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.murals)
            UserDefaults.standard.set(data, forKey: "storedMurals")
        } catch let jsonErr {
            print("Error encoding data", jsonErr)
        }
    }
    
    func retrieveMuralData() {
        let muralData = UserDefaults.standard.object(forKey: "storedMurals")
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(muralsData.self, from: muralData as! Data)
            self.murals = data
            self.removeNonEnabled()
        } catch {
            print("Error decoding data")
        }
    }
    
    func addMarkers(){
        /// Code below adds pins to the map with all the murals
        for mural in self.murals!.newbrighton_murals {
            
            let myPin = MKPointAnnotation()
            
            myPin.coordinate = CLLocationCoordinate2D(latitude: Double(mural.lat!)!, longitude: Double(mural.lon!)!)
            myPin.title = mural.title
            
            self.map.addAnnotation(myPin)
            
        }
    }
    
    func replaceData(newData: muralsData){
        for i in newData.newbrighton_murals{
            for j in self.murals!.newbrighton_murals{
                if i.id == j.id {
                    let index = self.murals?.newbrighton_murals.firstIndex(of: j)
                    murals!.newbrighton_murals[index!] = i
                    print("Replaced data of \(i.id)")
                }
            }
        }
    }
    
    // MARK: View related stuff
    
    func loadAPIData(){
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
                    
                    self.removeNonEnabled()
                    self.saveMuralData()
                    self.addMarkers()
                    
                    DispatchQueue.main.async {
                        self.updateTheTable()
                    }
                    
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
                
            }.resume()
        }
    }
    
    func loadNewAPIData(lastChecked: String){
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/nbm/data2.php?class=newbrighton_murals&\(lastChecked)") {
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else {
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let muralsList = try decoder.decode(muralsData.self, from: jsonData)
                    let newMuralData = muralsList
                    
                    self.replaceData(newData: newMuralData)
                    
                    self.removeNonEnabled()
                    self.saveMuralData()
                    self.addMarkers()
                    
                    DispatchQueue.main.async {
                        self.updateTheTable()
                    }
                    
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
                
            }.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: date)
        
        let userDefaults = UserDefaults.standard
        let favData = userDefaults.object(forKey: "favArr")
        let muralData = userDefaults.object(forKey: "storedMurals")
        var lastChecked = userDefaults.object(forKey: "lastModified") as? String
        
        if lastChecked == nil {
            lastChecked = "2022-09-15"
        }
        
        if (favData == nil){
            isData = false
        } else {
            favourites = favData as! [String]
        }
        
        if (muralData == nil) {
            loadAPIData()
            userDefaults.set(currentDate, forKey: "lastModified")
        } else {
            retrieveMuralData()
            self.addMarkers()
            
            if (currentDate != lastChecked){
                loadNewAPIData(lastChecked: "lastModified=\(lastChecked!)")
                userDefaults.set(currentDate, forKey: "lastModified")
            }
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
        
    }
    
    @IBAction func unwindSegue(unwindSegue:UIStoryboardSegue){
        }
    
}
