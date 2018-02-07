//
//  PaymentRecipetVC.swift
//  PozList
//
//  Created by Devubha Manek on 06/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
class PaymentRecipetVC: UIViewController {

    @IBOutlet weak var view_main: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            DispatchQueue.main.async {
                let width = self.view_main.frame.size.width
                let noOfImage = Int(width) / 35
                
                for i in 0...noOfImage - 1 {
                    let imges = UIImageView.init(frame: CGRect(x: (35*i) + Int(self.view_main.frame.origin.x) , y:  Int(self.view_main.frame.origin.y - 17), width: 35, height: 17))
                    imges.image = #imageLiteral(resourceName: "border_payment_top")
                    self.scrollView.addSubview(imges)
                }
                
                for i in 0...noOfImage - 1 {
                    let imges = UIImageView.init(frame: CGRect(x: (35*i) + Int(self.view_main.frame.origin.x) , y: Int( self.view_main.frame.size.height ) + Int(self.view_main.frame.origin.y), width: 35, height: 17))
                    imges.image = #imageLiteral(resourceName: "border_bottom_payment")
                    self.scrollView.addSubview(imges)
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ClickBack(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
}
