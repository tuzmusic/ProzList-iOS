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
