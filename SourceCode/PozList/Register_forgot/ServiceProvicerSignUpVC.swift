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

class serviceCell:UITableViewCell{
    
    @IBOutlet weak var txt_discount: SkyFloatingLabelTextField!
    
    @IBOutlet weak var control_service: UIControl!
    @IBOutlet weak var control_plus_min: UIControl!
    @IBOutlet weak var lbl_service_name: UILabel!
    @IBOutlet weak var txt_prices: SkyFloatingLabelTextField!
    @IBOutlet weak var img_pls_min: UIImageView!
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
    
    var dropDownList:DropDown = DropDown()
    
    var Y_first = CGFloat()
    var Y_sec = CGFloat()
    
     var arrDropList = ["Plumbing","electronic","reparing","free services"]
    var arr_service = [["Service_name":"Plumbing","price":"$100.0","discount":"$10.0","status":"1"],["Service_name":"","price":"","discount":"","status":"0"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.previous(UIControl())
        dualColorSlider.addTarget(self, action: #selector(ServiceProvicerSignUpVC.valueChanged(_:event:)), for: .valueChanged)
        setupAllTextFiels()
        self.tableReload()
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
        lbl_show_miles_area.text = "Set working area radius(\(sender.value) miles) "
        print()
     
    }
    
    @objc func insert_row(_ sender: UIControl){
        
        let section = 0
        let row = sender.tag
        let indexPath = IndexPath(row: row, section: section)
        let cell: serviceCell = self.table_view.cellForRow(at: indexPath) as! serviceCell
        let service_name = cell.lbl_service_name.text!
        if arr_service.count == 1{
            arr_service.insert(["Service_name":service_name,"price":cell.txt_prices.text!,"discount":cell.txt_discount.text!,"status":"1"], at: 0)
        }else{
            arr_service.insert(["Service_name":service_name,"price":cell.txt_prices.text!,"discount":cell.txt_discount.text!,"status":"1"], at: arr_service.count - 2)
        }
        table_view.beginUpdates()
        table_view.insertRows(at: [IndexPath(row: row , section: 0)], with: .automatic)
        table_view.endUpdates()
        self.tableReload()
        self.table_view.reloadData()
    }
    
    @objc func delete_row(_ sender: UIControl){
        arr_service.remove(at:sender.tag)
        table_view.beginUpdates()
        table_view.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        table_view.endUpdates()
        self.tableReload()
        self.table_view.reloadData()
    }
    
    @IBAction func tapToDropDown(_ sender: UIControl) {
        
    
        self.setupDropDownList(control: sender, arr: arrDropList)
        dropDownList.show()
        dropDownList.tag = sender.tag
        
    }
    
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
            cell.lbl_service_name.text = item
            
        }
    }
    @IBAction func Next(_ sender: UIControl) {
        
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
        
        let usertype = UserType.ServiceProvider
        UserDefaults.Main.set(usertype.rawValue, forKey: .Appuser)
        
        let vc = storyBoards.Main.instantiateViewController(withIdentifier: "UploadCertificateVC") as! UploadCertificateVC
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        cell.lbl_service_name.text = dict["Service_name"]
        cell.txt_prices.text = dict["price"]
        cell.txt_discount.text = dict["discount"]
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
