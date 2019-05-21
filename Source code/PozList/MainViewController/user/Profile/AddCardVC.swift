//
//  AddCardVC.swift
//  PozList
//
//  Created on 17/05/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class AddCardVC: UIViewController ,CustomToolBarDelegate {
    
    
    //MARK: - Variables
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txtCardNumber: UITextField!
    @IBOutlet var imgCardType: UIImageView!
    @IBOutlet var txtCardName: UITextField!
    @IBOutlet var txtExpDate: UITextField!
    @IBOutlet var txtCardCVV: UITextField!
    
    var toolBarDone : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: false)
    var toolBar : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: true)
    var cardData:Card = Card()
    var userProfileData:Profile = Profile()
    
    var datePickerView = UIPickerView()
    var arrMonth = [String]()
    var arrMonthNumber = [String]()
    var arrYear = [String]()
    let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())

    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialize()
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initialize(){
        // append Month
        for value in 1...12 {
            arrMonthNumber.append("\(value)")
        }
        arrMonth = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        
        // Populate years
        let currentYear = components.year
        let shortYearNumber = currentYear!
        let maxYear = currentYear! + 20
        for i in shortYearNumber...maxYear {
            let shortYear = NSString(format: "%d", i)
            arrYear.append(shortYear as String)
        }
        //Date Picker
        self.datePickerView.dataSource = self
        self.datePickerView.delegate = self
        datePickerView.showsSelectionIndicator = true
        self.datePickerView.backgroundColor = UIColor.white
        self.txtExpDate.inputView = datePickerView
    
        
        if let _ = components.day, let month = components.month, let _ = components.year,let _ = components.hour, let _ = components.minute, let _ = components.second {
            
            self.datePickerView.selectRow(month - 1, inComponent: 0, animated: true)
        }
    }
    func setUI(){
        if cardData.card_number == "" {
            lblTitle.text = "Add Card"
        }else{
            lblTitle.text = "Edit Card"
        }
        txtCardNumber.text = cardData.card_number
        txtCardName.text = cardData.card_holder_name
        txtExpDate.text = cardData.card_date
        txtCardCVV.text = cardData.card_cvc
        setCardTypeImage(cardNumber: cardData.card_number.replacingOccurrences(of: " ", with: ""))
    }
    func setCardTypeImage(cardNumber:String){
        let strImg = cardNumber.cardType()?.imageString() ?? "imgCardUnknown.png"
        self.imgCardType.image = UIImage(named: strImg)
    }
    //MARK: - Validate card information
    func validateData() -> Bool {
        
        var cardNumber = self.txtCardNumber.text ?? ""
        cardNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        if !cardNumber.isValidCardNumber() {
            alert(message: "Invalid card number")
            return false
        }
        let cardName = self.txtCardName.text ?? ""
        if cardName.length <= 0 {
            alert(message: "Invalid card holder name")
            return false
        }
        
        let cardExp = self.txtExpDate.text ?? ""
        if cardExp.length <= 0 {
            alert(message: "Invalid card expiry date")
            return false
        }
        
        let cvvNumber = self.txtCardCVV.text ?? ""
        if !cvvNumber.isNumber || cvvNumber.length > 4 || cvvNumber.length < 3 {
            alert(message: "Invalid CVV Number")
            return false
        }
        
        return true
    }
    //MARK: - Btn Pressed Event
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnConfirmPressed(_ sender: Any) {
        if validateData() {
         print("Information Valid")
            let dict = [
                "name":userProfileData.username,
                "email":userProfileData.email,
                "phone":userProfileData.mobile,
                "city":userProfileData.city,
                "card_number":self.txtCardNumber.text!,
                "card_date":self.txtExpDate.text!,
                "card_holder_name":self.txtCardName.text!,
                "card_status":"active",
                "card_cvc":self.txtCardCVV.text!,
            ]
            let userId = UserDefaults.Main.string(forKey: .UserID)
            appDelegate.showLoadingIndicator()
            MTWebCall.call.updateUserProfile(userId: userId, dictParam: dict, block: { (respons, status) in
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
                        UserDefaults.Main.set(true, forKey: .isSignUp)
                        UserDefaults.Main.set(dictData, forKey: .Profile)
                        self.navigationController?.popViewController(animated: true)
//                        let id = createString(value:dictData.value(forKey: "id") as AnyObject)
//                        let username = createString(value: dictData.value(forKey: "name") as AnyObject)
//                        let email = createString(value: dictData.value(forKey: "email") as AnyObject)
//                        let mobile = createString(value: dictData.value(forKey: "phone") as AnyObject)
//                        let type = createString(value: dictData.value(forKey: "role") as AnyObject)
//                        let status = createString(value: dictData.value(forKey: "status") as AnyObject)
//                        let city = createString(value: dictData.value(forKey: "city") as AnyObject)
//                        let imgProfile = createString(value: dictData.value(forKey: "profile_pic") as AnyObject)
//                        let userdate = Profile.init(id: id, username: username, email: email, mobile: mobile, type: type, status: status, city: city, profileImg: imgProfile, avgRating: "")
//
//                        UserDefaults.Main.set(true, forKey: .isSignUp)
//                        //UserDefaults.Main.set(userdate, forKey: .Profile)
//                        UserDefaults.Main.set(id, forKey: .UserID)
//
//
//                        let arrcard = getArrayFromDictionary(dictionary: dictData, key: "card")
//                        if arrcard.count > 0 {
//                            let dictCard = arrcard.firstObject as! NSDictionary
//                            let card_id = createString(value:dictCard.value(forKey: "id") as AnyObject)
//                            let card_cvc = createString(value:dictCard.value(forKey: "card_cvc") as AnyObject)
//                            let card_date = createString(value:dictCard.value(forKey: "card_date") as AnyObject)
//                            let card_holder_name = createString(value:dictCard.value(forKey: "card_holder_name") as AnyObject)
//                            let card_number = createString(value:dictCard.value(forKey: "card_number") as AnyObject)
//                            let issubscribed = createString(value:dictCard.value(forKey: "issubscribed") as AnyObject)
//                            let card_status = createString(value:dictCard.value(forKey: "status") as AnyObject)
//                            let user_id = createString(value:dictCard.value(forKey: "user_id") as AnyObject)
//                            self.cardData = Card.init(id: card_id, card_cvc: card_cvc, card_date: card_date, card_holder_name: card_holder_name, card_number: card_number, issubscribed: issubscribed, status: card_status, user_id: user_id)
//
//
//                        }
//                        //Set Card Details
//                        //Card Detail
//                        self.txtCardNumber.text  = self.cardData.card_number
//                        self.txtCardName.text  = self.cardData.card_holder_name
//                        self.txtExpDate.text  = self.cardData.card_date
//                        self.txtCardCVV.text = self.cardData.card_cvc
//                        self.setCardTypeImage(cardNumber:self.cardData.card_number.replacingOccurrences(of: " ", with: ""))
                        
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

//MARK: - =======================================================
//MARK: - Textfield Delegate Method
extension AddCardVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        textField.autocorrectionType = .no
        if textField.tag == 3 {
            //                textField.keyboardType = UIKeyboardType.phonePad
        }else{
            textField.keyboardType = UIKeyboardType.default
        }
        
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
        
        
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField == self.txtCardNumber)
        {
            
            let str = textField.text! + string
            
            let stringWithoutSpace = str.replacingOccurrences(of: " ", with: "")
            setCardTypeImage(cardNumber: stringWithoutSpace)
            
            if stringWithoutSpace.length % 4 == 0 && (range.location == textField.text?.length)
            {
                if stringWithoutSpace.length != 16
                {
                    textField.text = str+" "    // add space after every 4 characters
                }
                else
                {
                    textField.text = str       // space should not be appended with last digit
                }
                
                return false
            }
            else if str.length > 19
            {
                return false
            }

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
        self.view.endEditing(true)
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
//MARK: - =======================================================
//MARK: - UIPickerview delegate and datasource
extension AddCardVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
            return arrMonth.count
        } else {
            return arrYear.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            
            return arrMonth[row]
        } else {
            return arrYear[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if ((datePickerView.selectedRow(inComponent: 0) + 1) < (components.month)!) && Int(arrYear[datePickerView.selectedRow(inComponent: 1)])! == components.year {
            
            self.datePickerView.selectRow(components.month! - 1, inComponent: 0, animated: true)
            self.txtExpDate.text! = getExpiryDateFormate(date:"\(arrMonthNumber[datePickerView.selectedRow(inComponent: 0)])/\(arrYear[datePickerView.selectedRow(inComponent: 1)])")
        } else  {
            
            self.txtExpDate.text! = getExpiryDateFormate(date:"\(arrMonthNumber[datePickerView.selectedRow(inComponent: 0)])/\(arrYear[datePickerView.selectedRow(inComponent: 1)])")
        }
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
}

