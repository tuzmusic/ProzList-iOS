//
//  RatingAndReviewVC.swift
//  PozList
//
//  Created on 11/29/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import RSKGrowingTextView

protocol reviewDelegate: class {
    func changeRatingAndReview(review:String ,rating:CGFloat)
}

class RatingAndReviewVC: UIViewController ,UITextViewDelegate{

    @IBOutlet weak var lblRatingValue: UILabel!
    @IBOutlet weak var txvRating: RSKGrowingTextView!
    @IBOutlet weak var txtViewCommentHeightConstraint: NSLayoutConstraint!
    var rating:CGFloat!
    
    weak var delegate: reviewDelegate?
    
    var requestData:ServiceRequest!
    
    private var isVisibleKeyboard = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rating = 0.0
        txvRating.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        txvRating.resignFirstResponder()
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            self.view.alpha = 0.1
        }, completion: {(_ finished: Bool) -> Void in
            self.dismiss(animated: false, completion: nil)
        })
    }
    @IBAction func btnSendReview(_ sender: UIButton) {
       txvRating.resignFirstResponder()
        self.sendReviweRating()
    }
    
    // MARK: - Calls this function change rating.
    @IBAction func didValueChanged(_ sender: HCSStarRatingView) {
        print("value of star : \(sender.value)")
        view.endEditing(true)
        lblRatingValue.text = "Rating:" + "\(sender.value)" + "/5"
        rating = sender.value
        
    }
    
    // MARK: - Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        
        view.endEditing(true)
       // txvRating.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
           
        }
        return true
    }
}

// MARK: - Webservice call

extension RatingAndReviewVC {
    
    func sendReviweRating() {
        
        let strReview = self.txvRating.text
        let strNew = strReview?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var dic = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        dic["customer_id"] = requestData.customerProfile.id
        dic["service_request_id"] = requestData.id
        dic["service_provider_id"] = userid
        dic["review"] = strNew
        dic["rating"] = String(describing: rating!)
        dic["review_from"] = UserType.ServiceProvider.rawValue
        
        appDelegate.showLoadingIndicator()
        MTWebCall.call.serviceCompleted(dictParam: dic) { (respons, status) in
            appDelegate.hideLoadingIndicator()
            jprint(items: status)
            if (status == 200 && respons != nil) {
                //Response
                let dictResponse = respons as! NSDictionary
                
                let Response = getStringFromDictionary(dictionary: dictResponse, key: "response")
                if Response == "true"
                {
                    //Message
                    let message = getStringFromDictionary(dictionary: dictResponse, key: "msg")
                    print(message)
                    
                    let dictData = getDictionaryFromDictionary(dictionary: dictResponse, key: "data")
                    print(dictData)
                    //appDelegate.Popup(Message: "\(message)")
                    
                    UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                        self.view.alpha = 0.1
                    }, completion: {(_ finished: Bool) -> Void in
                        
                        self.delegate?.changeRatingAndReview(review: strNew!, rating: self.rating)
                        self.dismiss(animated: false, completion: nil)
                    })
                    
                }else
                {
                    //Popup
                    let message = getStringFromDictionary(dictionary: dictResponse, key: "msg")
                    appDelegate.Popup(Message: "\(message)")
                }
            } else {
                //Popup
                let Title = NSLocalizedString("Somthing went wrong \n Try after sometime", comment: "")
                appDelegate.Popup(Message: Title)
            }
        }
    }
}
