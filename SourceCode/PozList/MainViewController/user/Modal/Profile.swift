//
//  Profile.swift
//  PozList
//
//  Created by Devubha Manek on 11/3/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class Profile: NSObject {

    var id: String = ""
    var username : String = ""
    var email : String = ""
    var mobile : String = ""
    var type : String = ""
    var status : String = ""
    var city : String = ""
    
    override init() {
        
    }
    
    init(id: String, username: String,email: String, mobile: String, type: String, status: String ,city:String)
    {
        self.id = id
        self.username = username
        self.email = email
        self.mobile = mobile
        self.type = type
        self.status = status
        self.city = city
    }
}
