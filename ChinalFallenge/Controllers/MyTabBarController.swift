//
//  MyTabBarController.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 20/04/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    // Create an attribute in attributes inspector.
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change default view controller when the app starts.
        selectedIndex = defaultIndex // selectedIndex is a UITabBarController attribute. This assignment is necessary to change the first view when the app starts.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
