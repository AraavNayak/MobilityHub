//
//  ViewController.swift
//  MobilityHub
//
//  Created by Araav Nayak on 10/25/23.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dropdownView: UIView!
    let locationManager:CLLocationManager = CLLocationManager()
    var displayedOptions = false
    @IBOutlet weak var curLocStr: UILabel!
    var acceptingInput = false
    //var test = UISearchBar()
    
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropdownViewTopYConstraint: NSLayoutConstraint!
    @IBOutlet weak var serviceQuery: UISearchBar!
    var initSearchBarY: CGFloat = 0
    var userQuery: String = ""
    
    let latitude: CLLocationDegrees = 37.2
    let longitude: CLLocationDegrees = 22.9
    
    var userLoc: CLLocation = CLLocation(latitude: CLLocationDegrees(37.2), longitude: CLLocationDegrees(22.9))
    //var closestLocations = ["Option A", "Option B", "Option C", "Option D", "Option E"]
    var closestLocations: [MKMapItem] = []
    var tableView: UITableView = UITableView()
    
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    var origSearchbarconstraint: CGFloat = 0
    var hostingController = UIHostingController(rootView: Text("Default View"))
    
    @IBOutlet weak var locationDetails: UILabel!
    @IBOutlet weak var distanceDetails: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchBarY = searchBarTopConstraint.constant
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.showsUserLocation = true
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(displayKeyboard))
        gestureRecognizer.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(gestureRecognizer)
        view.isUserInteractionEnabled = true
        serviceQuery.isUserInteractionEnabled = true
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        serviceQuery.delegate = self
        print(dropdownView.frame.origin.y)
        locationDetails.text = ""
        distanceDetails.text = ""
        
    }
    
    
    
    @objc func displayKeyboard() {
        
        if acceptingInput {
            //Lowers the keyboard
            userQuery = serviceQuery.text!
            view.endEditing(true)
            acceptingInput = false
            var newY2: CGFloat = 0
            searchBarTopConstraint.constant = newY2
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            displayResults()
        } else {
            
            //view.endEditing(true)
            
            var newY2: CGFloat = -257
            //            dropdownViewTopYConstraint.constant = newY
            searchBarTopConstraint.constant = newY2
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            serviceQuery.becomeFirstResponder()
            //self.view.bringSubviewToFront(serviceQuery)
            //self.dropdownView.bringSubviewToFront(serviceQuery)
            serviceQuery.placeholder = "Example: \"Coffee shops near me\""
            acceptingInput = true
            view.bringSubviewToFront(serviceQuery)
        }
    }
    
    
    func test(currentLoc: CLLocation, destination: MKMapItem) {
        
        let placemark = MKPlacemark(coordinate: currentLoc.coordinate)
        let currLoc = MKMapItem(placemark: placemark)
        
        let request = MKDirections.Request()
        request.source = currLoc
        request.destination = destination
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if let route = response?.routes.first {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        userQuery = serviceQuery.text!
        view.endEditing(true)
        acceptingInput = false
        searchBarTopConstraint.constant = -45
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        dropdownView.bringSubviewToFront(serviceQuery)
        displayResults()
    }
    
    
    func displayResults() {
        async {
            await findNearestPublicTransportation(to: userLoc, query: userQuery) { str in
                print(str)
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        self.closestLocations = str
                        self.tableView.reloadData()
                        for item in str {
                            self.displayMapItemOnMapView(mapItem: item)
                        }
                    }
                }
            }
        }
        dropdownView.addSubview(tableView)
        tableView.frame = dropdownView.bounds
        dropdownView.layoutIfNeeded()
    }
    
    
    func findNearestPublicTransportation(to userLocation: CLLocation, query: String, completion: @escaping ([MKMapItem]) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let coordinate = userLocation.coordinate
        let region = MKCoordinateRegion(center: coordinate, span: span)
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                print("Error searching for public transportation: \(error)")
                return
            }
            var strs = [MKMapItem]()
            if let items = response?.mapItems {
                let sortedItems = items.sorted { (item1, item2) -> Bool in
                    let location1 = item1.placemark.location
                    let location2 = item2.placemark.location
                    return location1?.distance(from: userLocation) ?? 0 < location2?.distance(from: userLocation) ?? 0
                }
                for item in sortedItems {
                    strs.append(item)
                }
            }
            completion(strs)
        }
    }
    
    func displayMapItemOnMapView(mapItem: MKMapItem) {
        let annotation = MKPointAnnotation()
        annotation.title = mapItem.name
        annotation.coordinate = mapItem.placemark.coordinate
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return closestLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row < closestLocations.count {
            cell.textLabel?.text = closestLocations[indexPath.row].name
        } else {
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Displays route to the location from the specified index
        mapView.removeOverlays(mapView.overlays)
        mapViewHeight.constant = 570
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        displayLocationDetails(mapItem: self.closestLocations[indexPath.row]);
        test(currentLoc: userLoc, destination: closestLocations[indexPath.row])
    }
    
    
    func displayLocationDetails(mapItem: MKMapItem) {
        //Displays distance and street addess
        let placemark = mapItem.placemark
        let location = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        async {
            await getStreetAddressFromLocation(location: location) { str in
                self.locationDetails.text = "Address: " + str!
                var number = (location.distance(from: self.userLoc) * 0.000621371)
                var numStr: String = ""
                var numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.maximumFractionDigits = 2
                if let roundedNumberString = numberFormatter.string(from: NSNumber(value: number)) {
                    if let roundedNumber = numberFormatter.number(from: roundedNumberString) {
                        //print(roundedNumber)
                        numStr = (String)(describing: roundedNumber)
                    }
                }
                self.distanceDetails.text = "Distance: " + numStr + " miles"
            }
        }
    }
  
    func getStreetAddressFromLocation(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil)
            } else if let placemark = placemarks?.first {
                if let streetAddress = placemark.thoroughfare {
                    completion(streetAddress)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }

    func getCityFromLocation(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil)
            } else if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    completion(city)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if displayedOptions==false {
            if let userLocation = locations.last {
                userLoc = userLocation
                displayedOptions = true
                var address = ""
                var city = ""
                getStreetAddressFromLocation(location: userLocation) { streetAddress in
                    if let streetAddress = streetAddress {
                        address = "\(streetAddress)"
                        self.curLocStr.text = address
                        print(address)
                    } else {
                        print("Street address not found")
                    }
                }
                getCityFromLocation(location: userLocation) { cityLoc in
                    if let cityLoc = cityLoc {
                        city = "\(cityLoc)"
                        self.curLocStr.text = self.curLocStr.text! + ", " + city
                    } else {
                        print("City not found")
                    }
                }
            }
        }
    }
}
