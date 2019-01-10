//
//  Users.swift
//  MuscleFLossingRoller
//
//  Created by Rodrigo Schreiner on 1/10/19.
//  Copyright © 2019 MFR. All rights reserved.
//

class Users {
    var cellphone: String?
    var name: String?
    var password: String?
    var profileimageUrl: String?
    var userkey: String?
    var username: String?
    
    init(cellphone:String?,name:String?,password:String?,profileimageUrl:String?,userkey:String?,username:String?){
        self.cellphone = cellphone;
        self.name = name;
        self.password = password;
        self.profileimageUrl = profileimageUrl;
        self.userkey = userkey;
        self.username = username;
    }
}
