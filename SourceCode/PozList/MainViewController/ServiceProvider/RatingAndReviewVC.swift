//
//  RatingAndReviewVC.swift
//  PozList
//
//  Created by Devubha Manek on 11/29/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class RatingAndReviewVC: UIViewController {

    @IBOutlet weak var txvRating: UITextView!
    @IBOutlet weak var txtViewCommentHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.alpha = 0.01
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            self.view.alpha = 1.0
        }, completion: {(_ finished: Bool) -> Void in
        })
    }
    
    // MARK: - Navigation
    @IBAction func btnClosePress(_ sender: Any) {
        
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            self.view.alpha = 0.1
        }, completion: {(_ finished: Bool) -> Void in
            
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    // MARK: - UITextView Delegate Event
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        let mh = min(newSize.height,90)
        let h = max(32,mh)
        txtViewCommentHeightConstraint.constant = h
        self.view.layoutIfNeeded()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.init(red: 141/255.0, green: 140/255.0, blue: 141/255.0, alpha: 1.0) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = NSLocalizedString("Review...", comment: "")
            textView.textColor = UIColor.init(red: 141/255.0, green: 140/255.0, blue: 141/255.0, alpha: 1.0)
        }
    }
}
