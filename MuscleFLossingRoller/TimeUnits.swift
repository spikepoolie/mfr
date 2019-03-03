//
//  TimeUnits.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 2/25/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import UIKit

protocol UnitChoiceDelegate{
    func didChooseUnit(unit: String, whichTimer: String)
}

class TimeUnits: UIViewController{
    
    var unitDelegate: UnitChoiceDelegate!
    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var lblSettings: UILabel!
    @IBOutlet weak var viewInterval: UIView!
    @IBOutlet weak var viewDuration: UIView!
   
    @IBOutlet weak var intervalSwitch: UISwitch!
    @IBOutlet weak var durationSwitch: UISwitch!
    
    @IBOutlet weak var lblDurationMinutes: UILabel!
    @IBOutlet weak var lblDurationSeconds: UILabel!
    @IBOutlet weak var lblIntervalMinutes: UILabel!
    @IBOutlet weak var lblIntervalSeconds: UILabel!
    
    var labelDuration = false
    var labelInterval = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        viewInterval.layer.cornerRadius=10
        viewDuration.layer.cornerRadius=10
      
        
        if labelDuration {
            durationSwitch.isOn = true
            lblDurationMinutes.textColor = .yellow
            lblDurationSeconds.textColor = .lightGray
        } else {
            durationSwitch.isOn = false
            lblDurationMinutes.textColor = .lightGray
            lblDurationSeconds.textColor = .yellow
        }
        
        if labelInterval {
            intervalSwitch.isOn = true
            lblIntervalMinutes.textColor = .yellow
            lblIntervalSeconds.textColor = .lightGray
        } else {
            intervalSwitch.isOn = false
            lblIntervalMinutes.textColor = .lightGray
            lblIntervalSeconds.textColor = .yellow
        }
    }
    
    @IBAction func setDurationUnit(_ sender: Any) {
        if durationSwitch.isOn {
            lblDurationMinutes.textColor = .yellow
            lblDurationSeconds.textColor = .lightGray
            unitDelegate.didChooseUnit(unit: "min", whichTimer: "duration")
        } else{
            lblDurationMinutes.textColor = .lightGray
            lblDurationSeconds.textColor = .yellow
            unitDelegate.didChooseUnit(unit: "sec", whichTimer: "duration")
        }
    }
    
    @IBAction func setIntervalUnit(_ sender: Any) {
        if intervalSwitch.isOn {
            lblIntervalMinutes.textColor = .yellow
            lblIntervalSeconds.textColor = .lightGray
            unitDelegate.didChooseUnit(unit: "min", whichTimer: "interval")
        } else{
            lblIntervalMinutes.textColor = .lightGray
            lblIntervalSeconds.textColor = .yellow
            unitDelegate.didChooseUnit(unit: "sec", whichTimer: "interval")
        }
    }
    
   
    
    func sendBack() {
        self.dismiss(animated: true, completion: nil)
    }

 
    @IBAction func goBack(_ sender: Any) {
        sendBack()
    }
    
}
