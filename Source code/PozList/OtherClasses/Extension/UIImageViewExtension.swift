//
//  UIImageViewExtension.swift
//  HomeEscape
//
//  Created on 8/18/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

extension UIImageView {
    
    //Create parallax effect
    func addParallax(verticalAmount:Float = 0.0 , horozontalAmount:Float = 0.0) {
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -horozontalAmount
        horizontal.maximumRelativeValue = horozontalAmount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -verticalAmount
        vertical.maximumRelativeValue = verticalAmount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        self.addMotionEffect(group)
    }
}
