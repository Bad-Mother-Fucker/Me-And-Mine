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

struct MyItem{
    var identifier:String?
    var photos:[UIImage]?
    var owner:CKUserIdentityLookupInfo?
    var colors:[UIColor]?
    var location:String?
    var brand:String?
    var isFavourite:Bool
    var rating:Int?
    var details:[String:Any]?
}
