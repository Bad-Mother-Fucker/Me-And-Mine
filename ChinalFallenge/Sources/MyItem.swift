//
//  MyItem.swift
//  ChinalFallenge
//
//  Created by Michele De Sena on 31/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//


import Foundation
import UIKit
import CloudKit

class MyItem {
    var identifier: String?
    var photos: [UIImage]?
    var owner: CKUserIdentityLookupInfo?
    var colors: [UIColor]?
    var location: String?
    var brand: String?
    var isFavourite: Bool?
    var rating: Int?
    var details: [String:Any]?
    
    var attributes: [String] {
        get{
            let identifier = self.identifier ?? "identifier"
            let brand = self.brand ?? "brand"
            let location = self.location ?? "location"
            return["\(identifier)","\(brand)","\(self.color)","\(location)"]
        }
    }
    
    var color: String {
        get{
            guard let _ = colors else{return "color"}
            return self.colors.map {colore in return "\(colore)"}!
        }
    }
       
    
}

