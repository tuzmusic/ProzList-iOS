///Volumes/Project/Hardik Gupta/Prozlist/Source code/PozList/PozList/MainViewController/user/JobHistory/ProfileHeaderView/ProfileHeaderView.swift
//  CreateReqVC.swift
//  PozList
//
//  Created by Devubha Manek on 05/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class CreateReqVC: UIViewController {

    @IBOutlet weak var lbl_rating_profile_pic: UILabel!
    @IBOutlet weak var lbl_user_name: UILabel!
    @IBOutlet weak var lbl_user_service_type: UILabel!
    
    @IBOutlet weak var lbl_counter: UILabel!
    
    @IBOutlet weak var ProfileImgView: UIImageView!
    @IBOutlet weak var Alert_view: UIView!
    @IBOutlet weak var lbl_alert_rating: UILabel!
    @IBOutlet weak var view_alert_star: CosmosView!
    @IBOutlet weak var txt_view_alert: UITextView!
    
    @IBOutlet weak var img_completed: UIImageView!
    
    @IBOutlet weak var img_notCome: UIImageView!
    
    @IBOutlet weak var img_Panding: UIImageView!
    
    var seconds = 0
    var timer = Timer()
    var IsComplete = false
    var isUserAvil:Bool!
    @IBOutlet weak var Contro_not_come: UIControl!
    @IBOutlet weak var Control_panding: UIControl!
    @IBOutlet weak var Control_completed: UIControl!
    @IBOutlet var userDetaileView: UIView!
    
    var requestData:ServiceRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isUserAvil {
            
            let now1 = Date()
            let now =  dateFrm(date: requestData.serviceReqUpdateDate)
            let endDate = now1
            
            let calendar = Calendar.current
            let unitFlags = Set<Calendar.Component>([ .second])
            let datecomponenets = calendar.dateComponents(unitFlags, from: now, to: endDate)
            let seconds1 = datecomponenets.second
           
            seconds = seconds1!
            runTimer()
            self.Alert_view.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.Alert_view.frame.size.width , height: self.Alert_view.frame.size.height)
            
            userDetaileView.alpha = 1.0
            userDetaileView.isUserInteractionEnabled = true
            
            print(requestData.status)
            var str1 =  WebURL.ImageBaseUrl + requestData.serviceProviderProfile.profilePic
            str1 = str1.replacingOccurrences(of: " ", with: "%20")
            ProfileImgView.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
            
            if requestData.serviceProviderProfile.avgRating == "" {
                self.lbl_rating_profile_pic.text = "0"
            } else {
                self.lbl_rating_profile_pic.text = requestData.serviceProviderProfile.avgRating
            }
            
            self.lbl_user_name.text = requestData.serviceProviderProfile.username.capitalized
            self.lbl_user_service_type.text = requestData.serviceCatName
            
        } else {
            
            userDetaileView.alpha = 0.5
            userDetaileView.isUserInteractionEnabled = false
            userDetaileView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark:- Click events
    
    @IBAction func Click_bak(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func Click_profile_pic(_ sender: UIControl) {
        
    }
    @IBAction func Click_payment(_ sender: Any) {
        
        if img_Panding.image == #imageLiteral(resourceName: "Group_name") {
            self.requestComplete(status: "panding")
        } else if img_completed.image == #imageLiteral(resourceName: "Group_name") {
            self.requestComplete(status: "Completed")
        } else if img_notCome.image == #imageLiteral(resourceName: "Group_name") {
            self.requestComplete(status: "Not come")
        }
        
        /*
        if  img_completed.image != #imageLiteral(resourceName: "Group_name") {
            let alert = UIAlertController(title: "Congratulations".localized, message: "Your registration is successful!!!".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (cancel) in
            }))
            present(alert, animated: true, completion: nil)
        }
        else{
            UIView.animate(withDuration: 0.5, animations: {
                self.Alert_view.frame = CGRect(x: 0, y: 0, width: self.Alert_view.frame.size.width , height: self.Alert_view.frame.size.height)
            }) { (Closer) in
            }
        } */
    }
    @IBAction func Click_Track_service(_ sender: UIControl) {
     
        let vc = storyBoards.Customer.instantiateViewController(withIdentifier: "TrackServiceVC") as! TrackServiceVC
        vc.providerRequestData = requestData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func Click_Pending_state(_ sender: UIControl) {
        
        img_Panding.image = #imageLiteral(resourceName: "Group_name")
        Control_panding.backgroundColor = UIColor.appPanding()
        
        Control_completed.backgroundColor = UIColor.lightGray
        img_completed.image =  #imageLiteral(resourceName: "round")
        
        Contro_not_come.backgroundColor = UIColor.lightGray
        img_notCome.image = #imageLiteral(resourceName: "Rounded_red")
        
    }
    
    @IBAction func Click_completed_state(_ sender: UIControl) {
        
        img_completed.image = #imageLiteral(resourceName: "Group_name")
        Control_completed.backgroundColor = UIColor.appBackGroundColor()
        
        Contro_not_come.backgroundColor = UIColor.lightGray
        img_notCome.image = #imageLiteral(resourceName: "Rounded_red")
        
        Control_panding.backgroundColor = UIColor.lightGray
        img_Panding.image = #imageLiteral(resourceName: "Rounded_yellow")
        
    }
    
    
    @IBAction func Click_Not_come_state(_ sender: UIControl) {
        
        img_notCome.image = #imageLiteral(resourceName: "Group_name")
        Contro_not_come.backgroundColor = UIColor.appNotcome()
        
        Control_completed.backgroundColor = UIColor.lightGray
        img_completed.image =  #imageLiteral(resourceName: "round")
        
        Control_panding.backgroundColor = UIColor.lightGray
        img_Panding.image = #imageLiteral(resourceName: "Rounded_yellow")
    }
    
    //MARK: - Alert Click
    @IBAction func Clicl_alert_save(_ sender: Any) {
    }
    
    @IBAction func click_close_alert(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.Alert_view.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.Alert_view.frame.size.width , height: self.Alert_view.frame.size.height)
        }) { (Closer) in
        }
    }
    
    func dateFrm(date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      //  dateFormatter.dateFormat = "dd-mm-yyyy" //Your date format
      //  dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let date = dateFormatter.date(from: date) //according to date format your date string
        print(date ?? "") //Convert String to Date
        return date!
    }
    
    func secondsIn(_ str: String)->Int{
        var strArr = str.characters.split{$0 == ":"}.map(String.init)
        let sec = Int(strArr[0])! * 3600
        let sec1 = Int(strArr[1])! * 36
        print("sec")
        print(sec+sec1)
        return sec+sec1
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(CreateReqVC.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1

        self.lbl_counter.text = timeString(time: TimeInterval(seconds))
        //print(timeString(time: TimeInterval(seconds)))
    }
    func stop(){
        seconds = 0
        timer.invalidate()
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
}

extension CreateReqVC {
    
    func requestComplete(status:String) {
        
        var dic = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        dic["user_id"] = userid
        dic["status"] = status
        dic["request_id"] = requestData.id
        
        appDelegate.showLoadingIndicator()
        MTWebCall.call.requestAcceptAndDecline(dictParam: dic) { (respons, status) in
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
