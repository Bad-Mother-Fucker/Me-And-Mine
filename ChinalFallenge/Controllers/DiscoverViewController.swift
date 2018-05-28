//
//  DiscoverViewController.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 18/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var cameraButtonDiscoverView: UIBarButtonItem!
    
    var parentPVC: MasterViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = false
        self.cameraButtonDiscoverView.setBackgroundImage(#imageLiteral(resourceName: "cameraSymbol"), for: .normal, barMetrics: .default)
        self.cameraButtonDiscoverView.title = nil
    }
    
    @IBAction func goToReaderViewController(_ sender: Any) {
        parentPVC.setViewControllers([parentPVC.viewControllers[0]], direction: .reverse, animated: true, completion: nil)
    }
}
