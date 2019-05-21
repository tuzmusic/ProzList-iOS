//
//  DictionaryExtension.swift
//  HomeEscape
//
//  Created on 8/17/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

// Dictionary Contains Value
//extension Dictionary where Value: Equatable {
//    
//    func containsValue(value : Value) -> Bool {
//        
//        return self.contains { $0.1 == value }
//    }
//}

//Create dictionary from any object
func creatDic(value: AnyObject) -> NSDictionary {
    
    var tempDic = NSMutableDictionary()
    
    if let arrData: NSDictionary = value as? NSDictionary {
        
        tempDic = NSMutableDictionary.init(dictionary: arrData as! [AnyHashable: Any])
        
    } else if let _: NSNull = value as? NSNull {
        
        tempDic = NSMutableDictionary.init()
    }
    
    return tempDic
}
