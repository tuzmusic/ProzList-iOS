//
//  Service.swift
//  PozList
//
//  Created on 11/6/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class Service: NSObject {

    var id: String = ""
    var servicename : String = ""
    var isSelected : Bool = false
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
    var transactionId : String = ""
    var serviceCatName : String = ""
    var status : String = ""
    var userServiceStatus:String = ""
    var imagePath = [String]()
    var serviceReqDesc : String = ""
    var serviceReqDate : String = ""
    var serviceReqUpdateDate : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var distance : String = ""
    var address : String = ""
    var customerProfile : Profile!
    var serviceProviderProfile : ServiceProvider!
    var ratingNReviewObj:RatingNReview!
    
    override init() {
        
    }
    
    init(id: String, serviceCatId: String, transactionId:String, serviceCatName: String, status: String, userServiceStatus: String, imagepath: [String], serviceReqDesc : String, serviceReqDate : String, serviceReqUpdateDate: String, latitude : String, longitude : String,distance : String,address : String, customerProfile : Profile, serviceProvider : ServiceProvider, ratingNReviewObj:RatingNReview)
    {
        self.id = id
        self.serviceCatId = serviceCatId
        self.transactionId = transactionId
        self.serviceCatName = serviceCatName
        self.status = status
        self.imagePath = imagepath
        self.serviceReqDesc = serviceReqDesc
        self.serviceReqDate = serviceReqDate
        self.serviceReqUpdateDate = serviceReqUpdateDate
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        self.address = address
        self.customerProfile = customerProfile
        self.serviceProviderProfile = serviceProvider
        self.ratingNReviewObj = ratingNReviewObj
        self.userServiceStatus = userServiceStatus
    }
}

class RatingNReview:NSObject{
    
    var id : String
    var serviceRequestId : String
    var customerId : String
    var serviceProviderId : String
    var rating : String
    var review : String
    var reviewFrom : String
    var createdAt : String
    var updated_at : String
    
    init(id : String, serviceRequestId : String, customerId : String, serviceProviderId : String, rating : String, review : String, reviewFrom : String, createdAt : String, updated_at : String) {
        self.id = id
        self.serviceRequestId = serviceRequestId
        self.customerId = customerId
        self.serviceProviderId = serviceProviderId
        self.rating = rating
        self.review = review
        self.reviewFrom = reviewFrom
        self.createdAt = createdAt
        self.updated_at = updated_at
    }
}




