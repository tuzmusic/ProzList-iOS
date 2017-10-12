//
//  ServiceProvicerSignUpVC.swift
//  PozList
//
//  Created by Devubha Manek on 11/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class ServiceProvicerSignUpVC: UIViewController {

    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var ViewSecond: UIView!
    @IBOutlet weak var ViewFirst: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Next(_ sender: UIControl) {
          let v4x = self.ViewFirst.frame.origin.x
        UIView.animate(withDuration: 0.3, animations: {
            self.ViewFirst.frame.origin.x = -self.ViewFirst.frame.width
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.MainView.bringSubview(toFront: self.ViewSecond)
                self.ViewFirst.frame.origin.x = v4x
//                self.view_Hobbies.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
//
//                self.view_Contact.transform = CGAffineTransform.init(scaleX: 0.8, y: 1.04)
//                self.view_Destination.transform = CGAffineTransform.init(scaleX: 0.9, y: 1.02)
                self.ViewFirst.transform = CGAffineTransform.init(scaleX:  1.0, y:  1.0)
                self.MainView.sendSubview(toBack: self.ViewFirst)
            }, completion: { (true) in
            })
        }
        
    }
    
    @IBAction func previous(_ sender: UIControl) {
         let v4x = self.ViewFirst.frame.origin.x
        UIView.animate(withDuration: 0.3, animations: {
            self.ViewSecond.frame.origin.x = -self.ViewSecond.frame.width
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.MainView.bringSubview(toFront: self.ViewFirst)
                 self.ViewSecond.frame.origin.x = v4x
                //                self.view_personalinfo.frame.origin.x = v4x
                //                self.view_Hobbies.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                //
                //                self.view_Contact.transform = CGAffineTransform.init(scaleX: 0.8, y: 1.04)
                //                self.view_Destination.transform = CGAffineTransform.init(scaleX: 0.9, y: 1.02)
                self.ViewSecond.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                self.MainView.sendSubview(toBack: self.ViewSecond)
                
            }, completion: { (true) in
            })
        }
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
