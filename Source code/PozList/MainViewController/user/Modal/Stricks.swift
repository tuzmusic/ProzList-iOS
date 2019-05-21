//
//  Stricks.swift
//  PozList
//
//  Created on 12/1/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class Stricks: NSObject {
    
    var id : String = ""
    var userId : String = ""
    var comment :String = ""
    var updateDate : String = ""
    override init() {
        
    }
    
    init(id : String, userId : String, comment:String, updateDate:String) {
        self.id = id
        self.userId = userId
        self.comment = comment
        self.updateDate = updateDate
    }
}

class Award: NSObject {
    
    var id: String = ""
    var awardName : String = ""
    var awardDesc : String = ""
    var awardDate : String = ""
    var awardUpdateDate : String = ""
    var awardTag : String = ""
    override init() {
        
    }
    
    init(id: String, awardName: String, awardDesc: String, awardDate: String, awardUpdateDate : String, awardTag : String)
    {
        self.id = id
        self.awardName = awardName
        self.awardDesc = awardDesc
        self.awardDate = awardDate
        self.awardUpdateDate = awardUpdateDate
        self.awardTag = awardTag
    }
    
}
