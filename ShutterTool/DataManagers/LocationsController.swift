//
//  LocationsController.swift
//  ShutterTool
//
//  Created by Joshua Lizak on 12/14/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class LocationsController {
    
    let userDefaults = UserDefaults.standard
    final let userDefaultsKey = "MyLocations"
    var myLocations: [NSManagedObject] = []
    
    
    /* Saving and Modifying the MyLocations in CoreData */
    private func saveToCoreData(point: MKPointAnnotation, name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)!
        
        let location = NSManagedObject(entity: entity, insertInto: managedContext)
        
        location.setValue(name, forKey: "name")
        location.setValue(point.coordinate.latitude, forKey: "latitude")
        location.setValue(point.coordinate.longitude, forKey: "longitude")
        
        do {
            try managedContext.save()
            myLocations.append(location)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func loadFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        do {
            myLocations = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteLocation(indexPath: IndexPath) {
        // remove from core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(myLocations[indexPath.row])
        do {
            try managedContext.save()
        } catch {
            print("error : \(error)")
        }
        
        // remove from local location array
        myLocations.remove(at: indexPath.row)
    }
    
    func editLocation(indexPath: IndexPath){
        // change in CoreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let location = 
        
        managedContext.delete(myLocations[indexPath.row])
        do {
            try managedContext.save()
        } catch {
            print("error : \(error)")
        }
        
        // change in local array
    }
    
    func saveNewLocation(locationManager: CLLocationManager, mapView: MKMapView, name: String) {
        // create coordinates from location and save it as a point
        let userCurrentCoordinates = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        let pinForUserLocation = MKPointAnnotation()
        pinForUserLocation.coordinate = userCurrentCoordinates
        pinForUserLocation.title = name
        
        // add point to the map
        mapView.addAnnotation(pinForUserLocation)
        mapView.showAnnotations([pinForUserLocation], animated: false)
        
        // save data to disk
        saveToCoreData(point: pinForUserLocation, name: name)
    }
    
    func addSavedLocationsToMapView(mapView: MKMapView) {
        for object in myLocations{
            let point = MKPointAnnotation()
            point.title = object.value(forKeyPath: "name") as? String ?? ""
            point.coordinate.latitude = object.value(forKey: "latitude") as? Double ?? 0.0
            point.coordinate.longitude = object.value(forKey: "longitude") as? Double ?? 0.0
        }
    }
    
    func getLocationName(indexPath: IndexPath) -> String {
        return myLocations[indexPath.row].value(forKeyPath: "name") as? String ?? ""
    }
}
