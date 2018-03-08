//
//  UISearchbarExtension.swift
//  HomeEscape
//
//  Created by Devubha Manek on 8/17/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class UISearchBarExtension: NSObject {

}

//MARK: - UISearchBar Class Modify
extension UISearchBar
{
    //UISearchBar Background Color
    /*func changeSearchBarColor(color : UIColor)
     {
     for subView in self.subviews
     {
     for subSubView in subView.subviews
     {
     if subSubView.conformsToProtocol(UITextInputTraits.self)
     {
     let textField = subSubView as! UITextField
     textField.backgroundColor = color
     
     break
     }
     }
     }
     }*/
    //UISearchBar Change Search Icon Size
    /*func setSearchIconFrame(frame : CGRect)
     {
     for subView in self.subviews
     {
     for subSubView in subView.subviews
     {
     if subSubView.conformsToProtocol(UITextInputTraits.self)
     {
     let textField = subSubView as! UITextField
     
     let imgSearchIcon = textField.leftView
     imgSearchIcon?.frame = frame
     break
     }
     }
     }
     }*/
    //UISearchBar Change TextField Size
    /*func setSearchTextFieldFrame(frame : CGRect)
     {
     for subView in self.subviews
     {
     for subSubView in subView.subviews
     {
     if subSubView.conformsToProtocol(UITextInputTraits.self)
     {
     let textField = subSubView as! UITextField
     textField.frame = frame
     break
     }
     }
     }
     }*/
    //UISearchBar Text Color
    func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    //UISearchBar Set Font
    func setFont(font: UIFont) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.font = font
    }
    //UISearchBar Placeholder Text Color
    func setPlaceholderColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf .setValue(color, forKeyPath: "_placeholderLabel.textColor")
    }
}
