//
//  JobHistoryVC.swift
//  PozList
//
//  Created by Devubha Manek on 04/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

class JobHistoryCell : UITableViewCell{
    
    
    @IBOutlet weak var view_back_icon: UIView!
    @IBOutlet weak var img_stauts: UIImageView!
    @IBOutlet weak var view_compl: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_complete: UILabel!
    @IBOutlet weak var lbl_sub_title: UILabel!
    
}

import UIKit
import InteractiveSideMenu

class JobHistoryVC: UIViewController, SideMenuItemContent {
    var app_job_history = Array<Any>()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Click_menu(_ sender: Any) {
        showSideMenu()
    }
    
    
}
extension JobHistoryVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobHistoryCell") as!  JobHistoryCell
        
        if indexPath.row % 2 == 0{
            
            cell.view_compl.backgroundColor = UIColor.appGreen()
              cell.view_back_icon.backgroundColor = UIColor.appGreen()
             cell.img_stauts.image = #imageLiteral(resourceName: "completed")
            cell.lbl_complete.text = "COMPLETED"
            
        }else{
            cell.view_compl.backgroundColor = UIColor.red
            cell.view_back_icon.backgroundColor = UIColor.red
               cell.img_stauts.image = #imageLiteral(resourceName: "completed_not")
             cell.lbl_complete.text = "NOT COMPLETED"
        }
        cell.lbl_title.text = " Plumbling"
         cell.lbl_sub_title.text = "12 september 2017"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyBoards.Menu.instantiateViewController(withIdentifier: "JobProfileVC") as! JobProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
