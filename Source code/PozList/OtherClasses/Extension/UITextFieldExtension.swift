//
//  UITextFieldExtension.swift
//  HomeEscape
//
//  Created on 8/17/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

//MARK: - UITextfield Extension
extension UITextField {
    
    //Set placeholder font
    func setPlaceholderFont(font: UIFont) {
        
        let lblPlaceHolder:UILabel = self.value(forKey: "_placeholderLabel") as! UILabel
        lblPlaceHolder.font = font
    }
    //Set placeholder color
    func setPlaceholderColor(color: UIColor) {
        
        let lblPlaceHolder:UILabel = self.value(forKey: "_placeholderLabel") as! UILabel
        lblPlaceHolder.textColor = color
    }
    //Set clear icon
    func setClearIcon(iconName:String) {
        
        if let clearButton = self.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(named:"imgRejectRequest"), for: .normal)
            clearButton.setImage(UIImage(named:"imgRejectRequest"), for: .highlighted)
            
        }
    }
    
}
