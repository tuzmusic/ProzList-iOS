//
//  AwardGivanVC.swift
//  PozList
//
//  Created by Devubha Manek on 12/1/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import InteractiveSideMenu
class AwardGivanVC: UIViewController ,SideMenuItemContent {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ClickMenu(_ sender: UIButton) {
        showSideMenu()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
