//
//  ProfileDeatilVC.swift
//  PozList
//
//  Created by Devubha Manek on 11/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class ProfileDeatilVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dict = [String : Any]()
        let userId = UserDefaults.Main.string(forKey: .UserID)
        MTWebCall.call.getUserProfile(userId: userId, dictParam: dict) { (respons, status) in
            
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
                    let id = createString(value:dictData.value(forKey: "id") as AnyObject)
                    let username = createString(value: dictData.value(forKey: "name") as AnyObject)
                    let email = createString(value: dictData.value(forKey: "email") as AnyObject)
                    let mobile = createString(value: dictData.value(forKey: "mobile") as AnyObject)
                    let type = createString(value: dictData.value(forKey: "role") as AnyObject)
                    let status = createString(value: dictData.value(forKey: "status") as AnyObject)
                    let sAddress = createString(value: dictData.value(forKey: "address") as AnyObject)
                    let sCountry = createString(value: dictData.value(forKey: "country") as AnyObject)
                    let sState = createString(value: dictData.value(forKey: "state") as AnyObject)
                    let slicenceNo = createString(value: dictData.value(forKey: "licence_number") as AnyObject)
                    let slicenceType = createString(value: dictData.value(forKey: "licence_type") as AnyObject)
                    let ssocialNo = createString(value: dictData.value(forKey: "social_security_number") as AnyObject)
                    let sltexId = createString(value: dictData.value(forKey: "tax_id") as AnyObject)
                    let slatitude = createString(value: dictData.value(forKey: "latitude") as AnyObject)
                    let slongitude = createString(value: dictData.value(forKey: "longitude") as AnyObject)
                    
                    var arrUserService = [userService]()
                    
                    let arrService = getArrayFromDictionary(dictionary: dictData, key: "service_json")
                    if arrService.count > 0 {
                        
                        for i in 0...arrService.count - 1 {
                            
                            let catValue = arrService[i] as! NSDictionary
                            
                            let serviceId = createString(value:catValue.value(forKey: "service_id") as AnyObject)
                            let prize = createString(value: catValue.value(forKey: "price") as AnyObject)
                            let discount = createString(value: catValue.value(forKey: "discount") as AnyObject)
                            let serviceName = createString(value: catValue.value(forKey: "name") as AnyObject)
                            let status = createString(value: catValue.value(forKey: "status") as AnyObject)
                            
                            let userServic = userService.init(serviceId: serviceId, prize: prize, discount: discount, serviceName: serviceName, status: status)
                            
                            arrUserService.append(userServic)
                        }
                    }
                    
                    let userdate = ServiceProvider.init(id: id, username: username, email: email, mobile: mobile, type: type, status: status, address: sAddress, city: "", country: sCountry, state: sState, licenceNo: slicenceNo, licenceType: slicenceType, socialNo: ssocialNo, texId: sltexId, latitude: slatitude,longitude: slongitude, userServices:arrUserService)
                    
                    self.Changes_UI()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func Changes_UI() {
        
    }
}



