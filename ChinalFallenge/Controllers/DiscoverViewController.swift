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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = false
        self.cameraButtonDiscoverView.setBackgroundImage(#imageLiteral(resourceName: "cameraSymbol"), for: .normal, barMetrics: .default)
    }
    
    @IBAction func goToReaderViewController(_ sender: Any) {
        self.performSegue(withIdentifier: "ReaderViewController", sender: self)
    }
    
    @IBAction func unwindToDiscoverView(segue: UIStoryboardSegue) {
    }
    
   
    
}
