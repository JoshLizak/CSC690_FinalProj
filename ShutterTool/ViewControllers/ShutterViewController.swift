//
//  SecondViewController.swift
//  ShutterTool
//
//  Created by Joshua Lizak on 12/7/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import UIKit

class ShutterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var currentShutter: UITextField!
    @IBOutlet weak var currentAperture: UITextField!
    @IBOutlet weak var currentISO: UITextField!
    @IBOutlet weak var newShutter: UITextField!
    @IBOutlet weak var newAperture: UITextField!
    @IBOutlet weak var newISO: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    
    @IBAction func calculateButton(_ sender: Any) {
        //Check Form Validation
        if (ev.currentShutter == 0.0) || (ev.currentAperture == 0.0) || (ev.currentISO == 0){
            errorDialogue(title: "Current Exposure Error", message: "Fill in all inputs for the current exposure.")
        } else {
            var newEVCount = 0
            if ev.newShutter != 0.0 { newEVCount += 1 }
            if ev.newAperture != 0.0 { newEVCount += 1 }
            if ev.newISO != 0 { newEVCount += 1 }
            
            if newEVCount == 2 {
                ev.calculateNewExposure()
                let fraction = FractionConverter()
                fraction.getFraction(of: ev.newShutter)
                newShutter.text = fraction.fractionString
                newAperture.text = String(ev.newAperture)
                newISO.text = String(ev.newISO)
            } else{
                errorDialogue(title: "New Exposure Error", message: "Fill in two inputs for the new exposure.")
            }
        }
        print("Current: \(ev.currentShutter) \(ev.currentAperture) \(ev.currentISO)")
        print("New: \(ev.newShutter) \(ev.newAperture) \(ev.newISO)")
        print("EV: \(ev.exposureValue)")
    }
    
    // Set status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateButton.layer.cornerRadius = 10
    }
    
    // Variables
    let ev = ExposureCalculator()
    var picker = UIPickerView()
    var currentTextField = UITextField()
    
    // Determine current text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.picker.delegate = self
        self.picker.dataSource = self
        currentTextField = textField
        
        // Add done button to picker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ShutterViewController.dismissPicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        currentTextField.inputAccessoryView = toolBar
        currentTextField.inputView = picker
    }
    
    /* Functions for PickerView */
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // number of columns
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // number of rows
        switch currentTextField {
        case currentShutter:
            return ev.shutterSpeeds.count
        case newShutter:
            return ev.shutterSpeeds.count
        case currentISO:
            return ev.isos.count
        case newISO:
            return ev.isos.count
        case currentAperture:
            return ev.apertures.count
        case newAperture:
            return ev.apertures.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // value set when item is selected
        let fraction = FractionConverter()
        switch currentTextField {
        case currentShutter:
            fraction.getFraction(of: ev.shutterSpeeds[row])
            currentShutter.text = fraction.fractionString
            ev.currentShutter = ev.shutterSpeeds[row]
        case newShutter:
            fraction.getFraction(of: ev.shutterSpeeds[row])
            newShutter.text = fraction.fractionString
            ev.newShutter = ev.shutterSpeeds[row]
        case currentISO:
            currentISO.text =  String(ev.isos[row])
            ev.currentISO = ev.isos[row]
        case newISO:
            newISO.text = String(ev.isos[row])
            ev.newISO = ev.isos[row]
        case currentAperture:
            currentAperture.text = String(ev.apertures[row])
            ev.currentAperture = ev.apertures[row]
        case newAperture:
            newAperture.text = String(ev.apertures[row])
            ev.newAperture = ev.apertures[row]
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // text to display in picker rows
        let fraction = FractionConverter()
        switch currentTextField {
        case currentShutter:
            fraction.getFraction(of: ev.shutterSpeeds[row])
            return fraction.fractionString
        case currentISO:
            return String(ev.isos[row])
        case currentAperture:
            return String(ev.apertures[row])
        case newShutter:
            fraction.getFraction(of: ev.shutterSpeeds[row])
            return fraction.fractionString
        case newISO:
            return String(ev.isos[row])
        case newAperture:
            return String(ev.apertures[row])
        default:
            return ""
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

