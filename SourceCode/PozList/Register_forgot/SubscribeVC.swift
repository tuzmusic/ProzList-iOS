//
//  SubscribeVC.swift
//  PozList
//
//  Created by Devubha Manek on 16/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class SubscribeVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func click_back(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_subscribe(_ sender: UIControl) {
        
        var peraDic = [String:Any]()
        
        peraDic["transaction_id"] = "10001"
        peraDic["user_id"] = UserDefaults.Main.string(forKey: .UserID)
        peraDic["total_amount"] = "10"
        
        appDelegate.showLoadingIndicator()
        MTWebCall.call.subcriptionSave(dictParam: peraDic) { (respons, status) in
            appDelegate.hideLoadingIndicator()
            jprint(items: status)
            if (status == 200 && respons != nil) {
                //Response
                let dictResponse = respons as! NSDictionary
                
                let Response = getStringFromDictionary(dictionary: dictResponse, key: "response")
                if Response == "true"
                {
                    UserDefaults.Main.set(true, forKey: .isSubscribed)
                    let selected_service = storyBoards.Menu.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
                    self.navigationController?.pushViewController(selected_service, animated: true)
                    
                } else {
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
