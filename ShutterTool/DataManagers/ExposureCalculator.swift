//
//  ExposureCalculator.swift
//  ShutterTool
//
//  Created by Joshua Lizak on 12/14/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import Foundation

class ExposureCalculator {
    
    //Certain Calculations adapted from http://endoflow.com/exposure/ and
    //https://nofilmschool.com/2018/03/want-easier-and-faster-way-calculate-exposure-formula
    
    /* Lists of Apertures, ShutterSpeeds, and ISOs */
    let apertures: [Double] = [0.0, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.4, 1.6, 1.8, 2, 2.2, 2.5, 2.8, 3.2, 3.5, 4, 4.5, 5.0, 5.6, 6.3, 7.1, 8, 9, 10, 11, 13, 14, 16, 18, 20, 22, 27, 32, 38, 45, 54, 64, 76, 91, 108]
    
    let shutterSpeeds: [Double] = [0.0, 1/8000, 1/6400, 1/5000, 1/4000, 1/3200, 1/2500, 1/2000, 1/1600, 1/1250, 1/1000, 1/800, 1/640, 1/500, 1/400, 1/320, 1/250, 1/200, 1/160, 1/125, 1/100, 1/80, 1/60, 1/50, 1/40, 1/30, 1/25, 1/20, 1/15, 1/13, 1/10, 1/8, 1/6, 1/5, 1/4, 0.3, 0.4, 0.5, 0.6, 0.8, 1, 1.3, 1.6, 2, 2.5, 3.2, 4, 5]
    
    let isos: [Int] = [0, 50, 100, 125, 160, 200, 250, 320, 400, 500, 640, 800, 1000, 1250, 1600, 2000, 2500, 3200, 4000, 5000, 6400, 12800, 25600];
    
    /* Variables */
    var currentShutter: Double = 0.0
    var currentAperture: Double = 0.0
    var currentISO: Int = 0
    
    var newShutter: Double = 0.0
    var newAperture: Double = 0.0
    var newISO: Int = 0
    
    var exposureValue: Double = 0.0
    
    /* Calculation of Current EV */
    func calculateCurrentEV() {
        let EV = log2 (currentAperture * currentAperture / currentShutter)
        exposureValue = EV - log2 ( Double (currentISO / 100) );
    }
    
    /* Calculation of Adjusted(New) Exposure */
    func calculateNewExposure(){
        calculateCurrentEV()
        if newShutter == 0.0 {
            calculateShutterAdjusted()
        } else if newAperture == 0.0 {
            calculateApertureAdjusted()
        } else if newISO == 0 {
            calculateISOAdjusted()
        }
    }
    
    func calculateApertureAdjusted() {
        newAperture = sqrt (newShutter * pow(2, exposureValue + log2 (Double(newISO / 100) ) ) )
        newAperture = apertures.enumerated().min( by: { abs($0.1 - newAperture) < abs($1.1 - newAperture) } )!.element
    }
    
    func calculateShutterAdjusted() {
        newShutter = (newAperture * newAperture) / pow(2, exposureValue + log2(Double(newISO / 100) ) )
        newShutter = shutterSpeeds.enumerated().min( by: { abs($0.1 - newShutter) < abs($1.1 - newShutter) } )!.element
    }
    
    func calculateISOAdjusted() {
        newISO = Int(100 * pow(2, log2(newAperture * newAperture / newShutter) - exposureValue))
        newISO = isos.enumerated().min( by: { abs($0.1 - newISO) < abs($1.1 - newISO) } )!.element
    }
    
    /* Getters and Setters */
    func getNewShutter() -> Double {
        return newShutter
    }
    
    func getNewAperture() -> Double {
        return newAperture
    }
    
    func getNewISO() -> Int {
        return newISO
    }
    
    func getISOs() -> [Int] {
        return isos
    }
    
    func getShutterSpeeds() -> [Double]{
        return shutterSpeeds
    }
    
    func getApertures() -> [Double] {
        return apertures
    }
    
    func setCurrentExposure(shutter: Double, aperture: Double, iso: Int) {
        currentShutter = shutter
        currentAperture = aperture
        currentISO = iso
    }
    
    func setNewExposure(shutter: Double, aperture: Double, iso: Int) {
        newShutter = shutter
        newAperture = aperture
        newISO = iso
    }
}
