//
//  Extensions.swift
//  ChinalFallenge
//
//  Created by Michele De Sena on 25/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

// ############### EXTENSIONS ###############

import Foundation
import UIKit
import ImageIO

extension UIImageView{
    
    func shrink() {
        UIView.animate(withDuration: 2.0, animations: {
            print ("Shrinking")
            self.frame.size = (self.superview?.frame.size)!
            self.center = (self.superview?.center)!
            self.layer.cornerRadius = 0.0
            self.layer.masksToBounds = true
        }) { (completion) in
            print ("Shrinked")
            self.frame.size = CGSize(width: self.frame.width/2 , height: self.frame.height/2)
            self.center = (self.superview?.center)!
            self.layer.cornerRadius = 4.0
            self.layer.masksToBounds = true
        }
    }
    
}

extension UIImage {
    func scale(){
    }
    
}

extension CGImagePropertyOrientation {
    
    init(_ orientation: UIImageOrientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
