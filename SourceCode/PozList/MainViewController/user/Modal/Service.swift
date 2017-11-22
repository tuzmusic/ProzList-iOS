//
//  Service.swift
//  PozList
//
//  Created by Devubha Manek on 11/6/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class Service: NSObject {

    var id: String = ""
    var servicename : String = ""
    var IsSelected : Bool = false
    var status : String = ""
    var imagePath : String = ""
    var serviceReqDate : String = ""
    
    override init() {
        
    }
    
    init(id: String, servicename: String, status: String, imagepath: String)
    {
        self.id = id
        self.servicename = servicename
        self.status = status
        self.imagePath = imagepath
    }
}

class ServiceRequest: NSObject {
    
    var id: String = ""
    var serviceCatId : String = ""
    var serviceCatName : String = ""
    var status : String = ""
    var imagePath = [String]()
    var serviceReqDesc : String = ""
    var serviceReqDate : String = ""
    var customerProfile : Profile!
    
    override init() {
        
    }
    
    init(id: String, serviceCatId: String, serviceCatName: String, status: String, imagepath: [String], serviceReqDesc : String, serviceReqDate : String, customerProfile : Profile)
    {
        self.id = id
        self.serviceCatId = serviceCatId
        self.serviceCatName = serviceCatName
        self.status = status
        self.imagePath = imagepath
        self.serviceReqDesc = serviceReqDesc
        self.serviceReqDate = serviceReqDate
        self.customerProfile = customerProfile
    }
    
}
