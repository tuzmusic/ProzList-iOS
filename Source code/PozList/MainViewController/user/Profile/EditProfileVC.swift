//
//  EditProfileVC.swift
//  PozList
//
//  Created by Devubha Manek on 02/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//
class EditCell : UITableViewCell{
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txt_edit: UITextField!
}

class SimpleCell : UITableViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_main: UILabel!
}

import UIKit


class EditProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustomToolBarDelegate {

    var toolBarDone : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: false)
    var toolBar : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: true)
    @IBOutlet weak var txt_name_edit: UITextField!
    @IBOutlet weak var Img_profile: UIImageView!
    @IBOutlet weak var lbl_under_name: UILabel!
    @IBOutlet weak var table_view: UITableView!
    
    @IBOutlet weak var Control_edit_profile: UIControl!
    
    @IBOutlet weak var Cons_width_edit: NSLayoutConstraint!
    
    @IBOutlet weak var btn_save_edit: UIButton!
    
    //Card detail
    @IBOutlet var imgCardType: UIImageView!
    @IBOutlet var btnEditCard: UIButton!
    @IBOutlet var lblCardNumber: UILabel!
    @IBOutlet var lblCardHolderName: UILabel!
    @IBOutlet var lblCardExpiry: UILabel!
    
    var isEditing_profile = false
    var text_head = UITextField()
    var cardData = Card()
    @IBOutlet weak var cons_width_lbl_under_name: NSLayoutConstraint!
    
    @IBOutlet weak var cons_table_height: NSLayoutConstraint!
    var arr_edit = [["main":"Email","image":#imageLiteral(resourceName: "email-1"),"Edit_image":#imageLiteral(resourceName: "email"),"sub":"","Place":"Enter Your Email"],
                    ["main":"City","image":#imageLiteral(resourceName: "locaton"),"Edit_image":#imageLiteral(resourceName: "locaton"),"sub":"","Place":"Enter your city name"],
                    ["main":"Phone Number","image":#imageLiteral(resourceName: "phone_no"),"Edit_image":#imageLiteral(resourceName: "phone"),"sub":"","Place":"Enter Your Phone Number"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.table_view.estimatedRowHeight = 60.0

        table_view.estimatedRowHeight = UITableViewAutomaticDimension
        table_view.rowHeight = UITableViewAutomaticDimension
        let dict = [String : Any]()
        let userId = UserDefaults.Main.string(forKey: .UserID)
        appDelegate.showLoadingIndicator()
        MTWebCall.call.getUserProfile(userId: userId, dictParam: dict) { (respons, status) in
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
                    let city = createString(value: dictData.value(forKey: "city") as AnyObject)
                    let imgProfile = createString(value: dictData.value(forKey: "profile_pic") as AnyObject)
                    
                    let userdate = Profile.init(id: id, username: username, email: email, mobile: mobile, type: type, status: status, city: city,profileImg: imgProfile, avgRating: "")
                    
                    let arrcard = getArrayFromDictionary(dictionary: dictData, key: "card")
                    let dictCard = arrcard.firstObject as! NSDictionary
                    let card_id = createString(value:dictCard.value(forKey: "id") as AnyObject)
                    let card_cvc = createString(value:dictCard.value(forKey: "card_cvc") as AnyObject)
                    let card_date = createString(value:dictCard.value(forKey: "card_date") as AnyObject)
                    let card_holder_name = createString(value:dictCard.value(forKey: "card_holder_name") as AnyObject)
                    let card_number = createString(value:dictCard.value(forKey: "card_number") as AnyObject)
                    let issubscribed = createString(value:dictCard.value(forKey: "issubscribed") as AnyObject)
                    let card_status = createString(value:dictCard.value(forKey: "status") as AnyObject)
                    let user_id = createString(value:dictCard.value(forKey: "user_id") as AnyObject)
                    self.cardData = Card.init(id: card_id, card_cvc: card_cvc, card_date: card_date, card_holder_name: card_holder_name, card_number: card_number, issubscribed: issubscribed, status: card_status, user_id: user_id)
                    
                    
                    UserDefaults.Main.set(true, forKey: .isSignUp)
                    //UserDefaults.Main.set(userdate, forKey: .Profile)
                    UserDefaults.Main.set(id, forKey: .UserID)
                    self.txt_name_edit.text = username.capitalized
                    self.arr_edit = [["main":"Email","image":#imageLiteral(resourceName: "email-1"),"Edit_image":#imageLiteral(resourceName: "email"),"sub":email,"Place":"Enter Your Email"],
                                     ["main":"City","image":#imageLiteral(resourceName: "locaton"),"Edit_image":#imageLiteral(resourceName: "locaton"),"sub":city,"Place":"Enter your city name"],
                                     ["main":"Phone Number","image":#imageLiteral(resourceName: "phone_no"),"Edit_image":#imageLiteral(resourceName: "phone"),"sub":mobile,"Place":"Enter Your Phone Number"]]
                    
                    let str1 =  WebURL.ImageBaseUrl + imgProfile
                    let escapedOwnreImage = str1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    let urlOwnreImage = URL.init(string: escapedOwnreImage!)
                    //SDImageCache.shared().removeImage(forKey: String(describing: urlOwnreImage), fromDisk: true)
                    
                    self.Img_profile.sd_setImage(with: urlOwnreImage, placeholderImage:  UIImage.init(named: "imgUserPlaceholder"), options: SDWebImageOptions.refreshCached, completed: { (image, error, SDImageCacheType, url) in
                        //Hide Loading indicator
                        //self.Img_profile.setShowActivityIndicator(false)
                        if (image != nil) {
                            self.Img_profile.contentMode = .scaleAspectFit
                           // self.Img_profile.image = image
                        }
                    })
                    
                    //str1 = str1.replacingOccurrences(of: " ", with: "%20")
                    //self.Img_profile.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "camera_icon"), options: .refreshCached)
                    
                    //Set Card Details
                    //Card Detail
                    self.lblCardNumber.text  = self.cardData.card_number
                    self.lblCardHolderName.text  = self.cardData.card_holder_name
                    self.lblCardExpiry.text  = self.cardData.card_date
                    self.Changes_UI()
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
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func Changes_UI()  {
       
        if isEditing_profile{
            //For edit profile
            lbl_under_name.isHidden = false
            Control_edit_profile.isUserInteractionEnabled = true
            txt_name_edit.isUserInteractionEnabled = true
            txt_name_edit.font = UIFont.init(name: FontName.RobotoRegular, size: 14.0)
             Cons_width_edit.constant = 120
             cons_width_lbl_under_name.constant = self.txt_name_edit.frame.size.width
            //animation:
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
                self.txt_name_edit.transform = .identity
                self.view.layoutIfNeeded()
            } ) { (completed) in
                self.btn_save_edit.setTitle("SAVE", for: UIControlState.normal)
            }
             self.table_view.separatorStyle = .singleLine
            btn_save_edit.setImage(nil, for:UIControlState.normal)
            let indexes = (0..<arr_edit.count).map { IndexPath(row: $0, section: 0) }
            self.table_view.reloadRows(at: indexes, with: .top)
            self.table_view.layoutIfNeeded()
            self.cons_table_height.constant = self.table_view.contentSize.height
        }else{
             //For save profile
            lbl_under_name.isHidden = true
            Control_edit_profile.isUserInteractionEnabled = false
             txt_name_edit.isUserInteractionEnabled = false
            self.btn_save_edit.setTitle("", for: UIControlState.normal)
            btn_save_edit.setImage(#imageLiteral(resourceName: "edit"), for:UIControlState.normal)
            self.table_view.separatorStyle = .none
            //animation:
             Cons_width_edit.constant = 40
            cons_width_lbl_under_name.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
                self.txt_name_edit.font = UIFont.init(name: FontName.RobotoRegular, size: 16.0)
                self.txt_name_edit.transform = self.txt_name_edit.transform.scaledBy(x: 1.1,y: 1.1) //Change x,y to get your desired effect.
                self.view.layoutIfNeeded()
            } ) { (completed) in
            }
            let indexes = (0..<arr_edit.count).map { IndexPath(row: $0, section: 0) }
            self.table_view.reloadRows(at: indexes, with: .bottom)
            self.table_view.layoutIfNeeded()
            self.cons_table_height.constant = self.table_view.contentSize.height
        }
    }
    
    //MARK: - all click Event
    @IBAction func BackClick(_ sender: Any) {
          self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    @IBAction func Edit_save_click(_ sender: UIButton) {
        
        if isEditing_profile {
            
            var dict = [String : Any]()
            let userId = UserDefaults.Main.string(forKey: .UserID)
            
            for key in arr_edit {
                var strKey = key["main"] as! String
                if let dotRange = strKey.range(of:" ") {
                   strKey.removeSubrange(dotRange.lowerBound..<strKey.endIndex)
                }
                dict[strKey.lowercased()] = key["sub"]
            }
            dict["name"] = txt_name_edit.text
            appDelegate.showLoadingIndicator()
            MTWebCall.call.updateUserProfile(userId: userId, image: Img_profile.image!, dictParam: dict, block: { (respons, status) in
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
                        let city = createString(value: dictData.value(forKey: "city") as AnyObject)
                        let imgProfile = createString(value: dictData.value(forKey: "profile_pic") as AnyObject)
                        let userdate = Profile.init(id: id, username: username, email: email, mobile: mobile, type: type, status: status, city: city, profileImg: imgProfile, avgRating: "")
                        
                        UserDefaults.Main.set(true, forKey: .isSignUp)
                        //UserDefaults.Main.set(userdate, forKey: .Profile)
                        UserDefaults.Main.set(id, forKey: .UserID)
                        self.txt_name_edit.text = username
                        self.arr_edit = [["main":"Email","image":#imageLiteral(resourceName: "email-1"),"Edit_image":#imageLiteral(resourceName: "email"),"sub":email,"Place":"Enter Your Email"],
                                         ["main":"City","image":#imageLiteral(resourceName: "locaton"),"Edit_image":#imageLiteral(resourceName: "locaton"),"sub":city,"Place":"Enter your city name"],
                                         ["main":"Phone Number","image":#imageLiteral(resourceName: "phone_no"),"Edit_image":#imageLiteral(resourceName: "phone"),"sub":mobile,"Place":"Enter Your Phone Number"]]
                        
                        let str1 =  WebURL.ImageBaseUrl + imgProfile
                        let escapedOwnreImage = str1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                        let urlOwnreImage = URL.init(string: escapedOwnreImage!)
                        SDImageCache.shared().removeImage(forKey: String(describing: urlOwnreImage), fromDisk: true)
                        self.Img_profile.sd_setImage(with: urlOwnreImage, placeholderImage:  UIImage.init(named: "imgUserPlaceholder"), options: SDWebImageOptions.refreshCached, completed: { (image, error, SDImageCacheType, url) in
                            //Hide Loading indicator
                           
                            
                            if (image != nil) {
                                self.Img_profile.image = image
                                self.Img_profile.contentMode = UIViewContentMode.scaleAspectFill
                                self.Img_profile.clipsToBounds = true
    
                            }
                        })
                        //str1 = str1.replacingOccurrences(of: " ", with: "%20")
                        //self.Img_profile.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "camera_icon"), options: .refreshCached)
                        self.isEditing_profile = !self.isEditing_profile
                        self.Changes_UI()
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
        else {
            
            self.isEditing_profile = !self.isEditing_profile
            self.Changes_UI()
        }
    }
    
    @IBAction func Edit_profile(_ sender: UIControl) {
        
        let actionSheet = UIAlertController.init(title: "", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let camera = UIAlertAction.init(title: "Camera", style: UIAlertActionStyle.default, handler: {
            (alert: UIAlertAction) -> Void in
            
            let imagePicker = UIImagePickerController.init()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.allowsEditing = true
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
            {
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController.init(title: "Alert", message: "Camera Not Available", preferredStyle: UIAlertControllerStyle.alert)
                let cancel = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.destructive, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                
            }
        })
        
        let photoLibrary = UIAlertAction.init(title: "Photo Library", style: UIAlertActionStyle.default, handler: {
            
            (action: UIAlertAction) -> Void in
            
            let imagePicker = UIImagePickerController.init()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        })
        
        let cancel = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photoLibrary)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnEditCardPressed(_ sender: UIControl) {
        
    }
        
    //MARK: =======================================================
    //MARK: UIImagePicker Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        Img_profile.image = info[UIImagePickerControllerEditedImage] as? UIImage
        Img_profile.clipsToBounds = true
         Img_profile.contentMode = .scaleAspectFit
        _ =  info[UIImagePickerControllerMediaType] as? String
        picker.dismiss(animated: true, completion: {
           
        })
    }
}
extension EditProfileVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_edit.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = arr_edit[indexPath.row]
        if isEditing_profile{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditCell") as! EditCell
            cell.img.image = (dict["Edit_image"] as! UIImage)
            cell.lbl_header.text = (dict["main"] as! String)
            cell.txt_edit.text = dict["sub"] as? String
            cell.txt_edit.tag = indexPath.row + 1
            cell.txt_edit.placeholder = dict["Place"] as? String
            
            if (dict["main"] as! String == "Email") {
                cell.txt_edit.isUserInteractionEnabled = false
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell") as! SimpleCell
            cell.img.image = (dict["image"] as! UIImage)
            cell.lbl_main.text = dict["sub"] as? String
            return cell
        }
    }
}
extension EditProfileVC : UITextFieldDelegate {
    // MARK:- =======================================================
    //MARK: - Textfield Delegate Method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        textField.autocorrectionType = .no
        if textField == txt_name_edit{
            
            toolBarDone.delegate1 = self
            toolBarDone.txtField = textField
           textField.inputAccessoryView = toolBarDone
            
        }else{
            text_head = textField
            if textField.tag == 3 {
                textField.keyboardType = UIKeyboardType.phonePad
            }else{
                textField.keyboardType = UIKeyboardType.default
            }
            
            textField.inputAccessoryView = toolbarInit(textField: textField);
        }
       
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag > 0{
            if arr_edit.count > 0{
                var dict  =  arr_edit[textField.tag - 1]
                dict["sub"]  = textField.text
                arr_edit[textField.tag - 1] = dict
            }
        }
       
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
        self.txt_name_edit.resignFirstResponder()
        text_head.resignFirstResponder()
//        txt_email.resignFirstResponder()
//        txt_phone.resignFirstResponder()
//        txt_password.resignFirstResponder()
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
