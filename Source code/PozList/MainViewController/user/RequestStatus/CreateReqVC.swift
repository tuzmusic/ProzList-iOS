///Volumes/Project/Hardik Gupta/Prozlist/Source code/PozList/PozList/MainViewController/user/JobHistory/ProfileHeaderView/ProfileHeaderView.swift
//  CreateReqVC.swift
//  PozList
//
//  Created on 05/10/17.
//  Copyright © 2017. All rights reserved.
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
    
    @IBOutlet weak var lblReqAddress: UILabel!
    @IBOutlet weak var lblReqDetail: UILabel!
    @IBOutlet weak var img_completed: UIImageView!
    
    @IBOutlet weak var img_notCome: UIImageView!
    
    @IBOutlet weak var img_Panding: UIImageView!
    
    var seconds = 0
    var timer = Timer()
    var IsComplete = false
    var isUserAvail:Bool!
    @IBOutlet weak var Control_not_come: UIControl!
    @IBOutlet weak var Control_panding: UIControl!
    @IBOutlet weak var Control_completed: UIControl!
    @IBOutlet var userDetailView: UIView!
    
    @IBOutlet weak var lblPending: UILabel!
    @IBOutlet weak var lblCompleted: UILabel!
    @IBOutlet weak var lblNotCome: UILabel!
    
    
    var requestData:ServiceRequest!
    
    //MARK: - View initialization
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if isUserAvail {
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
            
            userDetailView.alpha = 1.0
            userDetailView.isUserInteractionEnabled = true
            
            print(requestData.status)
            var str1 =  WebURL.ImageBaseUrl + requestData.serviceProviderProfile.profilePic
            str1 = str1.replacingOccurrences(of: " ", with: "%20")
            ProfileImgView.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "imgUserPlaceholder"), options: .refreshCached)
            
            if requestData.serviceProviderProfile.avgRating == "" {
                self.lbl_rating_profile_pic.text = "0.0"
            } else {
                //self.lbl_rating_profile_pic.text = "\(String(format: "%.1f", requestData.serviceProviderProfile.avgRating))"
                let dblRate = Double (requestData.serviceProviderProfile.avgRating )
               // String(format: "%.2f", myDouble)
                self.lbl_rating_profile_pic.text = "\(String(format: "%.1f", dblRate!))"
               // self.lbl_rating_profile_pic.text = "\(String(describing: dblRate))"
            }
            self.lbl_user_name.text = requestData.serviceProviderProfile.username.capitalized
            self.lbl_user_service_type.text = requestData.serviceCatName
            
            let status = requestData.status
            if status.length > 0 {
                lblPending.text = status
            }
        } else {
            userDetailView.alpha = 0.5
            userDetailView.isUserInteractionEnabled = false
            userDetailView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            self.lbl_user_name.text = "-"
            self.lbl_user_service_type.text = "-"
        }
        
        self.lblReqAddress.text = requestData.address
        self.lblReqDetail.text = requestData.serviceReqDesc
    }
    
    //Show Modal
    func showModal() {
        let customerRatingVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerRatingVC") as! CustomerRatingVC
        customerRatingVC.modalPresentationStyle = .overCurrentContext
        customerRatingVC.requestData = requestData
        self.present(customerRatingVC, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ProfileImgView.layer.cornerRadius = ProfileImgView.frame.size.height / 2.0
    }
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set("Yes", forKey: "isRating")
        UserDefaults.standard.synchronize()
    }

    //MARK:- Click events
    
    @IBAction func Click_bak(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func Click_profile_pic(_ sender: UIControl) {
        let vc = storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "ServiceProviderProfileVC") as! ServiceProviderProfileVC
        vc.isOnlyShowProfile = true
        vc.serviceProviderId = requestData.serviceProviderProfile.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func Click_payment(_ sender: Any) {
        
        if img_Panding.image == #imageLiteral(resourceName: "Group_name") {
            if lblPending.text?.lowercased() == "pending"{
               alert(message: "You can not update Pending status.")
            }else {
                 self.requestComplete(statusA: "Accepted")
            }
        } else if img_completed.image == #imageLiteral(resourceName: "Group_name") {
            self.requestComplete(statusA: "Completed")
            
        } else if img_notCome.image == #imageLiteral(resourceName: "Group_name") {
            self.requestComplete(statusA: "NotCome")
        }

}
    @IBAction func Click_Track_service(_ sender: UIControl) {
     
        let vc = storyBoards.Customer.instantiateViewController(withIdentifier: "TrackServiceVC") as! TrackServiceVC
        vc.providerRequestData = requestData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Click_Pending_state(_ sender: UIControl) {
        img_Panding.image = #imageLiteral(resourceName: "Group_name")
        Control_panding.backgroundColor = UIColor.appPending()
        
        Control_completed.backgroundColor = UIColor.lightGray
        img_completed.image =  #imageLiteral(resourceName: "round")
        
        Control_not_come.backgroundColor = UIColor.lightGray
        img_notCome.image = #imageLiteral(resourceName: "Rounded_red")
    }
    
    @IBAction func Click_completed_state(_ sender: UIControl) {
        
        if lblPending.text?.lowercased() != "accepted" && lblPending.text?.lowercased() != "pending"{
            img_completed.image = #imageLiteral(resourceName: "Group_name")
            Control_completed.backgroundColor = UIColor.appBackGroundColor()
            
            Control_not_come.backgroundColor = UIColor.lightGray
            img_notCome.image = #imageLiteral(resourceName: "Rounded_red")
            
            Control_panding.backgroundColor = UIColor.lightGray
            img_Panding.image = #imageLiteral(resourceName: "Rounded_yellow")
        }
    }
    
    @IBAction func Click_Not_come_state(_ sender: UIControl) {
        
        if lblPending.text?.lowercased() != "arrived" && lblPending.text?.lowercased() != "pending"{
            img_notCome.image = #imageLiteral(resourceName: "Group_name")
            Control_not_come.backgroundColor = UIColor.appNotcome()
            
            Control_completed.backgroundColor = UIColor.lightGray
            img_completed.image =  #imageLiteral(resourceName: "round")
            
            Control_panding.backgroundColor = UIColor.lightGray
            img_Panding.image = #imageLiteral(resourceName: "Rounded_yellow")
        }
    }
    
    //MARK: - Alert Click
    @IBAction func Click_alert_save(_ sender: Any) {
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
        seconds -= 1

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
    
    func requestComplete(statusA:String) {
        
        var dic = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        dic["user_id"] = userid
        dic["status"] = statusA
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
                    self.showModal()
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
