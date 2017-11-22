//
//  ServiceProviderProfileVC.swift
//  PozList
//
//  Created by Devubha Manek on 11/20/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import TGPControls

class EditCellSP : UITableViewCell{
    @IBOutlet weak var lbl_header: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txt_edit: UITextField!
}

class SimpleCellSP : UITableViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_main: UILabel!
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

class RadiusCellSP : UITableViewCell{
    
    @IBOutlet weak var lblRadius: UILabel!
    @IBOutlet var radiusLeadingSpech: NSLayoutConstraint!
    @IBOutlet var radiusSliderView: UIView!
    @IBOutlet var lblMinValue: UILabel!
    @IBOutlet var lblMaxValue: UILabel!
    @IBOutlet var radiusSlider: TGPDiscreteSlider!
    
    
}

class AllServiceCellSP : UITableViewCell,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblMainService: UILabel!
    
    @IBOutlet var tblServiceList: UITableView!
    var arr_service = [userService]() //[["Service_name":"Plumbing","price":"$200","discount":"$20","status":"0","Service_id":""]]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_service.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = arr_service[indexPath.row]
        let cellInsu = tableView.dequeueReusableCell(withIdentifier: "ServiceCellSP") as! ServiceCellSP
        cellInsu.lbl_serviceName.text = dict.serviceName
        cellInsu.lblPrize.text = dict.prize
        cellInsu.lblDiscount.text = dict.discount
        return cellInsu
    }
}

class ServiceProviderProfileVC: UIViewController {

    @IBOutlet var imgProfile: UIImageView!
    
    var isEditing_profile = false
    
    var arr_edit = [["main":"Email","image":#imageLiteral(resourceName: "email-1"),"Edit_image":#imageLiteral(resourceName: "email"),"sub":"email","Place":"Enter Your Email"],
                    ["main":"Phone Number","image":#imageLiteral(resourceName: "phone_no"),"Edit_image":#imageLiteral(resourceName: "phone"),"sub":"phone number","Place":"Enter Your Phone Number"],
                    ["main":"Address","image":#imageLiteral(resourceName: "locaton"),"Edit_image":#imageLiteral(resourceName: "locaton"),"sub":"","Place":"Enter your address name"],
                    ["main":"City","image":#imageLiteral(resourceName: "enter_state"),"Edit_image":#imageLiteral(resourceName: "enter_state"),"sub":"city","Place":"Enter your city name"],
                    ["main":"LicenceNo","image":#imageLiteral(resourceName: "licence_number"),"Edit_image":#imageLiteral(resourceName: "licence_number-1"),"sub":"licence number","Place":"Enter your licence Number"],
                    ["main":"LicenceType","image":#imageLiteral(resourceName: "pro_licence"),"Edit_image":#imageLiteral(resourceName: "licence_type"),"sub":"licence type","Place":"Enter your licence type"],
                    ["main":"Insurance","image":"","name":""],
                    ["main":"Services","name":"","services":[userService]()],
                    ["main":"Radius","Edit_image":#imageLiteral(resourceName: "licence_type"),"sub":""],
                    ]
    
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtDesignation: UITextField!
    @IBOutlet var btnSaveAndEdit: UIButton!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblDesignation: UILabel!
    @IBOutlet var lblUserStatus: UILabel!
    
    @IBOutlet var table_view: UITableView!
    @IBOutlet var btnSaveAndEditWidthCons: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getUserProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - All Click Events
    @IBAction func ClickBtnSaveOrEdit(_ sender: UIButton) {
        //if isEditing_profile{
                self.isEditing_profile = !self.isEditing_profile
                self.Changes_UI()
        //}
    }
    
    @objc func valueChanged(_ sender: TGPDiscreteSlider, event:UIEvent) {
        //lbl_show_miles_area.text = "Set working area radius(\(sender.value) miles) "
        //radius = Double(sender.value)
    }
}

// MARK: - User Define Method
extension ServiceProviderProfileVC {
    
    func getUserProfile() {
        
        let dict = [String : Any]()
        let userId = "60" //UserDefaults.Main.string(forKey: .UserID)
        MTWebCall.call.getUserProfile(userId: userId, dictParam: dict) { (respons, status) in
            
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
                    
                    var arrUserService = [userService]()
                    var strMainService = ""
                    let arrService = getArrayFromDictionary(dictionary: dictData, key: "service_json")
                    if arrService.count > 0 {
                        
                        for i in 0...arrService.count - 1 {
                            
                            let catValue = arrService[i] as! NSDictionary
                            
                            let serviceId = createString(value:catValue.value(forKey: "service_id") as AnyObject)
                            let prize = createString(value: catValue.value(forKey: "price") as AnyObject)
                            let discount = createString(value: catValue.value(forKey: "discount") as AnyObject)
                            let serviceName = createString(value: catValue.value(forKey: "name") as AnyObject)
                            let status = createString(value: catValue.value(forKey: "status") as AnyObject)
                            
                            let userServic = userService.init(serviceId: serviceId, prize: prize, discount: discount, serviceName: serviceName, status: status)
                            strMainService = serviceName
                            arrUserService.append(userServic)
                        }
                    }
                    
                    let userdate = ServiceProvider.init(id: id, username: username, email: email, mobile: mobile, type: type, status: status, address: sAddress, city: "", country: sCountry, state: sState, licenceNo: slicenceNo, licenceType: slicenceType, socialNo: ssocialNo, texId: sltexId, latitude: slatitude,longitude: slongitude, userServices:arrUserService)
                    
                    self.arr_edit = [["main":"Email","image":#imageLiteral(resourceName: "email-1"),"Edit_image":#imageLiteral(resourceName: "email"),"sub":email,"Place":"Enter Your Email"],
                                    ["main":"Phone Number","image":#imageLiteral(resourceName: "phone_no"),"Edit_image":#imageLiteral(resourceName: "phone"),"sub":mobile,"Place":"Enter Your Phone Number"],
                                    ["main":"Address","image":#imageLiteral(resourceName: "locaton"),"Edit_image":#imageLiteral(resourceName: "locaton"),"sub":sAddress,"Place":"Enter your address name"],
                                    ["main":"City","image":#imageLiteral(resourceName: "enter_state"),"Edit_image":#imageLiteral(resourceName: "enter_state"),"sub":sCountry,"Place":"Enter your city name"],
                                    ["main":"LicenceNo","image":#imageLiteral(resourceName: "licence_number"),"Edit_image":#imageLiteral(resourceName: "licence_number-1"),"sub":slicenceNo,"Place":"Enter your licence Number"],
                                    ["main":"LicenceType","image":#imageLiteral(resourceName: "pro_licence"),"Edit_image":#imageLiteral(resourceName: "licence_type"),"sub":slicenceType,"Place":"Enter your licence type"],
                                    ["main":"Insurance","image":strMainService,"name":strMainService],
                                    ["main":"Services","name":strMainService,"services":arrUserService],
                                    ["main":"Radius","Edit_image":#imageLiteral(resourceName: "licence_type"),"sub":radius],
                                    ]
                    self.lblUserName.text = username
                    self.lblDesignation.text = strMainService
                    if status == "Active" {
                        self.lblUserStatus.text = "Approved"
                    } else {
                        self.lblUserStatus.text = "Panding"
                    }
                    
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
            
          //  Control_edit_profile.isUserInteractionEnabled = true
            txtUserName.text = lblUserName.text
            txtUserName.isUserInteractionEnabled = true
            txtUserName.font = UIFont.init(name: FontName.RobotoRegular, size: 14.0)
            btnSaveAndEditWidthCons.constant = 120
           // cons_width_lbl_under_name.constant = self.txt_name_edit.frame.size.width
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
          //  self.cons_table_height.constant = self.table_view.contentSize.height
            
        }else{
            //For save profile
            lblUserName.isHidden = false
            lblDesignation.isHidden = false
            lblUserStatus.isHidden = false
           // Control_edit_profile.isUserInteractionEnabled = false
            txtUserName.isUserInteractionEnabled = false
            self.btnSaveAndEdit.setTitle("", for: UIControlState.normal)
            btnSaveAndEdit.setImage(#imageLiteral(resourceName: "edit"), for:UIControlState.normal)
            
            btnSaveAndEditWidthCons.constant = 40
            //cons_width_lbl_under_name.constant = 0
            //animation:
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
            //self.cons_table_height.constant = self.table_view.contentSize.height
        }
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
                    cellInsu.lblRadius.text = "100 miles"
                    cellInsu.radiusSlider.addTarget(self, action: #selector(ServiceProvicerSignUpVC.valueChanged(_:event:)), for: .valueChanged)
                    return cellInsu
                    
                } else if value == "Services" {
                    let cellInsu = tableView.dequeueReusableCell(withIdentifier: "AllServiceCellSP") as! AllServiceCellSP
                    cellInsu.arr_service = dict["services"] as! [userService]
                    cellInsu.lblMainService.text = dict["name"] as? String
                    let imgName = dict["name"] as? String
                    cellInsu.img.image = UIImage.init(named: imgName!.lowercased() + "-1")
                    cellInsu.tblServiceList.reloadData()
                    return cellInsu
                } else if value == "Insurance" {
                    cell = tableView.dequeueReusableCell(withIdentifier: "EditCellSP") as! EditCellSP
                    return cell
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
                cell.lbl_title.text = (dict["main"] as! String)
                cell.txt_edit.text = dict["sub"] as? String
                cell.txt_edit.tag = indexPath.row + 1
                cell.txt_edit.placeholder = dict["Place"] as? String
                
                if (dict["main"] as! String == "Email") {
                    cell.txt_edit.isUserInteractionEnabled = false
                }
                
                return cell
            }else{
                var cell:SimpleCellSP!
                
                if value == "Radius" {
                    let cellInsu = tableView.dequeueReusableCell(withIdentifier: "RadiusCellSP") as! RadiusCellSP
                    cellInsu.lblRadius.text = "100 miles"
                    return cellInsu
                    
                } else if value == "Services" {
                    let cellInsu = tableView.dequeueReusableCell(withIdentifier: "AllServiceCellSP") as! AllServiceCellSP
                    cellInsu.arr_service = dict["services"] as! [userService]
                    cellInsu.lblMainService.text = dict["name"] as? String
                    let imgName = dict["name"] as? String
                    cellInsu.img.image = UIImage.init(named: imgName!.lowercased() + "-1")
                    return cellInsu
                    
                } else if value == "Insurance" {
                    let cellInsu = tableView.dequeueReusableCell(withIdentifier: "InsuranceCellSP") as! InsuranceCellSP
                    let strName = dict["name"] as!  String
                    cellInsu.lbl_main.text = strName + " Insurance"
                    cellInsu.lbl_status.text = "Active"
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
