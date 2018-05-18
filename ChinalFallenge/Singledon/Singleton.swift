//
//  Singleton.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 18/05/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import AVFoundation
import UIKit

final class DataModel {
    static let sharedInstance = DataModel()
    private init() {}
    
    var image: [UIImage]?
    var coreMLString: String?
    var OCRString: String?

}
