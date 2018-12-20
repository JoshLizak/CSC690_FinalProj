//
//  MapManager.swift
//  testing
//
//  Created by Joshua Lizak on 12/19/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import Foundation
import MapKit

class MapManager: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var mapView = MKMapView()
    let locationManager = CLLocationManager()
    let regionMeters: Double = 1000
    var showCurrentLocation = true
    
    func initalize(map: MKMapView){
        mapView.delegate = self
        self.mapView = map
    }
    
    /* LOCATION FUNCTIONS */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if showCurrentLocation {
            centerMapOnUserLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAvaliable()
    }
    
    func checkLocationAvaliable() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAvaliableForApp()
        } else {
            //check if there is no location available for the whole phone
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
    
    func centerMapOnUserLocation() {
        if var location = locationManager.location?.coordinate {
            location.latitude -= 0.003
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func centerMapOnLocation(point: MKPointAnnotation){
        var location = point.coordinate
        location.latitude -= 0.003
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
        mapView.setRegion(region, animated: true)
    }
    
    /* ERROR */
    func errorDialogue(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel) { (_) in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
