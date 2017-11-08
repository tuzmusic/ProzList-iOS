//
//  ViewController.swift
//  ProzList
//
//  Created by Devubha Manek on 26/09/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ViewController: UIViewController,CustomToolBarDelegate,UIActionSheetDelegate {
    
    
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
        
        guard validateData() else { return }
        
        /*
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
         */
    }
    
    @IBAction func signIn(_ sender: UIButton) {
   
        // Create the AlertController
        let actionSheetController = UIAlertController(title: "SignIn", message: "", preferredStyle: .actionSheet)
        
        // Create and add the Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
          
        }
        actionSheetController.addAction(cancelAction)
        
        // Create and add first option action
        let takePictureAction = UIAlertAction(title: "For Service provider", style: .default) { action -> Void in
           
           
            let vc = storyBoards.Main.instantiateViewController(withIdentifier: "ServiceProvicerSignUpVC") as! ServiceProvicerSignUpVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        actionSheetController.addAction(takePictureAction)
        
        // Create and add a second option action
        let choosePictureAction = UIAlertAction(title: "For User", style: .default) { action -> Void in
            
           
            let vc = storyBoards.Main.instantiateViewController(withIdentifier: "RegisterVc") as! RegisterVc
            self.navigationController?.pushViewController(vc, animated: true)
        }
        actionSheetController.addAction(choosePictureAction)
        
        // Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func loginApiCall() {
        
        var peraDic = [String:Any]()
        
        peraDic["password"] = self.txtfld_password.text!
        peraDic["email"] = self.txtfld_email.text!
        
        appDelegate.showLoadingIndicator()
        MTWebCall.call.login(dictParam: peraDic) { (respons, status) in
            appDelegate.hideLoadingIndicator()
            jprint(items: status)
            if (status == 200 && respons != nil) {
                //Response
                let dictResponse = respons as! NSDictionary
                
                let Response = getStringFromDictionary(dictionary: dictResponse, key: "response")
                if Response == "true"
                {
                    //Message
                    let message = getStringFromDictionary(dictionary: dictResponse, key: "msg")
                    print(message)
                    let dictData = getDictionaryFromDictionary(dictionary: dictResponse, key: "data")
                    let id = createString(value:dictData.value(forKey: "id") as AnyObject)
                    let username = createString(value: dictData.value(forKey: "name") as AnyObject)
                    let email = createString(value: dictData.value(forKey: "email") as AnyObject)
                    let mobile = createString(value: dictData.value(forKey: "phone") as AnyObject)
                    let type = createString(value: dictData.value(forKey: "role") as AnyObject)
                    let status = createString(value: dictData.value(forKey: "status") as AnyObject)
                    let city = createString(value: dictData.value(forKey: "status") as AnyObject)
                    let userdate = Profile.init(id: id, username: username, email: email, mobile: mobile, type: type, status: status, city: city)
                    
                    UserDefaults.Main.set(true, forKey: .isSignUp)
                    //UserDefaults.Main.set(userdate, forKey: .Profile)
                    UserDefaults.Main.set(id, forKey: .UserID)
                    
                    let selected_service = storyBoards.Menu.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
                    self.navigationController?.pushViewController(selected_service, animated: true)
                    
                }else
                {
                    //Popup
                    let message = getStringFromDictionary(dictionary: dictResponse, key: "msg")
                    appDelegate.Popup(Message: "\(message)")
                }
            } else {
                //Popup
                let Title = NSLocalizedString("Somthing went wrong \n Try after sometime", comment: "")
                appDelegate.Popup(Message: Title)
            }
        }
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
        
        self.loginApiCall()
        return true
        
    }
    
    
    func validateEmail(_ candidate: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
}
