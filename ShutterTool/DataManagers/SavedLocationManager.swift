//
//  SavedLocationManager.swift
//  ShutterTool
//
//  Created by Joshua Lizak on 12/14/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import Foundation
import MapKit
import CoreData
import FirebaseDatabase

var myLocations: [NSManagedObject] = []
var allLocations: [NSManagedObject] = []
var nearbyLocations: [NSManagedObject] = []
var selectedIndex: Int = 0

struct LocationStruct: Decodable{
    let name: String
    let notes: String
    let latitude: Double
    let longitude: Double
}

class SavedLocationManager {
    
    let userDefaults = UserDefaults.standard
    final let userDefaultsKey = "MyLocations"
    var deletedLocations: [NSManagedObject] = []
    
    /* Acessing MyLocations in CoreData */
    func saveToCoreData(point: MKPointAnnotation, name: String, notes: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)!

        let location = NSManagedObject(entity: entity, insertInto: managedContext)

        location.setValue(name, forKey: "name")
        location.setValue(notes, forKey: "notes")
        location.setValue(point.coordinate.latitude, forKey: "latitude")
        location.setValue(point.coordinate.longitude, forKey: "longitude")
        
        do {
            try managedContext.save()
            myLocations.append(location)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
//    func saveToFirebase(index: Int){
//        let ref = Database.database().reference()
//        let databaseSize = ref.
//        let locationObject = myLocations[index]
//        let name = locationObject.value(forKey: "name")
//        let notes = locationObject.value(forKey: "notes")
//        let latitude = locationObject.value(forKey: "latitude")
//        let longitude = locationObject.value(forKey: "longitude")
////        ref.child("locations").child(databaseSize).setValue(["name": name, "notes": notes, "latitude": latitude, "longitude": longitude])
//        ref.child("locations").setValue(["name": name, "notes": notes, "latitude": latitude, "longitude": longitude], forKeyPath: databaseSize)
////        ref.child("locations").childByAutoID().setValue(["name": name, "notes": notes, "latitude": latitude, "longitude": longitude])
//    }
//
//    func loadFromFirebase(){
//        let ref = Database.database().reference().child("locations")
//        ref.observeSingleEvent(of: .value) { (snapshot) in
//            print(snapshot.value)
//            do {
//                let myLocation = try JSONDecoder().decode(LocationStruct.self, from: snapshot.value as! Data)
//                print(myLocation.name)
//            } catch let jsonErr {
//                print("Error reading JSON.", jsonErr)
//            }
//        }
    
        
//        ref.child("location").observeSingleEvent(of: .value) { (snapshot) in
//            let locationObject = snapshot.chi
//
//            for object in snapshot.children{
//                l
//
//            }
//        }
//    }
    
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
    
    /* Determining Nearby Locations */
    func filterNearbyLocations(locationManager: CLLocationManager){
        nearbyLocations.removeAll()
        for object in myLocations{
            let point = MKPointAnnotation()
            point.coordinate.latitude = object.value(forKey: "latitude") as? Double ?? 0.0
            point.coordinate.longitude = object.value(forKey: "longitude") as? Double ?? 0.0
            let userLocation = locationManager.location
            let pointLocation = CLLocation(
                latitude:  object.value(forKey: "latitude") as? Double ?? 0.0,
                longitude: object.value(forKey: "longitude") as? Double ?? 0.0
            )
            
            let distance = Double((userLocation?.distance(from: pointLocation) ?? 0.0))
            if  distance < 1000.0 { // nearby location radius
                nearbyLocations.append(object)
            }
        }
    }
    
    /* Modifying MyLocations */
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
        deletedLocations.append(myLocations[indexPath.row])
        myLocations.remove(at: indexPath.row)
    }
    
    func editLocation(selectedIndex: Int, name: String, notes: String, latitude: Double, longitude: Double){
        // modify local array
        let location = myLocations[selectedIndex]
        location.setValue(name, forKey: "name")
        location.setValue(notes, forKey: "notes")
        location.setValue(latitude, forKey: "latitude")
        location.setValue(longitude, forKey: "longitude")
        myLocations[selectedIndex] = location
        
        // modify core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
            myLocations.append(location)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveNewLocation(locationManager: CLLocationManager, mapView: MKMapView, name: String, notes: String) {
        // create coordinates from location and save it as a point
        let userCurrentCoordinates = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        let pinForUserLocation = MKPointAnnotation()
        pinForUserLocation.coordinate = userCurrentCoordinates
        pinForUserLocation.title = name
        
        // add point to the map
        mapView.addAnnotation(pinForUserLocation)
        
        // save data to disk
        saveToCoreData(point: pinForUserLocation, name: name, notes: notes)
    }
    
    /* Display Functions for MyLocation Data */
    func addSavedLocationsToMapView(mapView: MKMapView) {
        for object in myLocations{
            let point = MKPointAnnotation()
            point.title = object.value(forKeyPath: "name") as? String ?? ""
            point.coordinate.latitude = object.value(forKey: "latitude") as? Double ?? 0.0
            point.coordinate.longitude = object.value(forKey: "longitude") as? Double ?? 0.0
            mapView.addAnnotation(point)
        }
    }
        
    func getLocationName(indexPath: IndexPath) -> String {
        return myLocations[indexPath.row].value(forKeyPath: "name") as? String ?? ""
    }
    
    func getNearbyLocationName(indexPath: IndexPath) -> String {
        return nearbyLocations[indexPath.row].value(forKeyPath: "name") as? String ?? ""
    }
}
