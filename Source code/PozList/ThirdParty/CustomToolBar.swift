//
//  CustomToolBar.swift
//  Bozzi
//
//  Created by Dilip manek on 18/07/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

@objc protocol CustomToolBarDelegate {
    @objc optional func getSegmentIndex(segmentIndex : Int,selectedTextField :UITextField)
    func closeKeyBoard()
}

class CustomToolBar: UIToolbar {
    
    var delegate1: CustomToolBarDelegate?
    var txtField = UITextField()
    
     public init(frame: CGRect ,isSegment : Bool) {     // for using CustomView in code

        super.init(frame: frame)
        
        self.frame = frame
        self.barStyle = UIBarStyle.default
        self.isTranslucent = true
        self.barTintColor = Color.keyboardHeaderColor
        self.tintColor = UIColor.white
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(resignKeyboard))
        let previousButton:UIBarButtonItem! = UIBarButtonItem()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
       
        if isSegment {
            previousButton.customView = self.prevNextSegment()
        }

        self.setItems([previousButton, spaceButton, doneButton], animated: false)
        self.isUserInteractionEnabled = true
        self.sizeToFit()
    }
    required init(coder aCoder: NSCoder) {
        super.init(coder: aCoder)!
    }
    
    func prevNextSegment() -> UISegmentedControl
    {
        let prevNextSegment = UISegmentedControl()
        prevNextSegment.isMomentary = true
        prevNextSegment.tintColor = UIColor.white
        let barbuttonFont = UIFont(name: FontName.RobotoRegular, size: 13) ?? UIFont.systemFont(ofSize: 15)
        prevNextSegment.setTitleTextAttributes([NSAttributedStringKey.font: barbuttonFont, NSAttributedStringKey.foregroundColor:UIColor.clear], for: UIControlState.disabled)
        if(DeviceType.IS_IPHONE_6PLUS)
        {
            prevNextSegment.frame = CGRect(x: 0, y: 0, width: 150, height: 28) //CGRectMake(0,0,130, 28)
        }
        else
        {
            prevNextSegment.frame = CGRect(x: 0, y: 0, width: 150, height: 40) //CGRectMake(0,0,130, 40)
        }
        prevNextSegment.insertSegment(withTitle: "Previous", at: 0, animated: false)
        prevNextSegment.insertSegment(withTitle: "Next", at: 1, animated: false)
        
        prevNextSegment.addTarget(self, action: #selector(prevOrNext), for: UIControlEvents.valueChanged)
        return prevNextSegment;
    }
    
    @objc func prevOrNext(segm: UISegmentedControl)
    {
        if (segm.selectedSegmentIndex == 1)
        {
            delegate1?.getSegmentIndex!(segmentIndex: 1, selectedTextField: txtField)
        }else
        {
           delegate1?.getSegmentIndex!(segmentIndex:0, selectedTextField: txtField)
        }
    }
    @objc func resignKeyboard()
    {
      delegate1?.closeKeyBoard()
    }
}
