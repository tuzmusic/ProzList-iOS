//
//  ServiceProvicerSignUpVC.swift
//  PozList
//
//  Created by Devubha Manek on 11/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import TGPControls
import SkyFloatingLabelTextField
import GooglePlacePicker

class serviceCell:UITableViewCell{
    
    @IBOutlet weak var txt_discount: SkyFloatingLabelTextField!
    
    @IBOutlet weak var control_service: UIControl!
    @IBOutlet weak var control_plus_min: UIControl!
    @IBOutlet weak var lbl_service_name: UILabel!
    @IBOutlet weak var txt_prices: SkyFloatingLabelTextField!
    @IBOutlet weak var img_pls_min: UIImageView!
    let serviceId:String! = nil
}

class ServiceProvicerSignUpVC: UIViewController,CustomToolBarDelegate   {
    
    var toolBar : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: true)

    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var ViewSecond: UIView!
    @IBOutlet weak var ViewFirst: UIView!
   
    //slider
    @IBOutlet weak var lbl_slider_min: UILabel!
    @IBOutlet weak var lbl_slider_max: UILabel!
    @IBOutlet weak var dualColorSlider: TGPDiscreteSlider!
    @IBOutlet weak var lbl_show_miles_area: UILabel!
    
    
    @IBOutlet weak var cons_height_tbl: NSLayoutConstraint!
    //tableView
    @IBOutlet weak var table_view: UITableView!
    
   //all taxtfield
    
    @IBOutlet weak var txt_name: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txt_email: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_phone: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_password: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txt_address: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_licence_type: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_lincence_no: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_country: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_state: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_social: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_tax_id: SkyFloatingLabelTextField!
    
    let nameMessage = "Your name is required.".localized
    let emailMessage = "Email is required.".localized
    let emailMessage1 =  "Please Enter Valid Email".localized
    let phoneMessage = "Please Enter Valid Phone number.".localized
    let passwordMessage = "Password is required.".localized
    let passwordMessage1 = "Password atleast 8 character".localized
    let address =  "Your address is required.".localized
    let licenceNo =  "Your licence number is required.".localized
    let licenceType =  "Your licence type is required.".localized
    let countryName =  "Your country name is required.".localized
    let stateName =  "Your state name is required.".localized
    let socialNo =  "Your social security number is required.".localized
    let texId =  "Your Tex id is required.".localized
    
    var dropDownList:DropDown = DropDown()
    
    var selectedPlace: CLLocationCoordinate2D!
    
    var Y_first = CGFloat()
    var Y_sec = CGFloat()
    
    var arrDropList = [String]()  //["Plumbing","electronic","reparing","free services"]
    var arr_service = [["Service_name":"","price":"","discount":"","status":"0","Service_id":""]]
    var arrListOfService = [Service]()
    var serviceName:String! = ""
    
    var radius:Double!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.previous(UIControl())
        dualColorSlider.addTarget(self, action: #selector(ServiceProvicerSignUpVC.valueChanged(_:event:)), for: .valueChanged)
        setupAllTextFiels()
        self.tableReload()
        radius = 0.0;
        self.getServiceList()
    }
    
    func tableReload(){
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            DispatchQueue.main.async {
               self.cons_height_tbl.constant = self.table_view.contentSize.height
                self.Y_first = self.ViewFirst.frame.origin.y
                self.Y_sec = self.ViewSecond.frame.origin.y
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setupAllTextFiels(){
        txt_name.text = ""
        txt_email.text = ""
        txt_phone.text = ""
        txt_password.text = ""
        txt_address.text = ""
        txt_licence_type.text = ""
        txt_lincence_no.text = ""
        txt_country.text = ""
        txt_state.text = ""
        txt_social.text = ""
        txt_tax_id.text = ""
        self.txt_password.isSecureTextEntry = true
        
        self.txt_name.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_name.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
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
        
        self.txt_address.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_address.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txt_address.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
        self.txt_licence_type.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_licence_type.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txt_licence_type.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
        
        self.txt_lincence_no.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_lincence_no.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txt_lincence_no.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
        
        self.txt_country.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_country.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txt_country.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
        
        self.txt_state.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_state.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txt_state.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
        
        self.txt_social.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_social.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txt_social.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
        self.txt_tax_id.titleLabel.font =  UIFont.init(name: FontName.RobotoRegular, size: 12)
        self.txt_tax_id.placeholderFont =  UIFont.init(name: FontName.RobotoLight, size: 16)
        self.txt_tax_id.font =  UIFont.init(name: FontName.RobotoLight, size: 16)
        
    }
    
    @objc func valueChanged(_ sender: TGPDiscreteSlider, event:UIEvent) {
        lbl_show_miles_area.text = "Set working area radius (Miles)"
        lbl_slider_max.text = "\(sender.value)"
        radius = Double(sender.value)
    }
    
    @objc func insert_row(_ sender: UIControl){
        
        let section = 0
        let row = sender.tag
        let indexPath = IndexPath(row: row, section: section)
        let cell: serviceCell = self.table_view.cellForRow(at: indexPath) as! serviceCell
        cell.lbl_service_name!.text = self.serviceName
        let service_name = cell.lbl_service_name.text!
       
       
        var service_id = ""
        for i in 0...arrListOfService.count - 1 {
            let ser = arrListOfService[i]
            if (service_name == ser.servicename) {
                service_id = ser.id
            }
        }
        if cell.txt_prices.text! == "" {
            
        }else {
//            if arr_service.count == 1 {
//                arr_service.insert(["Service_name":service_name,"price":"$\(cell.txt_prices.text!)","discount":"$\(cell.txt_discount.text!)","status":"1","service_id":service_id], at: 0)
//
//
//            }else {
                arr_service.insert(["Service_name":service_name,"price":"$\(cell.txt_prices.text!)","discount":"$\(cell.txt_discount.text!)","status":"1","service_id":service_id], at: arr_service.count - 1)
                if arr_service.count > 1 {
                    dropDownList.hide()
                }
//            }
            cell.txt_prices.text = ""
            cell.txt_discount.text = ""
//            table_view.beginUpdates()
//            table_view.insertRows(at: [IndexPath(row: row , section: 0)], with: .automatic)
//            table_view.endUpdates()
//
            self.table_view.reloadData()
            self.tableReload()
        }
        
    }
    
    @objc func delete_row(_ sender: UIControl){
        arr_service.remove(at:sender.tag)
//        table_view.beginUpdates()
//        table_view.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
//        table_view.endUpdates()
        self.table_view.reloadData()
        self.tableReload()
    }
    
    @IBAction func tapToDropDown(_ sender: UIControl) {
        
        if arr_service.count == 1 {
            
            self.setupDropDownList(control: sender, arr: arrDropList)
            dropDownList.show()
            dropDownList.tag = sender.tag
            
        }else {
            self.setupDropDownList(control: sender, arr: arrDropList)
            dropDownList.hide()
            dropDownList.tag = sender.tag
        }
       
        
    }
    
    //"[{\"status\":\"1\",\"Service_name\":\"Plumbing\",\"price\":\"$100.0\",\"discount\":\"$10.0\"},{\"status\":\"0\",\"Service_name\":\"\",\"price\":\"\",\"discount\":\"\"}]"
    
    func setupDropDownList(control:UIControl, arr:[String]) {
        
        let appearance = DropDown.appearance()
        appearance.cellHeight = 25
        appearance.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        appearance.selectionBackgroundColor = UIColor.lightGray
        //appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.corner_Radius = 2
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 15
        appearance.animationduration = 0.25
        appearance.textColor = UIColor.init(red: 157/255.0, green: 152/255.0, blue: 166/255.0, alpha: 1.0)
       // appearance.textFont = UIFont.init(name: FontName.RobotoRegular, size: 11)!
        
        appearance.border_color = UIColor.init(red: 232/255.0, green: 231/255.0, blue: 234/255.0, alpha: 1.0)
        appearance.border_width = 1.0
        
        dropDownList.anchorView = control
        dropDownList.bottomOffset = CGPoint(x: 0, y: control.bounds.height)
        dropDownList.dataSource = arr
        
        // Action triggered on selection
        
        dropDownList.selectionAction = { [unowned self] (index, item) in
            print("Selected : \(item) at index \(index)")
            let section = 0
            let row = self.dropDownList.tag
            let indexPath = IndexPath(row: row, section: section)
            let cell: serviceCell = self.table_view.cellForRow(at: indexPath) as! serviceCell
            self.serviceName = item
            cell.lbl_service_name.text = self.serviceName
            
        }
    }
    
    @IBAction func Next(_ sender: UIControl) {
        
        guard validateData1() else { return }
        
        self.ViewSecond.transform = CGAffineTransform.identity
        self.ViewSecond.frame.origin.y =  Y_sec
        let v4x = self.ViewFirst.frame.origin.x
        UIView.animate(withDuration: 0.3, animations: {
            self.ViewFirst.frame.origin.x = self.ViewFirst.frame.width
            self.ViewSecond.alpha = 0.8
        }) { (_) in
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.MainView.bringSubview(toFront: self.ViewSecond)
                self.ViewFirst.frame.origin.x = v4x
                self.ViewSecond.alpha = 1.0
                self.ViewFirst.transform = CGAffineTransform.init(scaleX:  1.0, y:  1.0)
                self.MainView.sendSubview(toBack: self.ViewFirst)
            }, completion: { (true) in
                 self.ViewFirst.frame.origin.y =   self.ViewFirst.frame.origin.y - 5
                  self.ViewFirst.transform = CGAffineTransform.init(scaleX:  0.9, y: 1.0)
                  self.ViewFirst.alpha = 0.5
            })
        }
    }
    
    @IBAction func previous(_ sender: UIControl) {
         self.ViewFirst.transform = CGAffineTransform.identity
          self.ViewFirst.frame.origin.y =   Y_first
         let v4x = self.ViewFirst.frame.origin.x
        UIView.animate(withDuration: 0.3, animations: {
            self.ViewSecond.frame.origin.x = -self.ViewSecond.frame.width
            self.ViewFirst.alpha = 0.8
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                
                self.MainView.bringSubview(toFront: self.ViewFirst)
                 self.ViewSecond.frame.origin.x = v4x
                 self.ViewFirst.alpha = 1.0
                self.ViewSecond.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                self.MainView.sendSubview(toBack: self.ViewSecond)
                
            }, completion: { (true) in
                
                self.ViewSecond.frame.origin.y =   self.ViewSecond.frame.origin.y - 5
                self.ViewSecond.transform = CGAffineTransform.init(scaleX:  0.9, y: 1.0)
                self.ViewSecond.alpha = 0.5
            })
        }
    }
    
    @IBAction func Click_Register(_ sender: UIControl) {
        
        guard validateData2() else { return }
        
        //let selected_service = storyBoards.Menu.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
        //self.navigationController?.pushViewController(selected_service, animated: true)
        
      //  let vc = storyBoards.Main.instantiateViewController(withIdentifier: "UploadCertificateVC") as! UploadCertificateVC
      //  self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- =======================================================
    //MARK: - Web service call
    
    func registerApiCall() {
        
        var peraDic = [String:Any]()
        peraDic["name"] = self.txt_name.text!
        peraDic["email"] = self.txt_email.text!
        peraDic["phone"] = self.txt_phone.text!
        peraDic["password"] = self.txt_password.text!
        peraDic["address"] = self.txt_address.text!
        peraDic["licence_number"] = self.txt_lincence_no.text!
        peraDic["licence_type"] = self.txt_licence_type.text!
        peraDic["country"] = self.txt_country.text!
        peraDic["state"] = self.txt_state.text!
        peraDic["social_security_number"] = self.txt_social.text!
        peraDic["tax_id"] = self.txt_tax_id.text!
        peraDic["role"] = UserType.ServiceProvider.rawValue
        peraDic["latitude"] = String(selectedPlace.latitude)
        peraDic["longitude"] = String(selectedPlace.longitude)
        
        peraDic["working_area_radius"] = String(Int(radius))
        if arr_service.count >= 1 {
            var arrSec = [[String:String]]()
            for i in 0...arr_service.count - 1 {
                let dict = arr_service[i]
                var dictValue = [String:String]()
                
                guard dict["service_id"] != "" || dict["price"] != "" || dict["discount"] != "" else {
                
                    appDelegate.Popup(Message: "Your service details is required.")
                    return
                }
                
                dictValue["service_id"] = dict["service_id"]
                dictValue["price"] = dict["price"]
                dictValue["discount"] = dict["discount"]
                arrSec.append(dictValue)
            }
            arrSec.removeLast()
            if let objectData = try? JSONSerialization.data(withJSONObject: arrSec, options: JSONSerialization.WritingOptions(rawValue: 0)) {
                let objectString = String(data: objectData, encoding: .utf8)
                peraDic["service_json"] = objectString
            }
        }
        
        appDelegate.showLoadingIndicator()
        MTWebCall.call.registerUser(dictParam: peraDic) { (respons, status) in
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
                    let mobile = createString(value: dictData.value(forKey: "mobile") as AnyObject)
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
                    let sWorkingArea = createString(value: dictData.value(forKey: "working_area_radius") as AnyObject)
                    
                    //Default Duty is on
                    UserDefaults.Main.set(true, forKey: .isDutyOnOff)
                    UserDefaults.standard.synchronize()
                    
                    var arrUserService = [userService]()
                    
                    let arrService = getArrayFromDictionary(dictionary: dictData, key: "service_json")
                    if arrService.count > 0 {
                        
                        for i in 0...arrService.count - 1 {
                            
                            let catValue = arrService[i] as! NSDictionary
                            
                            let serviceId = createString(value:catValue.value(forKey: "service_id") as AnyObject)
                            let prize = createString(value: catValue.value(forKey: "price") as AnyObject)
                            let discount = createString(value: catValue.value(forKey: "discount") as AnyObject)
                            let serviceName = "" //createString(value: catValue.value(forKey: "name") as AnyObject)
                            let status = "" //createString(value: catValue.value(forKey: "status") as AnyObject)
                            
                            let userServic = userService.init(serviceId: serviceId, prize: prize, discount: discount, serviceName: serviceName, status: status)
                            
                            arrUserService.append(userServic)
                        }
                    }
                    let userdate = ServiceProvider.init(id: id, username: username, email: email, mobile: mobile, type: type, status: status, address: sAddress, city: "", country: sCountry, state: sState, licenceNo: slicenceNo, licenceType: slicenceType, socialNo: ssocialNo, texId: sltexId, latitude: slatitude,longitude: slongitude, workingArea: sWorkingArea, avgRating:"", profilePic: "", userServices:arrUserService)
                    
                    UserDefaults.Main.set(true, forKey: .isLogin)
                    UserDefaults.Main.set(id, forKey: .UserID)
                    
                    let usertype = UserType.ServiceProvider
                    UserDefaults.Main.set(usertype.rawValue, forKey: .Appuser)
                    
                    let vc = storyBoards.Main.instantiateViewController(withIdentifier: "UploadCertificateVC") as! UploadCertificateVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
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
    
    func getServiceList() {
        
        let dic = [String:Any]()
        appDelegate.showLoadingIndicator()
        MTWebCall.call.getServiceCat(dictParam: dic) { (respons, status) in
            appDelegate.hideLoadingIndicator()
            if (status == 200 && respons != nil) {
                //Response
                let dictResponse = respons as! NSDictionary
                
                let Response = getStringFromDictionary(dictionary: dictResponse, key: "response")
                if Response == "true"
                {
                    let message = getStringFromDictionary(dictionary: dictResponse, key: "msg")
                    print(message)
                    let arrCat = getArrayFromDictionary(dictionary: dictResponse, key: "data")
                    
                    for i in 0...arrCat.count - 1 {
                        let catValue = arrCat[i] as! NSDictionary
                        
                        let id = createString(value:catValue.value(forKey: "id") as AnyObject)
                        let sName = createString(value:catValue.value(forKey: "name") as AnyObject)
                        let status = createString(value:catValue.value(forKey: "status") as AnyObject)
                        let imgPath = createString(value:catValue.value(forKey: "image") as AnyObject)
                        let service = Service.init(id: id, servicename: sName, status: status, imagepath: imgPath)
                        
                        self.arrListOfService.append(service)
                        print("data service \(catValue)")
                        self.arrDropList.append(sName)
                    }
                    print("count service \(self.arrListOfService.count)")
                   
                }else {
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

extension ServiceProvicerSignUpVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_service.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = arr_service[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceCell") as! serviceCell
        let status = dict["status"]
        cell.control_plus_min.removeTarget(self, action: #selector(ServiceProvicerSignUpVC.insert_row(_:)), for: .touchUpInside)
        cell.control_plus_min.removeTarget(self, action: #selector(ServiceProvicerSignUpVC.delete_row(_:)), for: .touchUpInside)
        if status == "0"{
            cell.img_pls_min.image = #imageLiteral(resourceName: "plush-1")
            cell.control_plus_min.addTarget(self, action: #selector(ServiceProvicerSignUpVC.insert_row(_:)), for: .touchUpInside)
        }else{
            cell.img_pls_min.image = #imageLiteral(resourceName: "close-1")
            cell.control_plus_min.addTarget(self, action: #selector(ServiceProvicerSignUpVC.delete_row(_:)), for: .touchUpInside)
        }
        
//        cell.lbl_service_name.text = dict["Service_name"]
        cell.lbl_service_name.text = self.serviceName
        //if cell.txt_prices.text! == "" && cell.txt_discount.text ==  "" {
            cell.txt_prices.text = dict["price"]
            cell.txt_discount.text = dict["discount"]
        //}else {
            print("w")
        //}
      //  cell.txt_prices.text = dict["price"]
       // cell.txt_discount.text = dict["discount"]
        cell.control_plus_min.tag = indexPath.row
        cell.control_service.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ServiceProvicerSignUpVC : UITextFieldDelegate {
    
    
    // MARK:- =======================================================
    //MARK: - Textfield Delegate Method
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == txt_address {
            self.openPlaceMap()
            return false
        }
        else {
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField
        {
            floatingLabelTextField.errorMessage = ""
        }
        textField.inputAccessoryView = toolbarInit(textField: textField);
        return true
        }
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
        txt_address.resignFirstResponder()
        txt_licence_type.resignFirstResponder()
        txt_lincence_no.resignFirstResponder()
        txt_country.resignFirstResponder()
        txt_state.resignFirstResponder()
        txt_social.resignFirstResponder()
        txt_tax_id.resignFirstResponder()

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

extension ServiceProvicerSignUpVC:GMSPlacePickerViewControllerDelegate {
    
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
        txt_address.text = place.name
        for i in 0...arrComponet.count - 1 {
            let comp = arrComponet[i] as! GMSAddressComponent
            print("Place name \(String(describing: comp.name))")
            if comp.type == "administrative_area_level_1" {
                txt_state.text = comp.name
            }
            if comp.type == "country" {
                txt_country.text = comp.name
            }
        }
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
    }
}
// MARK: User Define Methods
extension ServiceProvicerSignUpVC {
    
    func validateData1() -> Bool {
        
        txt_name.resignFirstResponder()
        txt_email.resignFirstResponder()
        txt_phone.resignFirstResponder()
        txt_password.resignFirstResponder()
        txt_address.resignFirstResponder()
        txt_lincence_no.resignFirstResponder()
        txt_licence_type.resignFirstResponder()
        
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
        
        guard (txt_phone.text?.characters.count)! >= 10  && (txt_phone.text?.characters.count)! <= 14 else
        {
            if let floatingLabelTextField = txt_phone
            {
                floatingLabelTextField.errorMessage = phoneMessage
            }
            return false
        }
        guard (txt_password.text?.characters.count)! > 0  else {
            if let floatingLabelTextField = txt_password
            {
                floatingLabelTextField.errorMessage = passwordMessage
            }
            return false
        }
        guard (txt_password.text?.characters.count)! > 7 else
        {
            if let floatingLabelTextField = txt_password
            {
                floatingLabelTextField.errorMessage = passwordMessage1
            }
            return false
        }
        guard (txt_address.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txt_address
            {
                floatingLabelTextField.errorMessage = address
            }
            return false
        }
        guard (txt_lincence_no.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txt_lincence_no
            {
                floatingLabelTextField.errorMessage = licenceNo
            }
            return false
        }
        guard (txt_licence_type.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txt_licence_type
            {
                floatingLabelTextField.errorMessage = licenceType
            }
            return false
        }
        
        return true
    }
    
    func validateData2() -> Bool {
        
        txt_country.resignFirstResponder()
        txt_state.resignFirstResponder()
        txt_social.resignFirstResponder()
        txt_tax_id.resignFirstResponder()
        
        guard (txt_country.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txt_country
            {
                floatingLabelTextField.errorMessage = countryName
            }
            return false
        }
        guard (txt_state.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txt_state
            {
                floatingLabelTextField.errorMessage = stateName
            }
            return false
        }
        guard (txt_social.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txt_social
            {
                floatingLabelTextField.errorMessage = socialNo
            }
            return false
        }
        guard (txt_tax_id.text?.characters.count)! > 0 else
        {
            if let floatingLabelTextField = txt_tax_id
            {
                floatingLabelTextField.errorMessage = texId
            }
            return false
        }
        
        guard self.arr_service[0]["Service_name"] != "" || self.arr_service[0]["price"] != "" || self.arr_service[0]["discount"] != "" else
        {
            appDelegate.Popup(Message: "Your service details is required.")
            return false
        }
        guard self.radius != 0.0 else{
            appDelegate.Popup(Message: "Please select working area radius.")
            return false
        }
        self.registerApiCall()
        
        return true
    }
    
    func validateEmail(_ candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
}
