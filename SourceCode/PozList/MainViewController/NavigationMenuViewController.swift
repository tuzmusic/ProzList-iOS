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
    let menuItems = [#imageLiteral(resourceName: "profile"),#imageLiteral(resourceName: "create_request"),#imageLiteral(resourceName: "request_status"),#imageLiteral(resourceName: "job_history"),#imageLiteral(resourceName: "servey"),#imageLiteral(resourceName: "log_out")]
    let menuItems_text = ["Profile", "Create Request","Request Status","Job History","Survey","LOG OUT"]
    @IBOutlet weak var tableView: UITableView!

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as! MenuCell
        cell.Img.image = menuItems[indexPath.row]
        cell.lbl.text = menuItems_text[indexPath.row]
        if indexPath.row ==  menuItems.endIndex {
            cell.lbl.font = UIFont.init(name: FontName.RobotoLight, size: 14.0)
        }else{
             cell.lbl.font = UIFont.init(name: FontName.RobotoLight, size: 16.0)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }
        
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
        menuContainerViewController.hideSideMenu()
    }
}
