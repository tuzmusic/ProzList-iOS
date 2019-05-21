//
//  MTLoadingIndicator.swift
//  MTLoadingIndicator
//
//  Created on 9/25/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class MTLoadingIndicator: UIView {

//MARK: - Variable Declaration
    
    //Screen Size
    var screenHeight = 0
    var screenWidth = 0

    var popUpHeight = 100
    var popUpWidth = 100
    
    var viewTransperant:UIView!
    var viewPopUpBG:UIView!
    var viewPopUp:UIView!
    
    var spinnerView:LKAYoutubeLikeLoadingIndicatorView!
    
    
    //MARK: - Life Cycle
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        //Screen Size
        screenWidth = Int(UIScreen.main.bounds.size.width)
        screenHeight = Int(UIScreen.main.bounds.size.height)
        
        //PopUp Background
        viewPopUpBG = UIView(frame: CGRect(x: 0,y: 0,width: screenWidth,height: screenHeight))
        viewPopUpBG.backgroundColor = UIColor.clear
        self.addSubview(viewPopUpBG)
        
        //Transperant
        viewTransperant = UIView(frame: CGRect(x: 0,y: 0,width: screenWidth,height: screenHeight))
        viewTransperant.backgroundColor = UIColor.black
        viewTransperant.alpha = 0.00
        viewPopUpBG.addSubview(viewTransperant)
        
        //PopUp
        viewPopUp = UIView(frame: CGRect(x: (screenWidth/2) - (popUpWidth/2),y: (screenHeight/2) - (popUpHeight/2) , width: popUpWidth , height: popUpHeight))
        viewPopUp.layer.cornerRadius = 15
        viewPopUp.backgroundColor = .clear
        viewPopUp.clipsToBounds = true
        viewPopUpBG.addSubview(viewPopUp)
        
        //Spinner View
        spinnerView = LKAYoutubeLikeLoadingIndicatorView.init(frame: CGRect(x: popUpWidth/4,y: popUpHeight/4 , width: popUpWidth/2 , height: popUpHeight/2))
        spinnerView.lineWidth = 5.0
        spinnerView.spinnerColors = [UIColor(red: 159.0/255.0, green: 188.0/255.0, blue: 4.0/255.0, alpha: 1.0)]//[AppTheme.ButtonBackgroundColor, AppTheme.ThemeColor]
        //spinnerView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.7)
        //spinnerView.cornerRadius = spinnerView.frame.size.height/2.0
        spinnerView.hidesWhenStopped = false
        spinnerView.startAnimating()
        viewPopUp.addSubview(spinnerView)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - Show popup
    func show(isAnimated:Bool) -> MTLoadingIndicator {
        
        UIApplication.shared.keyWindow?.addSubview(self)
        //With Animation
        if (isAnimated == true) {
            
            self.alpha = 0.01
            UIView.animate(withDuration: 0.25 ,
                           animations: {
                            self.alpha = 1.0
            },
                           completion: { finish in
                            
            })
            
        } else {
            
            //Without Animation

        }
        
        return self
    }
//MARK: - Hide popup
    func hide(isAnimated:Bool) {
        
        //With Animation
        if (isAnimated == true) {
            
            UIView.animate(withDuration: 0.25 ,
                           animations: {
                            self.alpha = 0.01
            },
                           completion: { finish in
                            
                            self.removeFromSuperview()
            })
            
        } else {
        
            //Without Animation
            self.removeFromSuperview()
        }
    }
}
