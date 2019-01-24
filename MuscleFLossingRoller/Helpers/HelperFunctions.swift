//
//  HelperFunctions.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 1/15/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import Foundation

func convertTimeStampToString(dt: Date) -> String{
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "E, mm/dd/yyyy h:mm a"
    let session_date = dateformatter.string(from: dt as Date)
    return session_date
}

