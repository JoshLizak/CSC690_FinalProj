//
//  TabBarController.swift
//  ShutterTool
//
//  Created by Joshua Lizak on 12/13/18.
//  Copyright © 2018 Joshua Lizak. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 1
    
    /* Sets the Default tab to 'Home' */
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
    
}
