//
//  SessionObject.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 1/14/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import Foundation
import UIKit

class SessionObject {
    var image: UIImage
    var title: String
    var subTitle: String
    var details: String
    
    init(image: UIImage, title: String, subTitle: String, details: String) {
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.details = details
    }
}
