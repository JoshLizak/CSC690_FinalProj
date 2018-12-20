//
//  FirstViewController.swift
//  ShutterTool
//
//  Created by Joshua Lizak on 12/7/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

let savedLocationManager = SavedLocationManager()


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var NearbyTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var saveLocationButton: UIButton!

    /* Variables */
    let mapManager = MapManager()
    
    // Set statusbar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default // .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapManager.initalize(map: mapView)
        mapManager.checkLocationAvaliable()
        mapManager.centerMapOnUserLocation()
        
        saveLocationButton.layer.cornerRadius = 6
        NearbyTableView.layer.cornerRadius = 10
        
        savedLocationManager.loadFromCoreData()
        savedLocationManager.addSavedLocationsToMapView(mapView: mapManager.mapView)
        savedLocationManager.filterNearbyLocations(locationManager: mapManager.locationManager)
        
        NearbyTableView.delegate = self
        NearbyTableView.dataSource = self
        NearbyTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        savedLocationManager.addSavedLocationsToMapView(mapView: mapManager.mapView)
        savedLocationManager.filterNearbyLocations(locationManager: mapManager.locationManager)
        NearbyTableView.reloadData()
    }
    
    /* Nearby Table View Functions */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.9)
        cell.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.0)
        cell.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "homeNearby")
        cell.textLabel?.text = savedLocationManager.getNearbyLocationName(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationObject = myLocations[indexPath.row]
        let point = MKPointAnnotation()
        point.coordinate.latitude = locationObject.value(forKey: "latitude") as? Double ?? 0.0
        point.coordinate.longitude = locationObject.value(forKey: "longitude") as? Double ?? 0.0
        mapManager.centerMapOnLocation(point: point)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /* LOCATION FUNCTIONS */
    @IBAction func centerLocationButtonPressed(_ sender: Any) {
        mapManager.centerMapOnUserLocation()
        if mapManager.showCurrentLocation {
            mapManager.showCurrentLocation = false
        } else {
            mapManager.showCurrentLocation = true
        }
    }
    
    @IBAction func saveLocationButton(_ sender: Any) {
        newLocationDialogue()
    }
    
    /* Error Dialogue */
    func errorDialogue(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel) { (_) in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func newLocationDialogue(){
        let alertController = UIAlertController(title: "Save Location", message: "Name this location.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            let locationName = (alertController.textFields?[0].text)
            let locationNotes = (alertController.textFields?[1].text)
            if locationName?.count == 0 {
                self.newLocationDialogue()
            } else {
                savedLocationManager.saveNewLocation(locationManager: self.mapManager.locationManager, mapView: self.mapView, name: locationName!, notes: locationNotes!)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Notes"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}


