//
//  ViewController.swift
//  ProzList
//
//  Created by Devubha Manek on 26/09/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ViewController: UIViewController,CustomToolBarDelegate {
    
    
    var toolBar : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: true)
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtfld_email: SkyFloatingLabelTextField!
    @IBOutlet weak var txtfld_password: SkyFloatingLabelTextField!
    
    let emailMessage = "Email is required.".localized
     let emailMessage1 =  "Please Enter Valid Email".localized
    let passwordMessage = "Password is required.".localized
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
       
        
        setupAllTextFiels()
       
        
//        let selected_service = storyBoards.Menu.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
//        self.navigationController?.pushViewController(selected_service, animated: true)
    }
    func setupAllTextFiels(){
        self.txtfld_email.text = ""
        self.txtfld_password.text = ""
        
        self.txtfld_email.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txtfld_email.placeholderFont = UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txtfld_email.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
        
        self.txtfld_password.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txtfld_password.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txtfld_password.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BtnSubmitClicked(_ sender: Any) {
        
     //   guard validateData() else { return }
        
        let alert = UIAlertController(title: "Congratulations".localized, message: "Your registration is successful!!!".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (cancel) in
            
            DispatchQueue.main.async {
                self.txtfld_email.text           = ""
                self.txtfld_password.text        = ""
                
                let selected_service = storyBoards.Menu.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
                self.navigationController?.pushViewController(selected_service, animated: true)
                
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController : UITextFieldDelegate {

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
        txtfld_email.resignFirstResponder()
        txtfld_password.resignFirstResponder()
        
    }
    // MARK: - Custom ToolBar Delegates
    
    func getSegmentIndex(segmentIndex: Int,selectedTextField: UITextField) {
        print(selectedTextField.tag)
        if segmentIndex == 1 {

            if let nextField = self.view.viewWithTag(selectedTextField.tag + 1) as? UITextField {
                print(nextField.tag)
                nextField.becomeFirstResponder()
            }
            else if let nextTextView = self.view.viewWithTag(selectedTextField.tag + 1) as? UITextView
            {
                nextTextView.becomeFirstResponder()
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
extension ViewController{
    
    func validateData() -> Bool {
        

        guard (txtfld_email.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txtfld_email
            {
                floatingLabelTextField.errorMessage = emailMessage
            }
            return false
        }
        guard self.validateEmail(txtfld_email.text!) else
        {
            if let floatingLabelTextField = txtfld_email
            {
                floatingLabelTextField.errorMessage = emailMessage1
            }
            return false
        }
        guard (txtfld_password.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txtfld_password
            {
                floatingLabelTextField.errorMessage = passwordMessage
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
