//
//  ForgotPassVC.swift
//  PozList
//
//  Created by Devubha Manek on 29/09/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class ForgotPassVC: UIViewController,CustomToolBarDelegate {

    @IBOutlet weak var txt_email: DTTextField!
     var toolBar : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txt_email.canShowBorder = false
        self.txt_email.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SendClick(_ sender: Any) {
        let selected_service = storyBoards.Menu.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
        self.navigationController?.pushViewController(selected_service, animated: true)
    }
}
extension ForgotPassVC : UITextFieldDelegate {
    
    
    // MARK:- =======================================================
    //MARK: - Textfield Delegate Method
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        
        textField.inputAccessoryView = toolbarInit(textField: textField);
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
    // MARK: - Keyboard
    func toolbarInit(textField: UITextField) -> UIToolbar
    {
        toolBar.delegate1 = self
        toolBar.txtField = textField
        return toolBar;
    }
    func resignKeyboard()
    {
        self.txt_email.resignFirstResponder()
        
        
    }
    
    func closeKeyBoard() {
        resignKeyboard()
    }
}
