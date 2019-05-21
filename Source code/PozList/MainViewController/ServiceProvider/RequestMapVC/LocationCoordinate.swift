
//
//  LocationCoordinate.swift
//  PozList
//
//  Created on 3/6/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

class LocationCoordinate: NSObject {
    
     @objc dynamic var strLatitude: String
    @objc dynamic var strLongitude: String
    
    init(strLatitude: String, strLongitude: String) {
        self.strLatitude = strLatitude
        self.strLongitude = strLongitude
        super.init()
    }
}
