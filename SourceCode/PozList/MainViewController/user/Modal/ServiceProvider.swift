//
//  ServiceProvider.swift
//  PozList
//
//  Created by Devubha Manek on 11/15/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class ServiceProvider: NSObject {

    var id: String = ""
    var username : String = ""
    var email : String = ""
    var mobile : String = ""
    var type : String = ""
    var status : String = ""
    var address : String = ""
    var city : String = ""
    var country : String = ""
    var state : String = ""
    var licenceNo : String = ""
    var licenceType : String = ""
    var socialNo : String = ""
    var texId : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var workingArea : String = ""
    var userServices = [userService]()
    override init() {
        
    }
    
    init(id: String, username: String,email: String, mobile: String, type: String, status: String ,address : String ,city:String, country : String ,state : String, licenceNo : String ,licenceType : String ,socialNo : String ,texId : String, latitude : String, longitude : String, workingArea: String, userServices:[userService])
    {
            self.id = id
            self.username = username
            self.email = email
            self.mobile = mobile
            self.type = type
            self.status = status
            self.address = address
            self.city = city
            self.country = country
            self.state = state
            self.licenceNo = licenceNo
            self.licenceType = licenceType
            self.socialNo = socialNo
            self.texId = texId
            self.userServices = userServices
            self.latitude = latitude
            self.longitude = longitude
            self.workingArea = workingArea
    }
}

class userService: NSObject {
    
    var serviceId: String = ""
    var prize : String = ""
    var discount : String = ""
    var serviceName : String = ""
    var status : String = ""
    
    override init() {
        
    }
    
    init(serviceId: String, prize: String,discount: String,serviceName: String,status: String)
    {
        self.serviceId = serviceId
        self.prize = prize
        self.discount = discount
        self.serviceName = serviceName
        self.status = status
    }
}
