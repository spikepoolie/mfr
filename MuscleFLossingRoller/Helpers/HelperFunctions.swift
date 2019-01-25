//
//  HelperFunctions.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 1/15/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import Foundation

func convertTimeStampToString(dt: Date, formatdate: String) -> String{
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = formatdate
    let session_date = dateformatter.string(from: dt as Date)
    return session_date
}

