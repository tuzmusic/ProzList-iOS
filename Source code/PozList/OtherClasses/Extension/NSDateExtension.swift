//
//  NSDateExtension.swift
//  HomeEscape
//
//  Created by Devubha Manek on 8/17/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

//MARK: - NSDate Extention for UTC date
extension NSDate {
    
    //Get UTC formate to date
//    func getUTCFormateDate() -> String {
//        let dateFormatter = DateFormatter()
//        let timeZone = NSTimeZone(name: "UTC")
//        dateFormatter.timeZone = timeZone as TimeZone!
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        return dateFormatter.string(from: self as Date)
//    }
//    
//    //Get system date to date
//    func getSystemFormateDate() -> String {
//        let dateFormatter = DateFormatter()
//        let timeZone = NSTimeZone.system
//        dateFormatter.timeZone = timeZone
//        dateFormatter.dateFormat = "dd/MM/yy hh:mma"
//        return dateFormatter.string(from: self as Date)
//    }
    //Get Time stemp
    func getTimeStemp() -> String {
        
        return "\(self.timeIntervalSince1970 * 1000)"
    }
}
