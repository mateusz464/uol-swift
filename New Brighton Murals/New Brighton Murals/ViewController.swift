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
        /// Returns an array of locations, generally we want the first one (usually there's only 1 anyway)
        let locationOfUser = locations[0]
        currentLocation = locationOfUser
        sortMurals()
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        /// Gets the user's location
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if (firstRun) {
            firstRun = false
            let latDelta: CLLocationDegrees = 0.0025
            let lonDelta: CLLocationDegrees = 0.0025
            /// A span defines how large an area is depicted on the map
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            
            /// A region defines a centre and a size of area covered
            let region = MKCoordinateRegion(center: location, span: span)
            
            // Make the map show the defined region
            self.map.setRegion(region, animated: true)
            
            /// Following code prevents a zooming bug
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startUserTracking), userInfo: nil, repeats: false)
            
        }
        
        if (self.startTrackingUser == true) {
            self.map.setCenter(location, animated: true)
            
        }
        
    }
    
    /// This method sets the startTrackingUser bool to true. Once it's true, subsequent calls to didUpdateLocations will cause the map to centre on the user's location.
    @objc func startUserTracking(){
        self.startTrackingUser = true
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        /// If the user pressed on a pin then it will take the user to the MuralViewController
        let muralIndex = murals?.newbrighton_murals.firstIndex(where: {$0.title == annotation.title})
        selectedMural = muralIndex!
        performSegue(withIdentifier: "viewMural", sender: self)
    }
    
    // MARK: Table related stuff
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// Returns the amount of murals or 0 if there are no murals
        return (murals?.newbrighton_murals.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Creates the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! CustomCell
        
        /// Sets the text from the mural API data, if there is no data then the preset will be displayed
        cell.titleLbl.text = murals?.newbrighton_murals[indexPath.row].title ?? "No Title"
        cell.artistLbl.text = murals?.newbrighton_murals[indexPath.row].artist ?? "No Authors"
        
        /// Receives a bool from the checkFavourites func
        let isFav = checkFavourites(id: (murals?.newbrighton_murals[indexPath.row].id)!)
        
        /// If isFav is true then the star image will be shown, else it will be hidden
        if (isFav){
            cell.favImg.isHidden = false
        } else {
            cell.favImg.isHidden = true
        }
        
        /// If there is a thumbnail in the mural API data then set the image as the thumbnail
        if (murals?.newbrighton_murals[indexPath.row].thumbnail != nil) {
            let urlString = murals?.newbrighton_murals[indexPath.row].thumbnail
            
            cell.setImage(urlString: urlString!)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// If a user presses on a row then it sets selectedMural as that row and then switches to the MuralViewController
        selectedMural = indexPath.row
        performSegue(withIdentifier: "viewMural", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Sends the required data from the mural API data to the MuralViewController
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
        /// Adds a swipe action, it allows the user to swipe a cell and press the favourite button which will mark the mural as a favourite
        let favouriteAction = UITableViewRowAction(style: .normal, title: "Favourite") { [self] _, indexPath in
            let id = (murals?.newbrighton_murals[indexPath.row].id)!
            changeFavourite(id: id)
        }
        
        /// Makes the button blue
        favouriteAction.backgroundColor = .systemBlue
        
        return [favouriteAction]
    }
    
    //    MARK: Helper functions
    
    func checkFavourites(id: String) -> Bool{
        /// Checks if the ID provided is in the favourites array
        if favourites.contains(id){
            return true
        } else {
            return false
        }
    }
    
    func changeFavourite(id: String){
        /// Acts as a switch, if the ID is in the array it removes it from the array
        /// If the ID is not in the array then it gets appended to it
        /// After the action, the array gets saved in userDefaults and the table gets updated
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
        /// Sorts the table based off the new location
        /// Then, it checks if the array was sorted (if anything got changed), if it did then it updates the table
        let original = self.murals
        
        self.murals?.newbrighton_murals.sort(by: { CLLocation(latitude: Double($0.lat!)!, longitude: Double($0.lon!)!).distance(from: currentLocation!) < CLLocation(latitude: Double($1.lat!)!, longitude: Double($1.lon!)!).distance(from: currentLocation!)})
        
        if original?.newbrighton_murals != self.murals?.newbrighton_murals {
            updateTheTable()
        }
    }
    
    func removeNonEnabled(){
        /// For each mural in the muralData it checks if the enabled is 0, if it is then the index gets appended to the remove array
        /// It then checks if anything got appended to the remove array, if it did then it will remove all the murals which indexes are in the remove array
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
        /// Encodes the data and then stores it in core data
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.murals)
            UserDefaults.standard.set(data, forKey: "storedMurals")
        } catch let jsonErr {
            print("Error encoding data", jsonErr)
        }
    }
    
    func retrieveMuralData() {
        /// Retrieves the data from core data and then decodes it back into the muralsData datatype
        /// Then proceeds to call the removeNonEnabled function
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
        /// Adds pins to the map for every mural
        for mural in self.murals!.newbrighton_murals {
            
            let myPin = MKPointAnnotation()
            myPin.coordinate = CLLocationCoordinate2D(latitude: Double(mural.lat!)!, longitude: Double(mural.lon!)!)
            myPin.title = mural.title
            
            self.map.addAnnotation(myPin)
            
        }
    }
    
    func replaceData(newData: muralsData){
        /// For every mural in the provided 'newData' it checks every mural in the current murals and compares if the ID is the same,
        /// If the ID is the same then it replaces the data with the new updated data
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
        /// Sets up a URL session and retrieves the data from the URL
        /// If the data is there then it decodes it and appends it to murals
        /// It then runs the helper functions and updates the table
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
        /// Sets up a URL session and retrieves the data from the URL, however, it only retrieves the NEW data
        /// If the data is there then it decodes it and appends it to murals
        /// It then runs the helper functions and updates the table
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
        /// Forces dark mode
        overrideUserInterfaceStyle = .dark
        
        /// Gets the current date in YYYY-MM-DD format
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: date)
        
        /// Retrieves the data for favourites, murals and lastChecked from core data
        let userDefaults = UserDefaults.standard
        let favData = userDefaults.object(forKey: "favArr")
        let muralData = userDefaults.object(forKey: "storedMurals")
        var lastChecked = userDefaults.object(forKey: "lastModified") as? String
        
        /// If lastChecked if non-existant then set it to a set date - this stops the program crashing in case the data somehow goes missing
        if lastChecked == nil {
            lastChecked = "2022-09-15"
        }
        
        /// If there is favouriteData then it gets set as favourites array
        if (favData != nil){
            favourites = favData as! [String]
        }
        
        /// If the muralData is empty then the loadAPIData function will get called to get the data from the API and then it's saved into core data
        /// If there is data then the retrieveMuralData function is called to get the data from core data, then addMarkers function to add markers
        /// Then it checks if the currentDate is different from the lastChecked date, if the data is different then it will check the API if there is any new data, then the current date is saved in core data
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
    
    /// Ability to unwind the segue
    @IBAction func unwindSegue(unwindSegue:UIStoryboardSegue){
    }
    
}
