//
//  Review.swift
//  PozList
//
//  Created on 12/1/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class Review: NSObject {

    var id : String = ""
    var rate : String = ""
    var review :String = ""
    var reviewDate :String = ""
    var cutomerProfile : Profile!
    var serviceProvider : ServiceProvider!
    
    override init() {
        
    }
    
    init(id:String, rate:String, review:String, reviewDate:String, customerProfile:Profile, serviceProvider:ServiceProvider) {
        
        self.id = id
        self.rate = rate
        self.review = review
        self.reviewDate = reviewDate
        self.cutomerProfile = customerProfile
        self.serviceProvider = serviceProvider
    }
}
