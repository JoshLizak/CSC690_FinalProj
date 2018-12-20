//
//  SavedLocationViewController.swift
//  ShutterTool
//
//  Created by Joshua Lizak on 12/19/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SavedLocationViewController: UIViewController {
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var LatitudeTextBar: UITextField!
    @IBOutlet weak var LongitudeTextBar: UITextField!
    @IBOutlet weak var NotesTextBox: UITextView!
    @IBOutlet weak var DirectionsButton: UIButton!
    @IBOutlet weak var EditButton: UIBarButtonItem!
    @IBOutlet weak var MapView: MKMapView!
    
    var name: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var notes: String = ""
    
    override func viewDidLoad() {
        DirectionsButton.layer.cornerRadius = 10
        readData()
        addAnnotationToMap()
        NavigationBar.title = name
        LatitudeTextBar.text = String(latitude)
        LongitudeTextBar.text = String(longitude)
        NotesTextBox.text = notes
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func readData() {
        let locationObject = myLocations[selectedIndex]
        name = locationObject.value(forKeyPath: "name") as? String ?? ""
        latitude = locationObject.value(forKey: "latitude") as? Double ?? 0.0
        longitude = locationObject.value(forKey: "longitude") as? Double ?? 0.0
        notes = locationObject.value(forKey: "notes") as? String ?? ""
    }
    
    func addAnnotationToMap(){
        let point = MKPointAnnotation()
        point.coordinate.latitude = latitude
        point.coordinate.longitude = longitude
        MapView.addAnnotation(point)
        centerMapOnLocation(point: point)
    }
    
    func centerMapOnLocation(point: MKPointAnnotation){
        let location = point.coordinate
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 500, longitudinalMeters: 500)
        MapView.setRegion(region, animated: true)
    }
    
    @IBAction func DirectionsButtonSelected(_ sender: Any) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
        mapItem.name = name
        mapItem.openInMaps(launchOptions: nil)
    }
    
    
    @IBAction func EditButtonPressed(_ sender: Any) {
        if EditButton.title == "Edit" {
            // start editing
            EditButton.title = "Done"
            
            LatitudeTextBar.isUserInteractionEnabled = true
            LatitudeTextBar.backgroundColor = .white
            LatitudeTextBar.textColor = .black
            
            LongitudeTextBar.isUserInteractionEnabled = true
            LongitudeTextBar.backgroundColor = .white
            LongitudeTextBar.textColor = .black
            
            NotesTextBox.isUserInteractionEnabled = true
            NotesTextBox.backgroundColor = .white
            NotesTextBox.textColor = .black
            
        } else {
            // finished editing
            EditButton.title = "Edit"
            
            LatitudeTextBar.isUserInteractionEnabled = false
            LatitudeTextBar.backgroundColor = .black
            LatitudeTextBar.textColor = .white
            
            LongitudeTextBar.isUserInteractionEnabled = false
            LongitudeTextBar.backgroundColor = .black
            LongitudeTextBar.textColor = .white
            
            NotesTextBox.isUserInteractionEnabled = false
            NotesTextBox.backgroundColor = .black
            NotesTextBox.textColor = .white
            
            name = NavigationBar.title ?? "error"
            latitude = Double(LatitudeTextBar.text!) ?? 0.0
            longitude = Double(LongitudeTextBar.text!) ?? 0.0
            notes = NotesTextBox.text
            
            savedLocationManager.editLocation(selectedIndex: selectedIndex, name: name, notes: notes, latitude: latitude, longitude: longitude)
        }
    }
    
}
