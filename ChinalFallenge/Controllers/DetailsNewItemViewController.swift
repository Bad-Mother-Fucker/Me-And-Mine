//
//  DetailsNewItemViewController.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 19/04/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class DetailsNewItemViewController: UIViewController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissViewDetails))
    }
    
    
    
    func saveData(sender: UIBarButtonItem) {
    }
    
    @objc func dismissViewDetails() {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
