//
//  CreateReqVC.swift
//  PozList
//
//  Created by Devubha Manek on 05/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class CreateReqVC: UIViewController , SideMenuItemContent {

    @IBOutlet weak var lbl_rating_profile_pic: UILabel!
    @IBOutlet weak var lbl_user_name: UILabel!
    @IBOutlet weak var lbl_user_service_type: UILabel!
    
    @IBOutlet weak var lbl_counter: UILabel!
    
    
    @IBOutlet weak var Alert_view: UIView!
    @IBOutlet weak var lbl_alert_rating: UILabel!
    @IBOutlet weak var view_alert_star: CosmosView!
    @IBOutlet weak var txt_view_alert: UITextView!
    
    @IBOutlet weak var img_completed: UIImageView!
    
    @IBOutlet weak var img_notCome: UIImageView!
    
    var seconds = 0
    var timer = Timer()
    var IsComplete = false
    var isUserAvil:Bool!
    @IBOutlet weak var Contro_not_come: UIControl!
    @IBOutlet var userDetaileView: UIView!
    
    var requestData:ServiceRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isUserAvil {
            let now1 = Date()
            let now =  dateFrm(date: "2017-10-27 10:0:00")
            let endDate = now1
            
            let calendar = Calendar.current
            let unitFlags = Set<Calendar.Component>([ .second])
            let datecomponenets = calendar.dateComponents(unitFlags, from: now, to: endDate)
            let seconds1 = datecomponenets.second
            print(seconds1 ?? 0)
            seconds = seconds1!
            runTimer()
            self.Alert_view.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.Alert_view.frame.size.width , height: self.Alert_view.frame.size.height)
        }
        else {
            userDetaileView.isUserInteractionEnabled = true
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
        }
    }
    @IBAction func Click_Track_service(_ sender: UIControl) {
     
        let vc = storyBoards.Customer.instantiateViewController(withIdentifier: "TrackServiceVC") as! TrackServiceVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func Click_Pending_state(_ sender: Any) {
        
        
    }
    
    @IBAction func Click_completed_state(_ sender: UIControl) {
        if  img_completed.image == #imageLiteral(resourceName: "Group_name"){
            sender.backgroundColor = UIColor.lightGray
            img_completed.image =  #imageLiteral(resourceName: "round")
        }else{
            
            if  img_notCome.image == #imageLiteral(resourceName: "Group_name"){
               self.Click_Not_come_state(Contro_not_come)
            }
            
            sender.backgroundColor = UIColor.appBackGroundColor()
            img_completed.image = #imageLiteral(resourceName: "Group_name")
        }
    }
    
    
    @IBAction func Click_Not_come_state(_ sender: UIControl) {
  
        if  img_completed.image == #imageLiteral(resourceName: "Group_name") {
            return
        }
        
        if  img_notCome.image == #imageLiteral(resourceName: "Group_name"){
            sender.backgroundColor = UIColor.lightGray
            img_notCome.image =  #imageLiteral(resourceName: "Rounded_red")
        }else{
            sender.backgroundColor = UIColor.appNotcome()
            img_notCome.image = #imageLiteral(resourceName: "Group_name")
        }
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
