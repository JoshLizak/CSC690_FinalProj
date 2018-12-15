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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var saveLocationButton: UIButton!
    
    let locationManager = CLLocationManager()
    let regionMeters: Double = 1000
    
    var showCurrentLocation = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default // .default
    }
    
    
    /* LOCATION FUNCTIONS */
    @IBAction func centerLocationButtonPressed(_ sender: Any) {
        centerMapOnUserLocation()
        if showCurrentLocation {
            showCurrentLocation = false
        } else {
            showCurrentLocation = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAvaliable()
        centerMapOnUserLocation()
        saveLocationButton.layer.cornerRadius = 5
    }
    
    func checkLocationAvaliable() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAvaliableForApp()
        } else {
            //check if there is no location available for the whole phone
        }
    }
    
    func checkLocationAvaliableForApp() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            errorDialogue(title: "Location Services Denied", message: "Allow location services in system settings.")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            errorDialogue(title: "Location Services Restricted", message: "Check location services in system settings.")

            break
        case .authorizedAlways:
            break
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerMapOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    /* Error Dialogue */
    func errorDialogue(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel) { (_) in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if showCurrentLocation {
            guard let location = locations.last else { return }
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region  = MKCoordinateRegion.init(center: center, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAvaliable()
    }
}

