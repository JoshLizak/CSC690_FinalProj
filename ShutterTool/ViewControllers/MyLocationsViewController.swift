//
//  MyLocationsViewController.swift
//  ShutterTool
//
//  Created by Joshua Lizak on 12/7/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import UIKit

class MyLocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var EditButton: UIBarButtonItem!
    @IBOutlet weak var MyLocationsTable: UITableView!
    @IBOutlet weak var DataSourceButton: UIBarButtonItem!
    @IBOutlet weak var NavigationBar: UINavigationItem!
    
    let savedLocationManager = SavedLocationManager()
    
    var selectedTable: String = "My Locations"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MyLocationsTable.backgroundColor = .black
        savedLocationManager.loadFromCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savedLocationManager.loadFromCoreData()
        MyLocationsTable.reloadData()
    }

    /* Table View Functions */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if selectedTable
        
        return myLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "locationCell")
        cell.textLabel?.text = savedLocationManager.getLocationName(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            savedLocationManager.deleteLocation(indexPath: indexPath)
            MyLocationsTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        self.MyLocationsTable.reloadData()
    }
    
    @IBAction func EditButtonPressed(_ sender: Any) {
        if EditButton.title == "Edit" {
            print("Edit pressed")

            EditButton.title = "Done"
            MyLocationsTable.setEditing(true, animated: true)
        } else {
            EditButton.title = "Edit"
            MyLocationsTable.setEditing(false, animated: true)

        }
        
    }
    
    @IBAction func DataSourceButtonPressed(_ sender: Any) {
        if NavigationBar.title == "My Locations" {
            NavigationBar.title = "All Locations"

        } else {
            NavigationBar.title = "My Locations"

        }
        
    }
    
}
