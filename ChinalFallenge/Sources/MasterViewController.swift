//
//  MasterViewController.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 23/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

// ############### MASTER VIEW CONTROLLER (PAGE VIEW CONTROLLER) ###############

import UIKit

class MasterViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    override private (set) lazy var viewControllers: [UIViewController] = {
        return [newViewController("readerID"), newViewController("tabBarControllerID")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        let firstViewController = viewControllers[1]
        setViewControllers([firstViewController], direction: .reverse, animated: true, completion: nil)
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.index(of: viewController) else {return nil}
        
        guard index - 1 >= 0 else {return nil}
        
        return viewControllers[index - 1]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.index(of: viewController) else {return nil}
        
        guard index + 1 < viewControllers.count else {return nil}
        
        return viewControllers[index + 1]
    }
    
    func pageViewControllerPreferredInterfaceOrientationForPresentation(_ pageViewController: UIPageViewController) -> UIInterfaceOrientation {
        return .portrait
    }
    
    func newViewController(_ identifier: String) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        if identifier == "tabBarControllerID"{
            let tbc = viewController as! UITabBarController
            if let discoverVC = tbc.viewControllers?.first! as? DiscoverViewController{
                discoverVC.parentPVC = self
            }
        }else {
            let cameraVC = viewController as! ReaderViewController
            cameraVC.parentPVC = self
        }
        return viewController
    }

}
