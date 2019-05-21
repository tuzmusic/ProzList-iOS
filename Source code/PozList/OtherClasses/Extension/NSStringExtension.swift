//
//  NSStringExtension.swift
//  HomeEscape
//
//  Created on 8/17/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

//MARK: - NSString Extension
extension NSString {
    
    //Remove white space in string
    func removeWhiteSpace() -> NSString {
        
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces) as NSString
    }
}
