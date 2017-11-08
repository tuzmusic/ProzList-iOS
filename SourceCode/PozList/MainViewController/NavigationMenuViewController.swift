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
import InteractiveSideMenu
class MenuCell:UITableViewCell{
    
    @IBOutlet weak var Img: UIImageView!
    
    @IBOutlet weak var lbl: UILabel!
    
}

class NavigationMenuViewController: MenuViewController {

    let kCellReuseIdentifier = "MenuCell"
    let menu_User = [#imageLiteral(resourceName: "profile"),#imageLiteral(resourceName: "create_request"),#imageLiteral(resourceName: "request_status"),#imageLiteral(resourceName: "job_history"),#imageLiteral(resourceName: "servey"),#imageLiteral(resourceName: "log_out")]
    let menu_user_text = ["Profile", "Create Request","Request Status","Job History","Survey","LOG OUT"]
    
    var appuser = ""
    
    
    
    let menu_service_pro = [#imageLiteral(resourceName: "profile"),#imageLiteral(resourceName: "service_location"),#imageLiteral(resourceName: "request_status"),#imageLiteral(resourceName: "job_history"),#imageLiteral(resourceName: "request_status"),#imageLiteral(resourceName: "servey"),#imageLiteral(resourceName: "img"),#imageLiteral(resourceName: "log_out")]
    let menu_service_pro_text = ["Profile", "Nearby Job Request","Current Request","Request List","Award Given","Strikes and Review","on Duty / Off Duty","LOG OUT"]
    @IBOutlet weak var tableView: UITableView!

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let usertpr =  UserDefaults.Main.string(forKey: .Appuser)
        appuser = usertpr
  
        // Select the initial row
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
    }
    
    @IBAction func Close_menu(_ sender: Any) {
        
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        menuContainerViewController.hideSideMenu()
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
            
        }else{  // User
            cell.Img.image = menu_User[indexPath.row]
            cell.lbl.text = menu_user_text[indexPath.row]
        }
        
        if indexPath.row ==  menu_User.endIndex {
            cell.lbl.font = UIFont.init(name: FontName.RobotoLight, size: 14.0)
        }else{
             cell.lbl.font = UIFont.init(name: FontName.RobotoLight, size: 16.0)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier) as! MenuCell
        let  cell = tableView.cellForRow(at: indexPath) as! MenuCell

        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        let steText = cell.lbl.text
        
        if steText == "LOG OUT" {
            menuContainerViewController.hideSideMenu()
            let loginVc = storyBoards.Main.instantiateViewController(withIdentifier: "LoginVC") as! UINavigationController
            menuContainerViewController.selectContentViewController(loginVc)
            return
            
        }
        if indexPath.row > menuContainerViewController.contentViewControllers.count{
             menuContainerViewController.hideSideMenu()
            return
        }
   
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
        menuContainerViewController.hideSideMenu()
    }
    
    func showLogOutAlert() {

        /*
        let alert = UIAlertController(title: "ProzList".localized, message: "Are you wnat to Logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: { (cancel) in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            DispatchQueue.main.async {
                for viewContro in (self.navigationController?.viewControllers)!{
                    if viewContro is ViewController{
                        self.navigationController?.popViewController(animated: true)
                        break
                    }
                }
            }
        }))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
         */
    }
}
