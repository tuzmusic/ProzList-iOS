
//
//  LocationCoordinate.swift
//  PozList
//
//  Created by Devubha Manek on 3/6/18.
//  Copyright © 2018 Devubha Manek. All rights reserved.
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
