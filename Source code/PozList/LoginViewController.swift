//
//  ViewController.swift
//  ProzList
//
//  Created on 26/09/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController,CustomToolBarDelegate,UIActionSheetDelegate {
	
	
	var toolBar : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: true)
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var txtfld_email: SkyFloatingLabelTextField!
	@IBOutlet weak var txtfld_password: SkyFloatingLabelTextField!
	
	let emailMessage = "Email is required.".localized
	let emailMessage1 =  "Please Enter Valid Email".localized
	let passwordMessage = "Password is required.".localized
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		setupAllTextFields()
		
		//        let selected_service = storyBoards.Menu.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
		//        self.navigationController?.pushViewController(selected_service, animated: true)
	}
	func setupAllTextFields(){
		self.txtfld_email.text = ""
		self.txtfld_password.text = ""
		self.txtfld_password.isSecureTextEntry = true
		
		self.txtfld_email.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
		self.txtfld_email.placeholderFont = UIFont.init(name: FontName.RobotoLight, size: 16)
		self.txtfld_email.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
		if #available(iOS 10.0, *) {
			self.txtfld_email.textContentType = UITextContentType.emailAddress
		} else {
			// Fallback on earlier versions
		}
		
		self.txtfld_password.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
		self.txtfld_password.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
		self.txtfld_password.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
		
		
	}
	
	
	@IBAction func signIn(_ sender: Any) {
		
		guard validateData() else { return }
		self.loginApiCall()

		//		TUZ: This alert message doesn't make sense, we're not registering.
		//		In fact, if we're just signing in successfully we don't need any alert.
		//		But we definitely do need some kind of failure handling! Not to mention actual signing in!
		//		(Maybe this is a dummy signin for now?)
		let alert = UIAlertController(title: "Congratulations".localized, message: "Your registration is successful!!!".localized, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (cancel) in
			
			DispatchQueue.main.async {
				self.txtfld_email.text           = ""
				self.txtfld_password.text        = ""
				
				// TUZ NOTE: Here's a example const from storyBoards (there's no "Menu" but this is the form we "should" be dealing with)
				// static let Main = UIStoryboard(name: "Main", bundle: Bundle.main)
				let selected_service = storyBoards.Menu.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
				self.navigationController?.pushViewController(selected_service, animated: true)
				
			}
		}))
		present(alert, animated: true, completion: nil)
		
	}
	
	@IBAction func signUp(_ sender: UIButton) {
		let actionSheetController = UIAlertController(title: "Sign Up", message: "", preferredStyle: .actionSheet)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		actionSheetController.addAction(cancelAction)
		
		let forServiceProviderAction = UIAlertAction(title: "For Service provider", style: .default) { action in
			let vc = storyBoards.Main.instantiateViewController(withIdentifier: "ServiceProvicerSignUpVC") as! ServiceProvicerSignUpVC
			self.navigationController?.pushViewController(vc, animated: true)
		}
		actionSheetController.addAction(forServiceProviderAction)
		
		let forCustomerAction = UIAlertAction(title: "For Customer", style: .default) { action in
			let vc = storyBoards.Main.instantiateViewController(withIdentifier: "RegisterVc") as! RegisterVc
			self.navigationController?.pushViewController(vc, animated: true)
		}
		actionSheetController.addAction(forCustomerAction)
		
		// Present the AlertController
		self.present(actionSheetController, animated: true, completion: nil)
	}
	
	func loginApiCall() {
		
		var peraDic = [String:Any]()
		
		peraDic["password"] = self.txtfld_password.text!
		peraDic["email"] = self.txtfld_email.text!
		
		appDelegate.showLoadingIndicator()
		MTWebCall.call.login(dictParam: peraDic) { (res, status) in
			appDelegate.hideLoadingIndicator()
			jprint(items: status)
			guard (status == 200 && res != nil) else {
				appDelegate.Popup(Message: NSLocalizedString("Somthing went wrong \n Try after sometime", comment: ""))
				return
			}
			let dictResponse = res as! NSDictionary
			let response = getStringFromDictionary(dictionary: dictResponse, key: "response")
			guard  response == "true" else {
				appDelegate.Popup(Message: "\(getStringFromDictionary(dictionary: dictResponse, key: "msg"))")
				return
			}
			
			print(getStringFromDictionary(dictionary: dictResponse, key: "msg"))
			
			let dictData = getDictionaryFromDictionary(dictionary: dictResponse, key: "data")
			let type = createString(value: dictData.value(forKey: "role") as AnyObject)
			let status = createString(value: dictData.value(forKey: "status") as AnyObject)
			switch type {
			case UserType.Customer.rawValue:
				UserDefaults.Main.set(UserType.Customer.rawValue, forKey: .Appuser)
				let id = createString(value:dictData.value(forKey: "id") as AnyObject)
				let username = createString(value: dictData.value(forKey: "name") as AnyObject)
				let email = createString(value: dictData.value(forKey: "email") as AnyObject)
				let mobile = createString(value: dictData.value(forKey: "phone") as AnyObject)
				let profilePic = createString(value: dictData.value(forKey: "profile_pic") as AnyObject)
				let city = createString(value: dictData.value(forKey: "status") as AnyObject)
				
				let userdate = Profile.init(id: id, username: username, email: email, mobile: mobile, type: type, status: status, city: city, profileImg: profilePic, avgRating: "")
				
				UserDefaults.Main.set(true, forKey: .isLogin)
				UserDefaults.Main.set(id, forKey: .UserID)
				
				let usertype = UserType.Customer
				UserDefaults.Main.set(usertype.rawValue, forKey: .Appuser)
				let userDate1 = NSKeyedArchiver.archivedData(withRootObject: userdate)
				UserDefaults.Main.set(userDate1, forKey: .Profile)
				let selected_service = storyBoards.Customer.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
				self.navigationController?.pushViewController(selected_service, animated: true)
			case UserType.ServiceProvider.rawValue:				
				let id = createString(value:dictData.value(forKey: "id") as AnyObject)
				
				UserDefaults.Main.set(id, forKey: .UserID)
				
				let usertype = UserType.ServiceProvider
				UserDefaults.Main.set(usertype.rawValue, forKey: .Appuser)
				
				let certified = createString(value: dictData.value(forKey: "certified") as AnyObject)
				let subcrib = createString(value: dictData.value(forKey: "subscribed") as AnyObject)
				UserDefaults.Main.set((dictData.getString(key: "duty_status") == "on"), forKey: .isDutyOnOff)
				
				if certified == "false" {
					let vc = storyBoards.Main.instantiateViewController(withIdentifier: "UploadCertificateVC") as! UploadCertificateVC
					self.navigationController?.pushViewController(vc, animated: true)
				} else if subcrib == "false" {
					let vc = storyBoards.Main.instantiateViewController(withIdentifier: "SubscribeVC") as! SubscribeVC
					self.navigationController?.pushViewController(vc, animated: true)
				} else if status == "Active"{
					UserDefaults.Main.set(true, forKey: .isLogin)
					UserDefaults.Main.set(true, forKey: .isCertificated)
					UserDefaults.Main.set(true, forKey: .isSubscribed)
					
					let selected_service = storyBoards.Customer.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
					self.navigationController?.pushViewController(selected_service, animated: true)
				}
				else {
					let message = getStringFromDictionary(dictionary: dictResponse, key: "msg")
					appDelegate.Popup(Message: "\(message)")
				}
				UserDefaults.standard.synchronize()
			}
		}
	}
}

extension LoginViewController : UITextFieldDelegate {
	
	// MARK:- =======================================================
	//MARK: - Textfield Delegate Method
	func resetErrorMessage(_ textField: UITextField) {
		if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
			floatingLabelTextField.errorMessage = ""
		}
	}
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		resetErrorMessage(textField)
		textField.inputAccessoryView = toolbarInit(textField: textField);
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		resetErrorMessage(textField)
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		resetErrorMessage(textField)
		textField.resignFirstResponder();
		return true;
	}
	
	// MARK: - Keyboard
	func toolbarInit(textField: UITextField) -> UIToolbar {
		toolBar.delegate1 = self
		toolBar.txtField = textField
		return toolBar;
	}
	func resignKeyboard() {
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
			} else if let nextTextView = self.view.viewWithTag(selectedTextField.tag + 1) as? UITextView {
				nextTextView.becomeFirstResponder()
			} else {
				resignKeyboard()
			}
		} else {
			if let nextField = self.view.viewWithTag(selectedTextField.tag - 1) as? UITextField {
				nextField.becomeFirstResponder()
			} else {	// Not found, so remove keyboard.
				resignKeyboard()
			}
		}
	}
}
// MARK: User Define Methods
extension LoginViewController{
	
	func validateData() -> Bool {
		guard (txtfld_email.text?.count)! > 0 else {
			txtfld_email?.errorMessage = emailMessage
			return false
		}
		guard self.validateEmail(txtfld_email.text!) else {
			txtfld_email?.errorMessage = emailMessage1
			return false
		}
		guard (txtfld_password.text?.count)! > 0 else {
			txtfld_email?.errorMessage = passwordMessage
			return false
		}
		return true
	}
	
	
	func validateEmail(_ candidate: String) -> Bool {
		
		let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
	}
	
}
