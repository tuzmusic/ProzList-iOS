//
//  RegisterVc.swift
//  ProzList
//
//  Created by Devubha Manek on 26/09/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class RegisterVc: UIViewController,CustomToolBarDelegate	 {

     var toolBar : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: true)
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txt_name: DTTextField!
    @IBOutlet weak var txt_email: DTTextField!
    @IBOutlet weak var txt_phone: DTTextField!
    @IBOutlet weak var txt_password: DTTextField!
    
    let nameMessage = "Email is required."
    let emailMessage = "Email is required."
    let phoneMessage = "Password is required."
    let passwordMessage = "Password is required."
    
    var txt_y:CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_name.canShowBorder = false
        txt_email.canShowBorder = false
        txt_phone.canShowBorder = false
        txt_password.canShowBorder = false
        
        self.txt_name.text = ""
        self.txt_email.text = ""
        self.txt_phone.text = ""
        self.txt_password.text = ""
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - all Clicks
    
    @IBAction func BtnSubmitClicked(_ sender: Any) {
        
        guard validateData() else { return }
        
        let alert = UIAlertController(title: "Congratulations", message: "Your registration is successful!!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (cancel) in
            DispatchQueue.main.async {
                self.txt_name.text = ""
                self.txt_email.text = ""
                self.txt_phone.text = ""
                self.txt_password.text = ""
                
                let selected_service = storyBoards.Menu.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
                self.navigationController?.pushViewController(selected_service, animated: true)
            }
        }))
        
        present(alert, animated: true, completion: nil)
        
    }

    @IBAction func Click_login(_ sender: Any) {
        var isInNav = false
        for viewContro in (self.navigationController?.viewControllers)!{
            if viewContro is ViewController{
                isInNav = true
                self.navigationController?.popViewController(animated: true)
                break
            }
        }
    }
    
    
}
extension RegisterVc : UITextFieldDelegate {
    
    
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        //scrollView.contentOffset = CGPoint.init(x: 0, y: 0)
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
        txt_name.resignFirstResponder()
        txt_email.resignFirstResponder()
        txt_phone.resignFirstResponder()
        txt_password.resignFirstResponder()
    }
    // MARK: - Custom ToolBar Delegates
    
    func getSegmentIndex(segmentIndex: Int,selectedTextField: UITextField) {
        print(selectedTextField.tag)
        if segmentIndex == 1 {
            
            if let nextField = self.view.viewWithTag(selectedTextField.tag + 1) as? UITextField {
                print(nextField.tag)
                nextField.becomeFirstResponder()
            }
            else {
                resignKeyboard()
            }
        }
        else{
            if let nextField = self.view.viewWithTag(selectedTextField.tag - 1) as? UITextField {
                nextField.becomeFirstResponder()
            }
            else {
                // Not found, so remove keyboard.
                resignKeyboard()
            }
        }
    }
    func closeKeyBoard() {
        resignKeyboard()
    }
}
// MARK: User Define Methods
extension RegisterVc{
    func validateData() -> Bool {
       
        guard !self.txt_name.text!.isEmptyStr else {
            self.txt_name.showError(message: nameMessage)
            return false
        }
        guard !self.txt_email.text!.isEmptyStr else {
            self.txt_email.showError(message: emailMessage)
            return false
        }
        guard !self.txt_phone.text!.isEmptyStr else {
            self.txt_phone.showError(message: phoneMessage)
            return false
        }
        guard !self.txt_password.text!.isEmptyStr else {
            self.txt_password.showError(message: passwordMessage)
            return false
        }
        return true
    }
}
