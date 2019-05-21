//
//  CustomerRatingVC.swift
//  PozList
//
//  Created on 27/04/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import RSKGrowingTextView

//MARK: - Review delegate
protocol CustomerRating: class {
    func changeRatingAndReview(review:String ,rating:CGFloat)
}

//MARK: - Customer Rating ViewController
class CustomerRatingVC: UIViewController {

    //MARK: - Outlet decalaration
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var txtReviewC: RSKGrowingTextView!
    @IBOutlet var lblCustomerRating: UILabel!
    
    //MARK: - Variable diclaration
    var ratingCustomer:CGFloat!
    weak var delegate: reviewDelegate?
    var requestData:ServiceRequest!
    //var ratingNReviewData : RatingNReview!
    var customerProfile : Profile!
    
    
    //MARK: - Override Customer Rating ViewController method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        self.ratingCustomer = 0.0
        
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

    
}
//MARK: - Action method declaration
extension CustomerRatingVC {
    
    //Tapped on save
    @IBAction func tappedOnSave(_ sender: UIButton) {
        txtReviewC.resignFirstResponder()
        self.sendReviweRating()
        
        let isRating = createString(value: UserDefaults.standard.object(forKey: "isRating") as AnyObject)
        if isRating == "Yes"
        {
            UserDefaults.standard.set("No", forKey: "isRating")
            UserDefaults.standard.synchronize()
            self.navigationController?.popToRootViewController(animated: true)
        }
     
    }
    //Customer rating value change
    @IBAction func didValueChangeRating(_ sender: HCSStarRatingView) {
        print("\(sender.value)")
        view.endEditing(true)
        lblCustomerRating.text = "Rating:" + "\(sender.value)" + "/5"
        ratingCustomer = sender.value
        
    }
    //Tapped on Cancel
    @IBAction func tappedOnCancel(_ sender: Any) {
        
        //Hide text review keyboard
        txtReviewC.resignFirstResponder()
        //Hide view
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
            self.view.alpha = 0.1
        }, completion: {(_ finished: Bool) -> Void in
            self.dismiss(animated: false, completion: nil)
        })
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
extension CustomerRatingVC {
    
    func sendReviweRating() {
        
        let strReview = self.txtReviewC.text
        let strNew = strReview?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var dic = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        print(userid)
        
        dic["customer_id"] = UserDefaults.Main.string(forKey: .UserID)
        dic["service_request_id"] =  requestData.id
        dic["service_provider_id"] =  requestData.serviceProviderProfile.id
        dic["review"] = strNew
        dic["rating"] = String(describing: ratingCustomer!)
        dic["review_from"] = UserType.Customer.rawValue
        
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
                    self.navigationController?.popToRootViewController(animated: true)
                    UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                        self.view.alpha = 0.1
                    }, completion: {(_ finished: Bool) -> Void in
                        
                        self.delegate?.changeRatingAndReview(review: strNew!, rating: self.ratingCustomer)
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
