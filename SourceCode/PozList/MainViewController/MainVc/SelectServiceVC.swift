//
//  SelectServiceVC.swift
//  ProzList
//
//  Created by Devubha Manek on 28/09/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class SelectServiceVC: UIViewController, SideMenuItemContent {
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
}
