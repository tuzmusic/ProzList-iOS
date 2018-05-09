//
//  ServiceProviderProfileVC.swift
//  PozList
//
//  Created by Devubha Manek on 11/20/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import TGPControls
import SkyFloatingLabelTextField
import GooglePlacePicker

class EditCellSP : UITableViewCell{
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txt_edit: SkyFloatingLabelTextField!
}

class SimpleCellSP : UITableViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_main: UILabel!
    @IBOutlet weak var lbl_header: UILabel!
}

class blankCell : UITableViewCell{
    @IBOutlet weak var lbl_header: UILabel!
}

class InsuranceCellSP : UITableViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_main: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
}

class ServiceCellSP : UITableViewCell{
   
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblPrize: UILabel!
    @IBOutlet weak var lbl_serviceName: UILabel!
}

class ServiceCellEdit : UITableViewCell{
    
    @IBOutlet weak var txt_discount: SkyFloatingLabelTextField!
    @IBOutlet weak var control_service: UIControl!
    @IBOutlet weak var control_plus_min: UIControl!
    @IBOutlet weak var lbl_service_name: UILabel!
    @IBOutlet weak var txt_prices: SkyFloatingLabelTextField!
    @IBOutlet weak var img_pls_min: UIImageView!
    
}

class RadiusCellSP : UITableViewCell{
    
    @IBOutlet weak var lblRadius: UILabel!
    @IBOutlet var radiusLeadingSpech: NSLayoutConstraint!
    @IBOutlet var radiusSliderView: UIView!
    @IBOutlet var lblMinValue: UILabel!
    @IBOutlet var lblMaxValue: UILabel!
    @IBOutlet var radiusSlider: TGPDiscreteSlider!
    var radiusValue : Float!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        radiusSlider.addTarget(self, action: #selector(RadiusCellSP.valueChanged(_:event:)), for: .valueChanged)
    }
    
    @objc func valueChanged(_ sender: TGPDiscreteSlider, event:UIEvent) {
        lblMinValue.text = "\(Int(sender.value))"
        radiusValue = Float(sender.value)
    }
}

class AllServiceCellSP : UITableViewCell,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet var mainServiceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var subServiceTblViewHeight: NSLayoutConstraint!
    @IBOutlet var mainServiceView: UIView!
    @IBOutlet var mainServiceHeaderSpech: NSLayoutConstraint!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblMainService: UILabel!
    var isEditing_profile:Bool!
    var serviceproviderObj:ServiceProviderProfileVC!
    @IBOutlet var tblServiceList: UITableView!
    var arr_service = [userService]() //[["Service_name":"Plumbing","price":"$200","discount":"$20","status":"0","Service_id":""]]
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_service.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = arr_service[indexPath.row]
        
        if isEditing_profile{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCellEdit") as! ServiceCellEdit
            let status = dict.status
            cell.control_plus_min.removeTarget(self, action: #selector(ServiceProvicerSignUpVC.insert_row(_:)), for: .touchUpInside)
            cell.control_plus_min.removeTarget(self, action: #selector(ServiceProvicerSignUpVC.delete_row(_:)), for: .touchUpInside)
            
            if status == "Inactive"{
                cell.img_pls_min.image = #imageLiteral(resourceName: "plush-1")
                cell.control_plus_min.addTarget(self, action: #selector(ServiceProvicerSignUpVC.insert_row(_:)), for: .touchUpInside)
            }else{
                cell.img_pls_min.image = #imageLiteral(resourceName: "close-1")
                cell.control_plus_min.addTarget(self, action: #selector(ServiceProvicerSignUpVC.delete_row(_:)), for: .touchUpInside)
            }
            
            cell.lbl_service_name.text = dict.serviceName
            cell.txt_prices.text = dict.prize
            cell.txt_discount.text = dict.discount
            cell.control_plus_min.tag = indexPath.row
           // cell.control_service.tag = indexPath.row
            return cell
        
        } else {
            let cellInsu = tableView.dequeueReusableCell(withIdentifier: "ServiceCellSP") as! ServiceCellSP
            cellInsu.lbl_serviceName.text = dict.serviceName
            cellInsu.lblPrize.text = dict.prize
            cellInsu.lblDiscount.text = dict.discount
            return cellInsu
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @objc func insert_row(_ sender: UIControl){
        
        let section = 0
        let row = sender.tag
        let indexPath = IndexPath(row: row, section: section)
        let cell: ServiceCellEdit = self.tblServiceList.cellForRow(at: indexPath) as! ServiceCellEdit
        let service_name = cell.lbl_service_name.text!
        let dict = arr_service[indexPath.row]
        let service_id = dict.serviceId
        
        let userData = userService.init(serviceId: service_id, prize: cell.txt_prices.text!, discount: cell.txt_discount.text!, serviceName: service_name, status: "Actice")

        arr_service.insert(userData, at: arr_service.count - 1)
        tblServiceList.beginUpdates()
        tblServiceList.insertRows(at: [IndexPath(row: row , section: 0)], with: .automatic)
        tblServiceList.endUpdates()
        //self.tableReload()
        
        serviceproviderObj.table_view.reloadData()
        self.tblServiceList.reloadData()
        self.subServiceTblViewHeight.constant = self.tblServiceList.contentSize.height
        self.layoutIfNeeded()
        
        
//        cell.subServiceTblViewHeight.constant = cell.tblServiceList.contentSize.height
    }
    
    @objc func delete_row(_ sender: UIControl){
        arr_service.remove(at:sender.tag)
        tblServiceList.beginUpdates()
        tblServiceList.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        tblServiceList.endUpdates()
        //self.tableReload()
        self.tblServiceList.reloadData()
    }
}

class ServiceProviderProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imgProfile: UIImageView!
    
    var isEditing_profile = false
    
    var arr_edit = [["main":"Email","image":#imageLiteral(resourceName: "email-1"),"Edit_image":#imageLiteral(resourceName: "email"),"sub":"email","Place":"Email"],
                    ["main":"Phone Number","image":#imageLiteral(resourceName: "phone_no"),"Edit_image":#imageLiteral(resourceName: "phone"),"sub":"phone number","Place":"Phone Number"],
                    ["main":"Address","image":#imageLiteral(resourceName: "locaton"),"Edit_image":#imageLiteral(resourceName: "locaton"),"sub":"","Place":"Address"],
                    ["main":"Country","image":#imageLiteral(resourceName: "enter_state"),"Edit_image":#imageLiteral(resourceName: "enter_state"),"sub":"city","Place":"City"],
                    ["main":"Licence Number","image":#imageLiteral(resourceName: "licence_number"),"Edit_image":#imageLiteral(resourceName: "licence_number-1"),"sub":"licence number","Place":"Licence Number"],
                    ["main":"Licence Type","image":#imageLiteral(resourceName: "pro_licence"),"Edit_image":#imageLiteral(resourceName: "licence_type"),"sub":"licence type","Place":"Licence type"],
                    ["main":"Insurance","image":"","name":""],
                    ["main":"Services","name":"","services":[userService]()],
                    ["main":"Radius","Edit_image":#imageLiteral(resourceName: "licence_type"),"sub":""],
                    ]
    
    @IBOutlet var txtUserName: SkyFloatingLabelTextField!
    @IBOutlet var txtDesignation: UITextField!
    @IBOutlet var btnSaveAndEdit: UIButton!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblDesignation: UILabel!
    @IBOutlet var lblUserStatus: UILabel!
    @IBOutlet var imgProfileImage: UIImageView!
    
    @IBOutlet var table_view: UITableView!
    @IBOutlet var btnSaveAndEditWidthCons: NSLayoutConstraint!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var bottomOfProfileStatus: NSLayoutConstraint!
    
    var selectedPlace: CLLocationCoordinate2D!
    
    let nameMessage = "Your name is required.".localized
    let emailMessage = "Email is required.".localized
    let emailMessage1 =  "Please Enter Valid Email".localized
    let phoneMessage = "Phone number is required.".localized
    let passwordMessage = "Password is required.".localized
    let passwordMessage1 = "Password atleast 8 character".localized
    let address =  "Your address is required.".localized
    let licenceNo =  "Your licence number is required.".localized
    let licenceType =  "Your licence type is required.".localized
    let countryName =  "Your country name is required.".localized
    let stateName =  "Your state name is required.".localized
    let socialNo =  "Your social security number is required.".localized
    let texId =  "Your Tex id is required.".localized
    
    var isOnlyShowProfile:Bool = false
    var serviceProviderId:String = ""
    var strCertificateImg = ""
    
    
    //MARK: - View initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        if isOnlyShowProfile {
            self.btnSaveAndEdit.isHidden = true
        }
        
        self.getUserProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - All Action Events
    @IBAction func ClickBtnSaveOrEdit(_ sender: UIButton) {
        if isEditing_profile {
            if self.validate() {
                self.updateProfile()
            }
        } else {
            self.isEditing_profile = !self.isEditing_profile
            self.Changes_UI()
        }
    }
    
    @IBAction func BackClick(_ sender: Any) {
        if isOnlyShowProfile {
            self.navigationController?.popViewController(animated: true)
        } else{
            self.sideMenuViewController?.presentLeftMenuViewController()
        }
    }
    
    @IBAction func ClickEditProfile(_ sender: Any) {
        
        if isEditing_profile {
            
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
                imagePicker.delegate = self
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
    }
    
    //MARK: =======================================================
    //MARK: UIImagePicker Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgProfileImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        imgProfileImage.clipsToBounds = true
        imgProfileImage.contentMode = .scaleAspectFit
        _ =  info[UIImagePickerControllerMediaType] as? String
        picker.dismiss(animated: true, completion: {
            
        })
    }
}
// MARK: - Google Place Picker Deleget Method
extension ServiceProviderProfileVC:GMSPlacePickerViewControllerDelegate  {
    
    func openPlaceMap() {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        print("Place address \(String(describing: place.formattedAddress))")
        print("Place attributions \(String(describing: place.attributions))")
        print("Place attributions \(String(describing: place.coordinate))")
        
        selectedPlace = place.coordinate
        
        let arrComponet:NSArray = place.addressComponents! as NSArray
        let section = 0
        var row = 2
        var indexPath = IndexPath(row: row, section: section)
        var cell: EditCellSP = self.table_view.cellForRow(at: indexPath) as! EditCellSP
        cell.txt_edit.text = place.name
        
        row = 3
        indexPath = IndexPath(row: row, section: section)
        cell = self.table_view.cellForRow(at: indexPath) as! EditCellSP
        
        for i in 0...arrComponet.count - 1 {
            let comp = arrComponet[i] as! GMSAddressComponent
            print("Place name \(String(describing: comp.name))")
            if comp.type == "country" {
                cell.txt_edit.text = comp.name
            }
        }
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
}
// MARK: - User Define Method
extension ServiceProviderProfileVC {
    
    func getUserProfile() {
        
        let dict = [String : Any]()
        var userId = ""
        if isOnlyShowProfile {
            userId = serviceProviderId
            self.btnSaveAndEdit.isHidden = true
        } else {
            userId = UserDefaults.Main.string(forKey: .UserID)
        }
        
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
                    let sAddress = createString(value: dictData.value(forKey: "address") as AnyObject)
                    let sCountry = createString(value: dictData.value(forKey: "country") as AnyObject)
                    let sState = createString(value: dictData.value(forKey: "state") as AnyObject)
                    let slicenceNo = createString(value: dictData.value(forKey: "licence_number") as AnyObject)
                    let slicenceType = createString(value: dictData.value(forKey: "licence_type") as AnyObject)
                    let ssocialNo = createString(value: dictData.value(forKey: "social_security_number") as AnyObject)
                    let sltexId = createString(value: dictData.value(forKey: "tax_id") as AnyObject)
                    let slatitude = createFloatToString(value: dictData.value(forKey: "latitude") as AnyObject)
                    let slongitude = createFloatToString(value: dictData.value(forKey: "longitude") as AnyObject)
                    let radius = createString(value: dictData.value(forKey: "working_area_radius") as AnyObject)
//                    let avgRating = dictData.getString(key: "avg_rating")
                    let imgProfile = createString(value: dictData.value(forKey: "profile_pic") as AnyObject)
                    
                    //Get Certificate Image
                    let arraOfCertificate = dictData.getArray(key: "certificate_image")
                    if arraOfCertificate.count > 0{
                        let dictCertificate = arraOfCertificate[0] as! NSDictionary
                        self.strCertificateImg = dictCertificate.getString(key: "image")
                    }
                    
                    var arrUserService = [userService]()
                    var strMainService = ""
                    let arrService = getArrayFromDictionary(dictionary: dictData, key: "service_json")
                    if arrService.count > 0 {
                        
                        for i in 0...arrService.count - 1 {
                            
                            let catValue = arrService[i] as! NSDictionary
                            
                            let serviceId = createString(value:catValue.value(forKey: "service_id") as AnyObject)
                            let fPrize = Float(createString (value: catValue.value(forKey: "price") as AnyObject))
                            let fDiscount = Float(createString (value: catValue.value(forKey: "discount") as AnyObject))
                            
                            let prize = "$" + String.init(format: "%.2f", fPrize!)
                            let discount = "$" + String.init(format: "%.2f", fDiscount!)
                            let serviceName =  createString(value: catValue.value(forKey: "name") as AnyObject)
                            let status = createString(value: catValue.value(forKey: "status") as AnyObject)
                            
                            let userServic = userService.init(serviceId: serviceId, prize: prize, discount: discount, serviceName: serviceName, status: status)
                            strMainService = serviceName
                            arrUserService.append(userServic)
                        }
                    }
                    
                    let userdate = ServiceProvider.init(id: id, username: username, email: email, mobile: mobile, type: type, status: status, address: sAddress, city: "", country: sCountry, state: sState, licenceNo: slicenceNo, licenceType: slicenceType, socialNo: ssocialNo, texId: sltexId, latitude: slatitude,longitude: slongitude, workingArea: radius, avgRating:"", profilePic: "", userServices:arrUserService)
                    
                    self.arr_edit = [["main":"Email","image":#imageLiteral(resourceName: "email-1"),"Edit_image":#imageLiteral(resourceName: "email"),"sub":email,"Place":"Email"],
                                    ["main":"Phone Number","image":#imageLiteral(resourceName: "phone_no"),"Edit_image":#imageLiteral(resourceName: "phone"),"sub":mobile,"Place":"Phone Number"],
                                    ["main":"Address","image":#imageLiteral(resourceName: "locaton"),"Edit_image":#imageLiteral(resourceName: "locaton"),"sub":sAddress,"Place":"Address"],
                                    ["main":"Country","image":#imageLiteral(resourceName: "enter_state"),"Edit_image":#imageLiteral(resourceName: "enter_state"),"sub":sCountry,"Place":"City"],
                                    ["main":"Licence Number","image":#imageLiteral(resourceName: "licence_number"),"Edit_image":#imageLiteral(resourceName: "licence_number-1"),"sub":slicenceNo,"Place":"Licence Number"],
                                    ["main":"Licence Type","image":#imageLiteral(resourceName: "pro_licence"),"Edit_image":#imageLiteral(resourceName: "licence_type"),"sub":slicenceType,"Place":"Licence type"],
                                    ["main":"Insurance","image":strMainService,"name":strMainService],
                                    ["main":"Services","name":strMainService,"services":arrUserService],
                                    ["main":"Radius","Edit_image":#imageLiteral(resourceName: "licence_type"),"sub":radius],
                                    ]
                    if slatitude != "" {
                        let lat = CLLocationDegrees(slatitude)
                        let long = CLLocationDegrees(slongitude)
                        self.selectedPlace = CLLocationCoordinate2D.init(latitude: lat!, longitude: long!)
                    }
                    self.lblUserName.text = username
                    self.lblDesignation.text = strMainService
                    if status == "Active" {
                        self.lblUserStatus.text = "Profile Status: Approved"
                    } else {
                        self.lblUserStatus.text = "Profile Status:Panding"
                    }
                    let str1 =  WebURL.ImageBaseUrl + imgProfile
                    let escapedOwnreImage = str1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    let urlOwnreImage = URL.init(string: escapedOwnreImage!)
                    SDImageCache.shared().removeImage(forKey: String(describing: urlOwnreImage), fromDisk: true)
                    self.imgProfileImage.sd_setImage(with: urlOwnreImage, placeholderImage:  UIImage.init(named: "imgUserPlaceholder"), options: SDWebImageOptions.refreshCached, completed: { (image, error, SDImageCacheType, url) in
                        
                        if (image != nil) {
                            self.imgProfileImage.contentMode = .scaleAspectFit
                            self.imgProfileImage.image = image
                        }
                    })
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
    }
    
    func updateProfile() {
        
        var dict = [String : Any]()
        for key in arr_edit {
            var strKey = key["main"] as! String
//            if let dotRange = strKey.range(of:" ") {
//                strKey.removeSubrange(dotRange.lowerBound..<strKey.endIndex)
//            }
            if strKey == "Radius" {
                let section = 0
                let row = arr_edit.count - 1
                let indexPath = IndexPath(row: row, section: section)
                let cell: RadiusCellSP = self.table_view.cellForRow(at: indexPath) as! RadiusCellSP
                dict["working_area_radius"] = cell.lblMinValue.text
            } else if strKey == "Licence Number" {
                dict["licence_number"] = key["sub"]
            } else if strKey == "Licence Type" {
                dict["licence_type"] = key["sub"]
            } else if strKey == "Phone Number" {
                dict["phone"] = key["sub"]
            } else {
                dict[strKey.lowercased()] = key["sub"]
            }
        }
        
        let section = 0
        let row = arr_edit.count - 2
        let indexPath = IndexPath(row: row, section: section)
        let cell: AllServiceCellSP = self.table_view.cellForRow(at: indexPath) as! AllServiceCellSP
        cell.serviceproviderObj = self
        if cell.arr_service.count > 1 {
            var arrSec = [[String:String]]()
            for i in 0...cell.arr_service.count - 1 {
                let dict = cell.arr_service[i]
                var dictValue = [String:String]()
                dictValue["service_id"] = dict.serviceId
                dictValue["price"] = dict.prize
                dictValue["discount"] = dict.discount
                arrSec.append(dictValue)
            }
            arrSec.removeLast()
            if let objectData = try? JSONSerialization.data(withJSONObject: arrSec, options: JSONSerialization.WritingOptions(rawValue: 0)) {
                let objectString = String(data: objectData, encoding: .utf8)
                dict["service_json"] = objectString
            }
        }
        dict["latitude"] = String(selectedPlace.latitude)
        dict["longitude"] = String(selectedPlace.longitude)
        dict["name"] = lblUserName.text
        dict["designation"] = lblDesignation.text
        dict["role"] = UserType.ServiceProvider.rawValue
        
        let userId = UserDefaults.Main.string(forKey: .UserID)
        appDelegate.showLoadingIndicator()
        MTWebCall.call.updateUserProfile(userId: userId, image: imgProfileImage.image!, dictParam: dict) { (respons, status) in
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
                    let sAddress = createString(value: dictData.value(forKey: "address") as AnyObject)
                    let sCountry = createString(value: dictData.value(forKey: "country") as AnyObject)
                    let sState = createString(value: dictData.value(forKey: "state") as AnyObject)
                    let slicenceNo = createString(value: dictData.value(forKey: "licence_number") as AnyObject)
                    let slicenceType = createString(value: dictData.value(forKey: "licence_type") as AnyObject)
                    let ssocialNo = createString(value: dictData.value(forKey: "social_security_number") as AnyObject)
                    let sltexId = createString(value: dictData.value(forKey: "tax_id") as AnyObject)
                    let slatitude = createString(value: dictData.value(forKey: "latitude") as AnyObject)
                    let slongitude = createString(value: dictData.value(forKey: "longitude") as AnyObject)
                    let radius = createString(value: dictData.value(forKey: "working_area_radius") as AnyObject)
                    let imgProfile = createString(value: dictData.value(forKey: "profile_pic") as AnyObject)
                    
                    var arrUserService = [userService]()
                    var strMainService = ""
                    let arrService = getArrayFromDictionary(dictionary: dictData, key: "service_json")
                    if arrService.count > 0 {
                        
                        for i in 0...arrService.count - 1 {
                            
                            let catValue = arrService[i] as! NSDictionary
                            
                            let serviceId = createString(value:catValue.value(forKey: "service_id") as AnyObject)
                            let fPrize = Float(createString (value: catValue.value(forKey: "price") as AnyObject))
                            let fDiscount = Float(createString (value: catValue.value(forKey: "discount") as AnyObject))
                            
                            let prize = String.init(format: "%.2f", fPrize!)
                            let discount = String.init(format: "%.2f", fDiscount!)
                            let serviceName = createString(value: catValue.value(forKey: "name") as AnyObject)
                            let status = createString(value: catValue.value(forKey: "status") as AnyObject)
                            
                            let userServic = userService.init(serviceId: serviceId, prize: prize, discount: discount, serviceName: serviceName, status: status)
                            strMainService = serviceName
                            arrUserService.append(userServic)
                        }
                    }
                    
                    let userdate = ServiceProvider.init(id: id, username: username, email: email, mobile: mobile, type: type, status: status, address: sAddress, city: "", country: sCountry, state: sState, licenceNo: slicenceNo, licenceType: slicenceType, socialNo: ssocialNo, texId: sltexId, latitude: slatitude,longitude: slongitude, workingArea:radius, avgRating:"", profilePic: "", userServices:arrUserService)
                    
                    self.arr_edit = [["main":"Email","image":#imageLiteral(resourceName: "email-1"),"Edit_image":#imageLiteral(resourceName: "email"),"sub":email,"Place":"Enter Your Email"],
                                     ["main":"Phone Number","image":#imageLiteral(resourceName: "phone_no"),"Edit_image":#imageLiteral(resourceName: "phone"),"sub":mobile,"Place":"Enter Your Phone Number"],
                                     ["main":"Address","image":#imageLiteral(resourceName: "locaton"),"Edit_image":#imageLiteral(resourceName: "locaton"),"sub":sAddress,"Place":"Enter your address name"],
                                     ["main":"Country","image":#imageLiteral(resourceName: "enter_state"),"Edit_image":#imageLiteral(resourceName: "enter_state"),"sub":sCountry,"Place":"Enter your city name"],
                                     ["main":"Licence Number","image":#imageLiteral(resourceName: "licence_number"),"Edit_image":#imageLiteral(resourceName: "licence_number-1"),"sub":slicenceNo,"Place":"Enter your licence Number"],
                                     ["main":"Licence Type","image":#imageLiteral(resourceName: "pro_licence"),"Edit_image":#imageLiteral(resourceName: "licence_type"),"sub":slicenceType,"Place":"Enter your licence type"],
                                     ["main":"Insurance","image":strMainService,"name":strMainService],
                                     ["main":"Services","name":strMainService,"services":arrUserService],
                                     ["main":"Radius","Edit_image":#imageLiteral(resourceName: "licence_type"),"sub":radius],
                                    ]
                    
                    let lat = CLLocationDegrees(slatitude)
                    let long = CLLocationDegrees(slongitude)
                    self.selectedPlace = CLLocationCoordinate2D.init(latitude: lat!, longitude: long!)
                    self.lblUserName.text = username
                    self.lblDesignation.text = strMainService
                    if status == "Active" {
                        self.lblUserStatus.text = "Profile Status: Approved"
                    } else {
                        self.lblUserStatus.text = "Profile Status:Panding"
                    }
                    
                    let str1 =  WebURL.ImageBaseUrl + imgProfile
                    let escapedOwnreImage = str1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    let urlOwnreImage = URL.init(string: escapedOwnreImage!)
                    SDImageCache.shared().removeImage(forKey: String(describing: urlOwnreImage), fromDisk: true)
                    self.imgProfileImage.sd_setImage(with: urlOwnreImage, placeholderImage: #imageLiteral(resourceName: "imgUserPlaceholder"), options: SDWebImageOptions.refreshCached, completed: { (image, error, SDImageCacheType, url) in
                        
                        if (image != nil) {
                            self.imgProfileImage.contentMode = .scaleAspectFit
                            self.imgProfileImage.image = image
                            
                        }
                    })
                    
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
        }
    }
    
    func Changes_UI()  {
        if isEditing_profile {
            //For edit profile
            lblUserName.isHidden = true
            lblDesignation.isHidden = true
            lblUserStatus.isHidden = true
            txtUserName.isHidden = false
          //  Control_edit_profile.isUserInteractionEnabled = true
            txtUserName.text = lblUserName.text
            txtUserName.isUserInteractionEnabled = true
            txtUserName.textAlignment = .center
            txtUserName.font = UIFont.init(name: FontName.RobotoRegular, size: 14.0)
            btnSaveAndEditWidthCons.constant = 120
            bottomOfProfileStatus.constant = 0
            //animation:
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
                self.txtUserName.transform = .identity
                
                self.view.layoutIfNeeded()
            } ) { (completed) in
                self.btnSaveAndEdit.setTitle("SAVE", for: UIControlState.normal)
            }
            self.table_view.separatorStyle = .singleLine
            self.btnSaveAndEdit.setImage(nil, for:UIControlState.normal)
            let indexes = (0..<arr_edit.count).map { IndexPath(row: $0, section: 0) }
            self.table_view.reloadRows(at: indexes, with: .top)
            self.table_view.layoutIfNeeded()
            self.tableViewHeight.constant = 650
            
        }else{
            //For save profile
            lblUserName.isHidden = false
            lblDesignation.isHidden = false
            lblUserStatus.isHidden = false
           // Control_edit_profile.isUserInteractionEnabled = false
            txtUserName.isUserInteractionEnabled = false
            txtUserName.isHidden = true
            self.btnSaveAndEdit.setTitle("", for: UIControlState.normal)
            btnSaveAndEdit.setImage(#imageLiteral(resourceName: "edit"), for:UIControlState.normal)
            
            btnSaveAndEditWidthCons.constant = 40
            //cons_width_lbl_under_name.constant = 0
            //animation:
            bottomOfProfileStatus.constant = 25
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
                self.txtUserName.font = UIFont.init(name: FontName.RobotoRegular, size: 16.0)
                self.txtUserName.transform = self.txtUserName.transform.scaledBy(x: 1.1,y: 1.1) //Change x,y to get your desired effect.
                
                self.view.layoutIfNeeded()
            } ) { (completed) in
            }
            self.table_view.separatorStyle = .none
            let indexes = (0..<arr_edit.count).map { IndexPath(row: $0, section: 0) }
            self.table_view.reloadRows(at: indexes, with: .bottom)
            self.table_view.layoutIfNeeded()
            self.tableViewHeight.constant = 735
        }
    }
    
    
    func validate() -> Bool {
        
        guard (txtUserName.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txtUserName
            {
                floatingLabelTextField.errorMessage = nameMessage
            }
            return false
        }
        
        for i in 0...arr_edit.count - 1 {
         
            let section = 0
            let row = i
            
            if row != 6 {
                
                let indexPath = IndexPath(row: row, section: section)
                let cell: EditCellSP = self.table_view.cellForRow(at: indexPath) as! EditCellSP
                
                guard (cell.txt_edit.text?.characters.count)! > 0 else
                {
                    if let floatingLabelTextField = cell.txt_edit
                    {
                        if floatingLabelTextField.tag == 1 {
                            floatingLabelTextField.errorMessage = nameMessage
                        } else if floatingLabelTextField.tag == 2 {
                            floatingLabelTextField.errorMessage = phoneMessage
                        } else if floatingLabelTextField.tag == 3 {
                            floatingLabelTextField.errorMessage = address
                        } else if floatingLabelTextField.tag == 4 {
                            floatingLabelTextField.errorMessage = countryName
                        } else if floatingLabelTextField.tag == 5 {
                            floatingLabelTextField.errorMessage = licenceNo
                        } else if floatingLabelTextField.tag == 6 {
                            floatingLabelTextField.errorMessage = licenceType
                        }
                    }
                    return false
                }
            } else {
                break;
            }
        }
        
        return true
    }
}
// MARK: - Text field deleget
extension ServiceProviderProfileVC : UITextFieldDelegate {
    
    
    // MARK:- =======================================================
    //MARK: - Textfield Delegate Method
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField.tag == 3 {
            self.openPlaceMap()
            return false
        }
        else {
//            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField
//            {
//                floatingLabelTextField.errorMessage = ""
//            }
//            textField.inputAccessoryView = toolbarInit(textField: textField);
            return true
        }
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
}

// MARK: - Table view
extension ServiceProviderProfileVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_edit.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = arr_edit[indexPath.row]
            let value = dict["main"] as! String
            if isEditing_profile{
                
                var cell:EditCellSP!
                if value == "Radius" {
                    let cellInsu = tableView.dequeueReusableCell(withIdentifier: "RadiusCellSP") as! RadiusCellSP
                    let radius = dict["sub"] as? String
                    cellInsu.radiusSliderView.isHidden = false
                    cellInsu.radiusLeadingSpech.constant = 8
                    cellInsu.radiusValue = Float(radius!)
                    if let n = NumberFormatter().number(from: radius!) {
                        let f = CGFloat(truncating: n)
                        cellInsu.radiusSlider.value = f
                    }
                    
                    cellInsu.lblMinValue.text = radius
                    return cellInsu
                    
                } else if value == "Services" {
                    let cellInsu = tableView.dequeueReusableCell(withIdentifier: "AllServiceCellSP") as! AllServiceCellSP
                    cellInsu.serviceproviderObj = self
                    cellInsu.mainServiceHeaderSpech.constant = 8
                    cellInsu.mainServiceView.isHidden = true
                    cellInsu.mainServiceViewHeight.constant = 0
                    cellInsu.mainServiceView.clipsToBounds = true
                    cellInsu.arr_service = dict["services"] as! [userService]
                    cellInsu.isEditing_profile = isEditing_profile
                    let dict = cellInsu.arr_service[0]
                    let serviceId = dict.serviceId
                    let serviceName = dict.serviceName
                    let userData = userService.init(serviceId: serviceId, prize: "", discount: "", serviceName: serviceName, status: "Inactive")
                    cellInsu.arr_service.insert(userData, at: cellInsu.arr_service.count)
                    cellInsu.lblMainService.text = serviceName
                    let imgName = serviceName
                    cellInsu.img.image = UIImage.init(named: imgName.lowercased() + "-1")
                    cellInsu.tblServiceList.reloadData()
                    cellInsu.subServiceTblViewHeight.constant = cellInsu.tblServiceList.contentSize.height + 44
                    
                    return cellInsu
                } else if value == "Insurance" {
                    let cellInsu  = tableView.dequeueReusableCell(withIdentifier: "blankCell") as! blankCell
                     cellInsu.lbl_header.text = ""
                    return cellInsu
                } else if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: "EditCellHeader") as! EditCellSP
                    cell.lbl_header.text = "CONTECT DETAIL"
                } else if indexPath.row == 4 {
                    cell = tableView.dequeueReusableCell(withIdentifier: "EditCellHeader") as! EditCellSP
                    cell.lbl_header.text = "LICENCE NUMBER AND TYPE"
                } else {
                    cell = tableView.dequeueReusableCell(withIdentifier: "EditCellSP") as! EditCellSP
                }
                
                cell.img.image = (dict["Edit_image"] as! UIImage)
                //cell.lbl_title.text = (dict["main"] as! String)
                cell.txt_edit.text = dict["sub"] as? String
                cell.txt_edit.tag = indexPath.row + 1
                cell.txt_edit.placeholder = dict["Place"] as? String
                
                if (dict["main"] as! String == "Email") {
                    cell.txt_edit.isUserInteractionEnabled = false
                }
                if (dict["main"] as! String == "Phone Number") {
                    cell.txt_edit.keyboardType = .phonePad
                }
                
                return cell
            }else{
                var cell:SimpleCellSP!
                
                if value == "Radius" {
                    let cellInsu = tableView.dequeueReusableCell(withIdentifier: "RadiusCellSP") as! RadiusCellSP
                    let radius = dict["sub"] as? String
                    cellInsu.lblRadius.text = radius! + "miles"
                    cellInsu.radiusSliderView.isHidden = true
                    cellInsu.radiusLeadingSpech.constant = 43
                    return cellInsu
                    
                } else if value == "Services" {
                    
                    let cellInsu = tableView.dequeueReusableCell(withIdentifier: "AllServiceCellSP") as! AllServiceCellSP
                    cellInsu.serviceproviderObj = self
                    cellInsu.isEditing_profile = isEditing_profile
                    cellInsu.arr_service.removeAll()
                    cellInsu.arr_service = dict["services"] as! [userService]
                    cellInsu.lblMainService.text = dict["name"] as? String
                    let imgName = dict["name"] as? String
                    cellInsu.img.image = UIImage.init(named: imgName!.lowercased() + "-1")
                    cellInsu.mainServiceView.isHidden = false
                    cellInsu.mainServiceViewHeight.constant = 50
                    cellInsu.mainServiceView.clipsToBounds = false
                    cellInsu.mainServiceHeaderSpech.constant = 43
                    cellInsu.tblServiceList.reloadData()
                    cellInsu.subServiceTblViewHeight.constant = cellInsu.tblServiceList.contentSize.height + 44
                    return cellInsu
                    
                } else if value == "Insurance" {
                    let cellInsu = tableView.dequeueReusableCell(withIdentifier: "InsuranceCellSP") as! InsuranceCellSP
                    let strName = dict["name"] as! String
                    cellInsu.lbl_main.text = strName + " Insurance"
                    cellInsu.lbl_status.text = "Active"
                    cellInsu.img.layer.cornerRadius = cellInsu.img.frame.size.height / 2
                    cellInsu.img.sd_setImage(with: URL.init(string: WebURL.ImageBaseUrl + strCertificateImg), placeholderImage: UIImage.init(named: "camera_icon"), options: .retryFailed)
                    return cellInsu
                    
                } else if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCellHeader") as! SimpleCellSP
                    cell.lbl_header.text = "CONTECT DETAIL"
                } else if indexPath.row == 4 {
                    cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCellHeader") as! SimpleCellSP
                    cell.lbl_header.text = "LICENCE NUMBER AND TYPE"
                } else {
                    cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCellSP") as! SimpleCellSP
                }
                
                cell.img.image = (dict["image"] as! UIImage)
                cell.lbl_main.text = dict["sub"] as? String
                return cell
                
            }
    }
}
