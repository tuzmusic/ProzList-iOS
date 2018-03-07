//
// NavigationMenuViewController.swift
//
// Copyright 2017 Handsome LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit


class MenuCell:UITableViewCell{
    
    @IBOutlet weak var btnSwitchOnOff: UIControl!
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var imgSwitchToggle: UIImageView!
}

class NavigationMenuViewController: UIViewController {

    let kCellReuseIdentifier = "MenuCell"
    let menu_User = [#imageLiteral(resourceName: "profile"),#imageLiteral(resourceName: "create_request"),#imageLiteral(resourceName: "request_status"),#imageLiteral(resourceName: "job_history"),#imageLiteral(resourceName: "servey"),#imageLiteral(resourceName: "log_out")]
    let menu_user_text = ["Profile", "Create Request","Request Status","Job History","Survey","LOG OUT"]
    
    var appuser = ""
    let menu_service_pro = [#imageLiteral(resourceName: "profile"),#imageLiteral(resourceName: "service_location"),#imageLiteral(resourceName: "request_status"),#imageLiteral(resourceName: "request_list"),#imageLiteral(resourceName: "award"),#imageLiteral(resourceName: "servey"),#imageLiteral(resourceName: "img"),#imageLiteral(resourceName: "log_out")]
    let menu_service_pro_text = ["Profile", "Nearby Job Request","Current Request","Request List","Award Given","Strikes and Review","On Duty / Off Duty","LOG OUT"]
    @IBOutlet weak var tableView: UITableView!

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        let usertpr =  UserDefaults.Main.string(forKey: .Appuser)
        appuser = usertpr
  
        // Select the initial row
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
    }
    
    @IBAction func Close_menu(_ sender: Any) {
        
        self.sideMenuViewController!.hideMenuViewController()
    }
}

/*
 Extention of `NavigationMenuViewController` class, implements table view delegates methods.
 */
extension NavigationMenuViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if  appuser == UserType.ServiceProvider.rawValue {  //"ServiceProvider"
            return menu_service_pro.count
        }else{// User
            return menu_User.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! MenuCell
      
        if  appuser == UserType.ServiceProvider.rawValue{ //"ServiceProvider"
            cell.Img.image = menu_service_pro[indexPath.row]
            cell.lbl.text = menu_service_pro_text[indexPath.row]
            if cell.lbl.text == "On Duty / Off Duty"{
                
                if UserDefaults.Main.bool(forKey: .isDutyOnOff){
                    cell.imgSwitchToggle.image = UIImage.init(named: "ToggleOn")
                }else{
                    
                    cell.imgSwitchToggle.image = UIImage.init(named: "ToggleOff")
                }
                
                cell.btnSwitchOnOff.isHidden = false
                cell.btnSwitchOnOff.addTarget(self, action: #selector(btnSwitchToggleTapped), for: UIControlEvents.touchUpInside)
            }else{
                cell.btnSwitchOnOff.isHidden = true
            }
            
        }else{  // User
            cell.Img.image = menu_User[indexPath.row]
            cell.lbl.text = menu_user_text[indexPath.row]
            cell.btnSwitchOnOff.isHidden = true
        }
        
        if indexPath.row ==  menu_User.endIndex {
            cell.lbl.font = UIFont.init(name: FontName.RobotoLight, size: 14.0)
        }else{
             cell.lbl.font = UIFont.init(name: FontName.RobotoLight, size: 16.0)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var strValue:String = ""
        
        if  appuser == UserType.ServiceProvider.rawValue {  //"ServiceProvider"
            strValue = menu_service_pro_text[indexPath.row]
        }else{// User
            strValue = menu_user_text[indexPath.row]
        }
        
        
        if strValue == "LOG OUT" {
            //appDelegate.setLoginView()
            self.sideMenuViewController!.hideMenuViewController()
            self.showLogOutAlert()
        } else if strValue == "Profile" {
            if  appuser == UserType.ServiceProvider.rawValue {  //"ServiceProvider"
                self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "ServiceProviderProfileVC")), animated: true)
            }else{// User
                self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: storyBoards.Customer.instantiateViewController(withIdentifier: "EditProfileVC")), animated: true)
            }
            self.sideMenuViewController!.hideMenuViewController()
        } else if strValue == "Create Request" {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: storyBoards.Customer.instantiateViewController(withIdentifier: "SelectServiceVC")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        } else if strValue == "Request Status" {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: storyBoards.Customer.instantiateViewController(withIdentifier: "RequestStatusListVC")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        } else if strValue == "Job History" {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: storyBoards.Customer.instantiateViewController(withIdentifier: "JobHistoryVC")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        } else if strValue == "Survey" {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: storyBoards.Customer.instantiateViewController(withIdentifier: "SurveyVC")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        } else if strValue == "Nearby Job Request" {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "NearJobVC")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        }else if strValue == "Request List" {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "RequsetListVC")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        } else if strValue == "Current Request" {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "CurrentRequestVC")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        } else if strValue == "Award Given" {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "AwardGivanVC")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        } else if strValue == "Strikes and Review" {
            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "StricksAndReviewVC")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        } else if strValue == "on Duty / Off Duty" {
//            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "SecondViewController")), animated: true)
//            self.sideMenuViewController!.hideMenuViewController()
        }
        
        
        /*
        //let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier) as! MenuCell
        let  cell = tableView.cellForRow(at: indexPath) as! MenuCell

        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        let steText = cell.lbl.text
        
        if steText == "LOG OUT" {
            UserDefaults.Main.removeObj(forKey: .isLogin)
            UserDefaults.Main.removeObj(forKey: .Appuser)
            UserDefaults.Main.removeObj(forKey: .UserID)
            menuContainerViewController.hideSideMenu()
            let loginVc = storyBoards.Main.instantiateViewController(withIdentifier: "LoginVC") as! UINavigationController
            menuContainerViewController.selectContentViewController(loginVc)
            return
            
        }
        
        if indexPath.row > menuContainerViewController.contentViewControllers.count{
             menuContainerViewController.hideSideMenu()
            return
        }
        
        if indexPath.row != 6 { // For not click on option "on Duty / Off Duty"
            menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
            menuContainerViewController.hideSideMenu()
        } */
    }
    
    func showLogOutAlert() {
        
        
        let alert = UIAlertController(title: "ProzList", message: "Are you wnat to Logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: { (cancel) in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            DispatchQueue.main.async {
                
                UserDefaults.Main.removeObj(forKey: .isLogin)
                UserDefaults.Main.removeObj(forKey: .Appuser)
                UserDefaults.Main.removeObj(forKey: .UserID)
                
                let Main = UIStoryboard(name: "Main", bundle: Bundle.main)
                let loginVc = Main.instantiateViewController(withIdentifier: "LoginVC")
                appDelegate.window?.rootViewController = loginVc
            }
        }))
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    @objc func btnSwitchToggleTapped(){
        
        if UserDefaults.Main.bool(forKey: .isDutyOnOff){
            UserDefaults.Main.set(false, forKey: .isDutyOnOff)
            setDutyOnOffAPI(status: "off")
        }else{
            UserDefaults.Main.set(true, forKey: .isDutyOnOff)
            setDutyOnOffAPI(status: "on")
        }
        UserDefaults.standard.synchronize()
        tableView.reloadData()
        
        
    }
}

extension NavigationMenuViewController {
    
    func setDutyOnOffAPI(status:String) {
        
        var dic = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        dic["user_id"] = userid
        dic["status"] = status   //status=on,off"
     
        
        appDelegate.showLoadingIndicator()
        MTWebCall.call.setDutyOnOffAPI(dictParam: dic) { (respons, status) in
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
