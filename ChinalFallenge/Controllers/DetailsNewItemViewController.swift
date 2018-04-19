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

class DetailsNewItemViewController: UIViewController, UINavigationControllerDelegate, UINavigationBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        setNavigationBar()
    }
    
    func setNavigationBar() {
        
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.white
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Title"
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Delete", style:   UIBarButtonItemStyle.plain, target: self, action: Selector("dismissViewDetails"))
        let rightButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("saveData:")))
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
        
    }
    
    func saveData(sender: UIBarButtonItem) {
        
    }
    
    func dismissViewDetails (sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
