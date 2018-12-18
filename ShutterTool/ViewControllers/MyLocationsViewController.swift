//
//  MyLocationsViewController.swift
//  ShutterTool
//
//  Created by Joshua Lizak on 12/7/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import UIKit

class MyLocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var MyLocationsTable: UITableView!
    let locationsController = LocationsController()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationsController.loadFromCoreData()
    }

    /* Table View Functions */
    override func viewWillAppear(_ animated: Bool) {
        locationsController.loadFromCoreData()
        MyLocationsTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsController.myLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "locationCell")
        cell.textLabel?.text = locationsController.getLocationName(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            locationsController.deleteLocation(indexPath: indexPath)
            MyLocationsTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        taskSelectedDialogue(taskName: tasker.getToDoList()[indexPath.row], indexPath: indexPath )
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.MyLocationsTable.reloadData()
    }
    
    /* Dialogues */
    func selectedItemDialogue(indexPath: IndexPath){
        //Edit item
    }
}
