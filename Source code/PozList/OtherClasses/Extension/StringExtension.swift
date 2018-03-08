//
//  StringExtension.swift
//  HomeEscape
//
//  Created by Devubha Manek on 8/17/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

//MARK: - String Extension
extension String {
    //Get string length
    var length: Int { return characters.count    }  // Swift 2.0
    
    //Remove white space in string
//    func removeWhiteSpace() -> String {
////        return self.trimmingCharacters(in: .whitespaces)
//        return self.trimmingCharacters(in: .whitespacesAndNewlines)
//    }
    
    //Check string is number or not
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    //Check string is Float or not
    var isFloat : Bool {
        get{
     
            if Float(self) != nil {
                return true
            }else {
                return false
            }
        }
    }
    
    //Convert HTML to string
    init?(htmlEncodedString: String) {
        
        guard htmlEncodedString.data(using: .utf8) != nil else {
            return nil
        }
        
//        let options: [Any: Any] = [
//            NSAttributedString.DocumentAttributeKey.documentType.rawValue: NSAttributedString.DocumentType.html,
//            NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue: String.Encoding.utf8.rawValue
//        ]
//
//        guard let attributedString = try? NSAttributedString(data: data, options: options as! [NSAttributedString.DocumentReadingOptionKey : Any], documentAttributes: nil) else {
//            return nil
//        }
        
        self.init("attributedString.string")
    }
    //Format Number If Needed
    func formatNumberIfNeeded() -> String {
        
        let charset = CharacterSet(charactersIn: "0123456789.,")
        if self.rangeOfCharacter(from: charset) != nil {
            
            let currentTextWithoutCommas:NSString = (self.replacingOccurrences(of: ",", with: "")) as NSString
            
            if currentTextWithoutCommas.length < 1 {
                return ""
            }
            let numberFormatter: NumberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            
            let numberFromString: NSNumber = numberFormatter.number(from: currentTextWithoutCommas as String)!
            let formattedNumberString: NSString = numberFormatter.string(from: numberFromString)! as NSString
            
            let convertedString:String = String(formattedNumberString)
            return convertedString
            
        } else {
            
            return self
        }
    }
    //MARK: - Check Contains Capital Letter
    func isContainsCapital() -> Bool {

        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let textTest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = textTest.evaluate(with: self)
        return capitalResult
    }
    //MARK: - Check Contains Number Letter
    func isContainsNumber() -> Bool {
        
        let numberRegEx  = ".*[0-9]+.*"
        let textTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberResult = textTest.evaluate(with: self)
        return numberResult
    }
    //MARK: - Check Contains Special Character
    func isContainsSpecialCharacter() -> Bool {
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let textTest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialResult = textTest.evaluate(with: self)
        return specialResult
    }
    //MARK: - Formate phone number
    func formatPhoneNumber() -> String {
        
        // Remove any character that is not a number
        let numbersOnly = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.characters.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return ""
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.characters.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return ""
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return ""
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return ""
        }
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    //Number Suffix
    func numberSuffix(from number: Int) -> String {
        
        switch number {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
}
extension String.CharacterView {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}
////MARK: - check string nil
//func createString(value: AnyObject) -> String
//{
//    var returnString: String = ""
//    if let str: String = value as? String {
//        
//        returnString = str
//        
//    } else if let str: Int = value as? Int {
//        
//        returnString = String.init(format: "%d", str)
//        
//    } else if let _: NSNull = value as? NSNull {
//        
//        returnString = String.init(format: "")
//    }
//    return returnString
//}
//MARK: - check string nil
//func createFloatToString(value: AnyObject) -> String {
//    
//    var returnString: String = ""
//    if let str: String = value as? String {
//        
//        returnString = str
//        
//    } else if let str: Float = value as? Float {
//        
//        returnString = String.init(format: "%.2f", str)
//        
//    } else if let _: NSNull = value as? NSNull {
//        
//        returnString = String.init(format: "")
//    }
//    return returnString
//}
//func createDoubleToString(value: AnyObject) -> String {
//
//    var returnString: String = ""
//    if let str: String = value as? String {
//
//        returnString = str
//
//    } else if let str: Double = value as? Double {
//
//        returnString = String.init(format: "%f", str)
//
//    } else if let _: NSNull = value as? NSNull {
//
//        returnString = String.init(format: "")
//    }
//    return returnString
//}


//MARK: - Get perfect number float or integer
func getPerfectNumberFloatOrInt(number:Float) -> String {

    let reviews_av = number
    let isInteger = floor(reviews_av) == reviews_av
    var strReviews_av = ""
    if (isInteger) {
        
        strReviews_av = String(Int(reviews_av))
    } else {
        
        strReviews_av = String(format: "%.1f", reviews_av)
    }
    return strReviews_av
}


//MARK: - Get Array object from Any Object or Result
func getArrayFromAny(resultObj:AnyObject, key:String) -> NSArray {
    
    if let value = resultObj[key] as? NSArray {
        let string = NSString.init(format: "%@", value as CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return NSArray()
        }
        return value
    }
    return NSArray()
}





