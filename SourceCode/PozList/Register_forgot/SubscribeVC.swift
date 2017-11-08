//
//  SubscribeVC.swift
//  PozList
//
//  Created by Devubha Manek on 16/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class SubscribeVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func click_back(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_subscribe(_ sender: UIControl) {
        let selected_service = storyBoards.Menu.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
        self.navigationController?.pushViewController(selected_service, animated: true)
        
        
    }
    
    

}
