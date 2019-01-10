//
//  Sessions.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 1/10/19.
//  Copyright © 2019 MFR. All rights reserved.
//

import UIKit

class Sessions: NSObject {
    var bodypartid: Int?
    var bodypartname: String?
    var cooloff: Int?
    var isfavorite: Int?
    var miutes: Int?
    var notes: String?
    var painafter: Int?
    var painbefore: Int?
    var reps: Int?
    var username: String?
    
    init(bodypartid:Int?,bodypartname:String?,cooloff:Int?,isfavorite:Int?,miutes:Int?,notes:String?,painafter:Int?,painbefore:Int?,reps:Int?,username: String?){
        self.bodypartid = bodypartid;
        self.bodypartname = bodypartname;
        self.cooloff = cooloff;
        self.isfavorite = isfavorite;
        self.miutes = miutes;
        self.notes = notes;
        self.painafter = painafter;
        self.painbefore = painbefore;
        self.reps = reps;
        self.username = username;
    }
}
