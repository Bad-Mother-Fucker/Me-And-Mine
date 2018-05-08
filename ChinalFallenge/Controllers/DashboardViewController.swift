//
//  DashboardViewController.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 18/04/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    let slideAnimator = SlideAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
    }
    
    func showTabBar() {
        if self.tabBarController?.tabBar.isHidden == true {
            tabBarController?.tabBar.isHidden = false
        }
    }
    
}
