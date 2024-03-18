////
////  ViewController.swift
////  MobilityHub
////
////  Created by Araav Nayak on 3/16/24.
////
//
//import UIKit
//import MapKit
//import CoreLocation
//import SwiftUI
//
//
//class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
//    
//    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var dropdownView: UIView!
//    let locationManager:CLLocationManager = CLLocationManager()
//    var displayedOptions = false
//    @IBOutlet weak var curLocStr: UILabel!
//    var acceptingInput = false
//    //var test = UISearchBar()
//    
//    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var dropdownViewTopYConstraint: NSLayoutConstraint!
//    @IBOutlet weak var serviceQuery: UISearchBar!
//    var initSearchBarY: CGFloat = 0
//    var userQuery: String = ""
//    
//    let latitude: CLLocationDegrees = 37.2
//    let longitude: CLLocationDegrees = 22.9
//    
//    var userLoc: CLLocation = CLLocation(latitude: CLLocationDegrees(37.2), longitude: CLLocationDegrees(22.9))
//    //var closestLocations = ["Option A", "Option B", "Option C", "Option D", "Option E"]
//    var closestLocations: [MKMapItem] = []
//    var tableView: UITableView = UITableView()
//    
//    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
//    var origSearchbarconstraint: CGFloat = 0
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initSearchBarY = searchBarTopConstraint.constant
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//        locationManager.delegate = self
//        mapView.showsUserLocation = true
//        mapView.delegate = self
//        mapView.showsUserLocation = true
//        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(displayKeyboard))
//        //let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displayKeyboard))
//        //gestureRecognizer.numberOfTapsRequired = 1
//        //gestureRecognizer.numberOfTouchesRequired = 1;
//        gestureRecognizer.direction = UISwipeGestureRecognizer.Direction.up
//        view.addGestureRecognizer(gestureRecognizer)
//        
//        //let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(optionSelected))
//        //tableView.addGestureRecognizer(gestureRecognizer)
//        
//        
//        //let searchbarTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(displayKeyboard))
//        //serviceQuery.addGestureRecognizer(searchbarTapRecognizer)
//        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
//        //view.addGestureRecognizer(tapGesture)
//        
////        let gestureRecognizer = UITapGestureRecognizer(target: serviceQuery, action: #selector(raiseKeyboard))
////        gestureRecognizer.numberOfTapsRequired = 1
////        gestureRecognizer.numberOfTouchesRequired = 1;
////        view.addGestureRecognizer(gestureRecognizer)
//        
//        
//        view.isUserInteractionEnabled = true
//        serviceQuery.isUserInteractionEnabled = true
//        
//        tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        serviceQuery.delegate = self
//        //dropdownView.backgroundColor = .red
//        print(dropdownView.frame.origin.y)
//
//        // Add the UITableView as a subview to the view controller's view
//        
//    }
//    
//
//    
//    @objc func displayKeyboard() {
//        
//        if acceptingInput {
//            //Lowers the keyboard
//            userQuery = serviceQuery.text!
//            view.endEditing(true)
//            //serviceQuery.resignFirstResponder()
//            acceptingInput = false
//            //mapViewHeight.constant = 638.33
//            //UIView.animate(withDuration: 0.3) {
//            //    self.view.layoutIfNeeded()
//            //}
//            var newY2: CGFloat = 0
//            searchBarTopConstraint.constant = newY2
//            UIView.animate(withDuration: 0.3) {
//                self.view.layoutIfNeeded()
//            }
//            displayResults()
//        } else {
//            origSearchbarconstraint = 8
//            //mapViewHeight.constant = 500
//            UIView.animate(withDuration: 0.3) {
//                self.view.layoutIfNeeded()
//            }
//            //view.endEditing(true)
//            
//            //Displays the keyboard
////            let newY: CGFloat = 265
//            var newY2: CGFloat = -257
////            dropdownViewTopYConstraint.constant = newY
//            searchBarTopConstraint.constant = newY2
//            UIView.animate(withDuration: 0.3) {
//                self.view.layoutIfNeeded()
//            }
////            let newHeight: CGFloat = 265 // Change this to your desired increased height
////
////            UIView.animate(withDuration: 0.3) {
////                self.view.layoutIfNeeded()
////            }
//            
//            
//            
//            serviceQuery.becomeFirstResponder()
//            //self.view.bringSubviewToFront(serviceQuery)
//            //self.dropdownView.bringSubviewToFront(serviceQuery)
//            serviceQuery.placeholder = "Example: \"Coffee shops near me\""
//            acceptingInput = true
//            view.bringSubviewToFront(serviceQuery)
//        }
//    }
//    
//    
//    func test() {
//        let request = MKDirections.Request()
//        request.source = sourceMapItem
//        request.destination = destinationMapItem
//        request.transportType = .automobile // You can specify other transport types as well, like .walking or .transit
//
//        let directions = MKDirections(request: request)
//        directions.calculate { (response, error) in
//            if let route = response?.routes.first {
//                self.mapView.addOverlay(route.polyline)
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//            }
//        }
//        
//    }
//    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if overlay is MKPolyline {
//            let renderer = MKPolylineRenderer(overlay: overlay)
//            renderer.strokeColor = UIColor.blue
//            renderer.lineWidth = 5.0
//            return renderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
//    
//    
// 
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//            //view.endEditing(true)
//        userQuery = serviceQuery.text!
//        view.endEditing(true)
//        //serviceQuery.resignFirstResponder()
//        acceptingInput = false
//        //mapViewHeight.constant = 638.33
//        //UIView.animate(withDuration: 0.3) {
//        //    self.view.layoutIfNeeded()
//        //}
//        searchBarTopConstraint.constant = -45
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//        dropdownView.bringSubviewToFront(serviceQuery)
//        
//        displayResults()
//    }
//        
//
//    func displayResults() {
//        
//        async {
//            await findNearestPublicTransportation(to: userLoc, query: userQuery) { str in
//                print(str)
//                DispatchQueue.global().async {
//                    DispatchQueue.main.async {
//                        // Reload the table view to reflect the updated data
//                        self.closestLocations = str
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//        }
//        
////        let tableViewFrame = CGRect(x: 0, y: 600, width: view.bounds.size.width, height: 100)
//
//        //tableView.frame = tableViewFrame
//        
//        //apView.addSubview(tableView)
//        
//        //dropdownView.addSubview(tableView)
//        
//        
//        //tableView.frame.topMar
//        //let tableViewY: CGFloat = 0
//        //let tableViewHeight = dropdownView.frame.size.height - tableViewY
//        //tableView.frame = CGRect(x: 0, y: 0, width: dropdownView.frame.size.width, height: tableViewHeight)
//
//        //tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////        tableView.frame = CGRect(x: 0, y: 0, width: dropdownView.frame.size.width, height: dropdownView.frame.size.height)
////        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////
////        // Activate the constraint
////        //NSLayoutConstraint.activate([topConstraint])
////
//        dropdownView.addSubview(tableView)
//        
//        tableView.frame = dropdownView.bounds
//        dropdownView.layoutIfNeeded()
//    }
//    
// 
//    func findNearestPublicTransportation(to userLocation: CLLocation, query: String, completion: @escaping ([MKMapItem]) -> Void) {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = query
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let coordinate = userLocation.coordinate
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//        request.region = region
//        let search = MKLocalSearch(request: request)
//        search.start { (response, error) in
//            if let error = error {
//                print("Error searching for public transportation: \(error)")
//                return
//            }
//            var strs = [MKMapItem]()
//            if let items = response?.mapItems {
//                let sortedItems = items.sorted { (item1, item2) -> Bool in
//                    let location1 = item1.placemark.location
//                    let location2 = item2.placemark.location
//                    return location1?.distance(from: userLocation) ?? 0 < location2?.distance(from: userLocation) ?? 0
//                }
//                for item in sortedItems {
//                    strs.append(item)
//                    //if let itemName = item.name {
//                        //strs.append(itemName)
//                      //  print(itemName)
//                    //}
//                }
//            }
////            print("Here is what gets returnd form the method: ")
////            print(strs.description)
//            completion(strs)
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        if indexPath.row < closestLocations.count {
//            cell.textLabel?.text = closestLocations[indexPath.row].name
//            //cell.detailTextLabel?.text = closestLocations[indexPath.row].placemark.locality
//        } else {
//            cell.textLabel?.text = ""
//        }
//        //cell.textLabel?.text = "Hello World"
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //show directions to the location from the specified index
//        print("You tapped me!")
//    }
//    
//  
//    
//    
//  
//    func getStreetAddressFromLocation(location: CLLocation, completion: @escaping (String?) -> Void) {
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//            if let error = error {
//                print("Geocoding error: \(error.localizedDescription)")
//                completion(nil)
//            } else if let placemark = placemarks?.first {
//                if let streetAddress = placemark.thoroughfare {
//                    completion(streetAddress)
//                } else {
//                    completion(nil) //No street address found
//                }
//            } else {
//                completion(nil) //No placemarks found
//            }
//        }
//    }
//
//    func getCityFromLocation(location: CLLocation, completion: @escaping (String?) -> Void) {
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//            if let error = error {
//                print("Geocoding error: \(error.localizedDescription)")
//                completion(nil)
//            } else if let placemark = placemarks?.first {
//                if let city = placemark.locality {
//                    completion(city)
//                } else {
//                    completion(nil) // No city found
//                }
//            } else {
//                completion(nil) // No placemarks found
//            }
//        }
//    }
//    
//    
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if displayedOptions==false {
//            if let userLocation = locations.last {
//                userLoc = userLocation
//                displayedOptions = true
//                var address = ""
//                var city = ""
//                getStreetAddressFromLocation(location: userLocation) { streetAddress in
//                    if let streetAddress = streetAddress {
//                        address = "\(streetAddress)"
//                        self.curLocStr.text = address
//                        print(address)
//                    } else {
//                        print("Street address not found")
//                    }
//                }
//                getCityFromLocation(location: userLocation) { cityLoc in
//                    if let cityLoc = cityLoc {
//                        city = "\(cityLoc)"
//                        self.curLocStr.text = self.curLocStr.text! + ", " + city
//                    } else {
//                        print("City not found")
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    
//   
//    
//    
//    
//    
//    
//    
//    
//}
//
