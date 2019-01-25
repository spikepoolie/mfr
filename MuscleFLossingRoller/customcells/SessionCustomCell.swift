//
//  SessionCustomCell.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 1/14/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import UIKit

class SessionCustomCell: UITableViewCell {

    @IBOutlet weak var lblBodyPartName: UILabel!
    @IBOutlet weak var lblSessionDuration: UILabel!
    @IBOutlet weak var lblSessionReps: UILabel!
    @IBOutlet weak var lblPainBefore: UILabel!
    @IBOutlet weak var lblPainAfter: UILabel!
    @IBOutlet weak var lblCoolOffTime: UILabel!
    @IBOutlet weak var lblSessionDate: UILabel!
    @IBOutlet weak var btnGo: CustomButton!
    @IBOutlet weak var lblGeneric: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDateValue: UILabel!
}
