//
//  ServiceReqDetailVC.swift
//  PozList
//
//  Created by Devubha Manek on 03/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

class SrvcSelCell: UITableViewCell {
    
    @IBOutlet weak var img_left: UIImageView!
    @IBOutlet weak var img_right: UIImageView!
    @IBOutlet weak var lbl_service_name: UILabel!
}

class cellColl: UICollectionViewCell {
    
    @IBOutlet weak var img_main: UIImageView!
    @IBOutlet weak var img_add_delete: UIImageView!
}


import UIKit
import Photos
import DKImagePickerController


class ServiceReqDetailVC: UIViewController,CustomToolBarDelegate {
    
    @IBOutlet weak var lbl_service_main: UILabel!
    @IBOutlet weak var img_arrow: UIImageView!
    @IBOutlet weak var Cons_table_view: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Coll_view: UICollectionView!
    
    @IBOutlet weak var text_view: UITextView!
    
    
    var placeholderLabel1 : UILabel!
    var isExpande = false
    var assets: [DKAsset]?
    var toolBar : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: false)
    var arr_image = NSMutableArray()
    var arr_service_list = [["Service":"Plumbing","img":#imageLiteral(resourceName: "plumbing"),"IsSelcted":false],["Service":"Eletrical","img":#imageLiteral(resourceName: "electricle"),"IsSelcted":false],["Service":"HVAC","img":#imageLiteral(resourceName: "HVAC"),"IsSelcted":false],["Service":"Handyman","img":#imageLiteral(resourceName: "handyman"),"IsSelcted":false]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        self.Cons_table_view.constant = 0
        placeholderLabel1 = UILabel()
        placeholderLabel1.text = "add about service description"
        placeholderLabel1.font = text_view.font
        placeholderLabel1.sizeToFit()
        text_view.addSubview(placeholderLabel1)
        placeholderLabel1.frame.origin = CGPoint(x: 4, y: (text_view.font?.pointSize)! / 2)
        placeholderLabel1.textColor = UIColor.lightGray
        placeholderLabel1.isHidden = !text_view.text.isEmpty
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Click_Add_service(_ sender: Any) {
        isExpande = !isExpande
        if isExpande{
            self.tableView.reloadData()
             self.tableView.clipsToBounds = false
            self.Cons_table_view.constant = self.tableView.contentSize.height
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
                self.img_arrow.transform = CGAffineTransform.identity
                self.view.layoutIfNeeded()
            } ) { (completed) in
                
            }
        }else{
            self.Cons_table_view.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
                self.img_arrow.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                self.view.layoutIfNeeded()
            } ) { (completed) in
                 self.tableView.clipsToBounds = true
            }
        }
    }
    
    @IBAction func click_Submit(_ sender: Any) {
        
    }
    
    @IBAction func click_bak(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Click_add_img(_ sender: UIControl) {
        if  sender.accessibilityIdentifier == "add" {
          self.get_MultipleImage()
        }else if sender.accessibilityIdentifier == "Delete" {
            self.arr_image.removeObject(at:sender.tag )
            self.Coll_view.reloadData()
        }
    }
    
    func get_MultipleImage()  {
        let pickerController = DKImagePickerController()
        // pickerController.sourceType = .photo
        pickerController.maxSelectableCount = 10
        pickerController.UIDelegate = CustomCameraUIDelegate() as DKImagePickerControllerUIDelegate
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            //self.selectedCount = self.selectedCount + assets.count
            // print(assets)
            //self.assets = assets
            self.arr_image.removeAllObjects()
            // self.arr_image.addObjects(from: self.post_datas.media)
            if (assets != nil) || assets.count != 0{
                for obje in assets{
                    if  self.arr_image.count < 10 {
                        self.arr_image.add(obje)
                    }
                }
                self.Coll_view.reloadData()
            }
        }
        self.present(pickerController, animated: true, completion: nil)
    }
}
extension ServiceReqDetailVC: UITableViewDataSource,UITableViewDelegate{
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_service_list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = arr_service_list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SrvcSelCell") as! SrvcSelCell
        
        let isselectd = dict["IsSelcted"] as! Bool
        if  !isselectd{
            cell.img_left.isHidden = true
            cell.img_right.isHidden = true
        }else{
            cell.img_left.isHidden = false
            cell.img_right.isHidden = false
        }
        cell.lbl_service_name.text = dict["Service"] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        for i in 0...arr_service_list.count - 1 {
            var dict = arr_service_list[i]
            dict["IsSelcted"] = false
            arr_service_list[i] = dict
        }
        var dict = arr_service_list[indexPath.row]
        dict["IsSelcted"] = true
        lbl_service_main.text = dict["Service"] as! String
        arr_service_list[indexPath.row] = dict
        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.tableView.reloadData()
        self.Click_Add_service(UIControl())
    }
}

extension ServiceReqDetailVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width:CGFloat!
        width = (self.Coll_view.bounds.size.width - 75) / 5
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arr_image.count == 10{
             return arr_image.count
        }else{
            return arr_image.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellColl", for: indexPath) as! cellColl
        if indexPath.row == 0 && arr_image.count == 0{
            cell.img_add_delete.superview?.accessibilityIdentifier = "add"
            cell.img_main.image = #imageLiteral(resourceName: "profile")
            cell.img_add_delete.image = #imageLiteral(resourceName: "plush")
            cell.img_add_delete.superview?.backgroundColor = UIColor.appGreen()
        }else{
            if indexPath.row == arr_image.count  && arr_image.count > 0{
                 cell.img_add_delete.superview?.accessibilityIdentifier = "add"
                cell.img_main.image = #imageLiteral(resourceName: "profile")
                cell.img_add_delete.image = #imageLiteral(resourceName: "plush")
                cell.img_add_delete.superview?.backgroundColor = UIColor.appGreen()
            }else{
                
                let asset = self.arr_image[indexPath.row] as! DKAsset
                let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                asset.fetchImageWithSize(layout.itemSize.toPixel(), completeBlock: { image, info in
                    cell.img_add_delete.superview?.accessibilityIdentifier = "Delete"
                    cell.img_main.image = image
                    cell.img_add_delete.image =  #imageLiteral(resourceName: "delete")
                    cell.img_add_delete.superview?.backgroundColor = UIColor.red
                })
            }
        }
        cell.img_add_delete.superview?.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}
extension ServiceReqDetailVC :UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.autocorrectionType = .no
        textView.inputAccessoryView = toolbarInit(textField: UITextField())
        return true
    }
  
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("chars \(textView.text.characters.count) \( text)")
        return true;
    }
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel1.isHidden = !textView.text.isEmpty
    }
    
    func toolbarInit(textField: UITextField) -> UIToolbar
    {
        toolBar.delegate1 = self
        toolBar.txtField = textField
        return toolBar;
    }
    func closeKeyBoard() {
        resignKeyboard()
    }
    
    func resignKeyboard()
    {
        self.text_view.resignFirstResponder()
       
    }
  
}

