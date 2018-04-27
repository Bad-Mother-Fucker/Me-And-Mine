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
    
    var speechPassed: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationControll()
    }
    
    func setNavigationControll() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Add new info item!"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissViewDetails))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveData))
    }
    
    @objc func dismissViewDetails() {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveData() {
        //Saving data with coreml
        dismissViewDetails()
    }
}
