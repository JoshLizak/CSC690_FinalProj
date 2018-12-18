//
//  FractionConverter.swift
//  ShutterTool
//
//  Created by Joshua Lizak on 12/16/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import Foundation

class FractionConverter {
    
    // Adapted from user Martin R on StackOverflow
    // https://stackoverflow.com/questions/35895154/decimal-to-fraction-conversion-in-swift/35895607
    
    var fractionString: String = ""
    
    func getFraction(of x0 : Double, withPrecision eps : Double = 1.0E-6) {
        if x0 == 0.0 {
            fractionString = "0"
        } else if x0 <= 0.25 {
            var x = x0
            var a = x.rounded(.down)
            var (h1, k1, h, k) = (1, 0, Int(a), 1)
            
            while x - a > eps * Double(k) * Double(k) {
                x = 1.0/(x - a)
                a = x.rounded(.down)
                (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
            }
            fractionString = "\(h) / \(k)"
        }  else {
            fractionString = String(x0)
        }
    }
}
