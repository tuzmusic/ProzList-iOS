//
//  RegisterVc.swift
//  ProzList
//
//  Created by Devubha Manek on 26/09/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterVc: UIViewController,CustomToolBarDelegate	 {

     var toolBar : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: true)
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var txt_name: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_email: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_phone: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_password: SkyFloatingLabelTextField!
    
    let nameMessage = "Your name is required.".localized
    let emailMessage = "Email is required.".localized
    let emailMessage1 =  "Please Enter Valid Email".localized
    let phoneMessage = "Phone number is required.".localized
    let passwordMessage = "Password is required.".localized
    let passwordMessage1 = "Password atleast 8 character".localized
    
    var txt_y:CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAllTextFiels()
    }
    func setupAllTextFiels(){
        
        self.txt_name.text = ""
        self.txt_email.text = ""
        self.txt_phone.text = ""
        self.txt_password.text = ""
        
        
        self.txt_name.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_name.placeholderFont = UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txt_name.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
        
        self.txt_email.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_email.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txt_email.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
        
        self.txt_phone.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_phone.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txt_phone.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
        self.txt_password.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_password.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txt_password.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
        
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
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField
        {
            floatingLabelTextField.errorMessage = ""
        }
        textField.inputAccessoryView = toolbarInit(textField: textField);
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField
        {
            floatingLabelTextField.errorMessage = ""
        }
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField
        {
            floatingLabelTextField.errorMessage = ""
        }
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
       
        txt_name.resignFirstResponder()
        txt_email.resignFirstResponder()
        txt_phone.resignFirstResponder()
        txt_password.resignFirstResponder()
        

        guard (txt_name.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txt_name
            {
                floatingLabelTextField.errorMessage = nameMessage
            }
            return false
        }
        
        guard (txt_email.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txt_email
            {
                floatingLabelTextField.errorMessage = emailMessage
            }
            return false
        }
       
        guard self.validateEmail( txt_email.text!) else
        {
            if let floatingLabelTextField = txt_email
            {
                floatingLabelTextField.errorMessage = emailMessage1
            }
            return false
        }
       
        guard (txt_phone.text?.characters.count)! > 0  && (txt_phone.text?.characters.count)! == 10 else
        {
            if let floatingLabelTextField = txt_phone
            {
                floatingLabelTextField.errorMessage = phoneMessage
            }
            return false
        }
        guard (txt_password.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txt_password
            {
                floatingLabelTextField.errorMessage = passwordMessage
            }
            return false
        }
        guard (txt_password.text?.characters.count)! == 8 else
        {
            if let floatingLabelTextField = txt_password
            {
                floatingLabelTextField.errorMessage = passwordMessage1
            }
            return false
        }
        return true
    }
    
    func validateEmail(_ candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
}