//
//  ViewController.swift
//  ProzList
//
//  Created by Devubha Manek on 26/09/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CustomToolBarDelegate {
    
    
    var toolBar : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: true)
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtfld_email: DTTextField!
    @IBOutlet weak var txtfld_password: DTTextField!
    
    let emailMessage = "Email is required.".localized
    let passwordMessage = "Password is required.".localized
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtfld_email.canShowBorder = false
        txtfld_password.canShowBorder = false
        
        self.txtfld_email.text           = ""
        self.txtfld_password.text        = ""
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BtnSubmitClicked(_ sender: Any) {
        
        guard validateData() else { return }
        
        let alert = UIAlertController(title: "Congratulations".localized, message: "Your registration is successful!!!".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (cancel) in
            
            DispatchQueue.main.async {
                self.txtfld_email.text           = ""
                self.txtfld_password.text        = ""
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
//        DispatchQueue.main.async {
//            DispatchQueue.main.async {
//                self.scrollView.scrollRectToVisible(textField.bounds, animated: true)
//            }
//        }
        
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
        
        
        guard !txtfld_email.text!.isEmptyStr else {
            txtfld_email.showError(message: emailMessage)
            return false
        }
        
        guard !txtfld_password.text!.isEmptyStr else {
            txtfld_password.showError(message: passwordMessage)
            return false
        }
        
        return true
    }
}
