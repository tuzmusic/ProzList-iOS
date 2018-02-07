//
//  DKStickyHeaderView.swift
//  DKStickyHeaderView
//
//  Created by Bannings on 15/5/4.
//  Copyright (c) 2015年 ZhangAo. All rights reserved.
//

import UIKit

private let KEY_PATH_CONTENTOFFSET = "contentOffset"

class DKStickyHeaderView: UIView {
    
    fileprivate var minHeight: CGFloat

    init(minHeight: CGFloat) {
        self.minHeight = minHeight
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: minHeight))
        self.clipsToBounds = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.superview?.removeObserver(self, forKeyPath: KEY_PATH_CONTENTOFFSET)
        if newSuperview != nil {
            assert(newSuperview!.self.isKind(of: UIScrollView.self), "superview must be UIScrollView!")
            
            var newFrame = self.frame
            newFrame.size.width = newSuperview!.bounds.size.width
            self.frame = newFrame
            self.autoresizingMask = .flexibleWidth
            newSuperview?.addObserver(self, forKeyPath: KEY_PATH_CONTENTOFFSET, options: .new, context: nil)
            
        }
    }
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == KEY_PATH_CONTENTOFFSET {
			let scrollView = self.superview as! UIScrollView
			
			var delta: CGFloat = 0.0
			if scrollView.contentOffset.y < 0.0 {
				delta = fabs(min(0.0, scrollView.contentOffset.y))
			}
			
			var newFrame = self.frame
			newFrame.origin.y = -delta
			newFrame.size.height = self.minHeight + delta
			self.frame = newFrame
            
            

		} else {
			super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
		}
	}
    
}
