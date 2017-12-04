//
//  Stricks.swift
//  PozList
//
//  Created by Devubha Manek on 12/1/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
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
