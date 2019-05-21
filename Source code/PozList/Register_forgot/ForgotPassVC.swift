//
//  ForgotPassVC.swift
//  PozList
//
//  Created on 29/09/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPassVC: UIViewController,CustomToolBarDelegate {

   // @IBOutlet weak var txt_email: DTTextField!
    
    @IBOutlet var txt_email: SkyFloatingLabelTextField!
    var toolBar : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: false)
    
    let emailMessage = "Email is required.".localized
    let emailMessage1 =  "Please Enter Valid Email".localized
    
    
    //MARK: - View initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txt_email.text = ""
        
        self.txt_email.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_email.placeholderFont = UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txt_email.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickSignUp(_ sender: UIButton) {
        
        /*for viewContro in (self.navigationController?.viewControllers)!{
            if viewContro is ViewController{
                
                self.navigationController?.popViewController(animated: true)
                break
            }
        }*/
        
        //By Gautam
        // Create the AlertController
        let actionSheetController = UIAlertController(title: "Sign Up", message: "", preferredStyle: .actionSheet)
        
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
        let choosePictureAction = UIAlertAction(title: "For Customer", style: .default) { action -> Void in
            
            
            let vc = storyBoards.Main.instantiateViewController(withIdentifier: "RegisterVc") as! RegisterVc
            self.navigationController?.pushViewController(vc, animated: true)
        }
        actionSheetController.addAction(choosePictureAction)
        
        // Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    @IBAction func SendClick(_ sender: Any) {
        
        guard validateData() else { return }
//        let selected_service = storyBoards.Menu.instantiateViewController(withIdentifier:"LoginVC") as! HostViewController
//        self.navigationController?.pushViewController(selected_service, animated: true)
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ForgotPassVC : UITextFieldDelegate {
    
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField
        {
            floatingLabelTextField.errorMessage = ""
        }
        textField.resignFirstResponder();
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField
        {
            floatingLabelTextField.errorMessage = ""
        }
        
        return true
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

// MARK: User Define Methods
extension ForgotPassVC{
    
    func validateData() -> Bool {
        
        
        guard (txt_email.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txt_email
            {
                floatingLabelTextField.errorMessage = emailMessage
            }
            return false
        }
        guard self.validateEmail(txt_email.text!) else
        {
            if let floatingLabelTextField = txt_email
            {
                floatingLabelTextField.errorMessage = emailMessage1
            }
            return false
        }
        self.forgotPassApiCall()
        return true
        
    }
    
    func validateEmail(_ candidate: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func forgotPassApiCall() {
        var dict = [String:Any]()
        dict["email"] = txt_email.text
        appDelegate.showLoadingIndicator()
        MTWebCall.call.forgotPassword(dictParam: dict) { (respons, status) in
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
                    
                    let alert = UIAlertController(title: "ProzList".localized, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (cancel) in
                        DispatchQueue.main.async {
                            for viewContro in (self.navigationController?.viewControllers)!{
                                if viewContro is LoginViewController{
                                    self.navigationController?.popViewController(animated: true)
                                    break
                                }
                            }
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
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
