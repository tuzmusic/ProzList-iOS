//
//  UploadCertificateVC.swift
//  PozList
//
//  Created by Devubha Manek on 16/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import GTProgressBar
import Alamofire

class cell_dotted :UITableViewCell {
    @IBOutlet weak var img_Certi: UIImageView!
    @IBOutlet weak var lbl_certi_name: UILabel!
    @IBOutlet weak var progressBar: GTProgressBar!
    var uploadImagetag : Int!
    var uploadStatus : Bool!
    
    @IBOutlet var btnDelete: UIButton!
}


class UploadCertificateVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var view_shadow: UIView!
    
    @IBOutlet weak var tbl_view: UITableView!
    @IBOutlet weak var dotted_view: UIControl!

   
    var imag_arry = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view_shadow.layer.shadowOpacity = 0.2
        view_shadow.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        view_shadow.layer.shadowRadius = 5.0
        view_shadow.layer.shadowColor = UIColor.black.cgColor
        
//        self.navigationController?.navigationBar.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func click_back(_ sender: UIButton) {
    }
    @IBAction func click_Image_picker(_ sender: UIControl) {
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
    
    
    //MARK: =======================================================
    //MARK: UIImagePicker Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       let image  = info[UIImagePickerControllerEditedImage] as? UIImage
        imag_arry.append(image!)
        self.tbl_view.reloadData()
        
        picker.dismiss(animated: true, completion: {
        })
    }
    
    @IBAction func Click_upload(_ sender: UIControl) {
        if (imag_arry.count > 0) {
            var dict = [String:String]()
            dict["user_id"] = UserDefaults.Main.string(forKey: .UserID)
            let userType = UserDefaults.Main.string(forKey: .Appuser)
            if userType == "Service"{
                dict["type"] = CertificateType.serviceProvider.rawValue
            }
            self.uplaodImages(imag: imag_arry[0] , parameters: dict, indexPath: 0)
        }
    }
    @IBAction func clickDeleteCertificate(_ sender: UIButton) {
        imag_arry.remove(at: sender.tag)
        tbl_view.reloadData()
    }
}

extension UploadCertificateVC  {
    
    func uplaodImages(imag:UIImage,parameters:[String:String],indexPath:Int) {
        let headers: HTTPHeaders = [
            //"Content-Type": "application/x-www-form-urlencoded",
            "apikey":WebURL.appkey
        ]
        
        
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(UIImageJPEGRepresentation(imag, 1.0)!, withName: "images[]", fileName: "cartificate.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                formData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: WebURL.uploadCertificate, method: HTTPMethod.post, headers: headers, encodingCompletion: { encoding in
            switch encoding{
            case .success(let req, _, _):
                req.uploadProgress(closure: { (prog) in
                    let section = 0
                    let row = indexPath
                    let indexPath = IndexPath(row: row, section: section)
                    let cell: cell_dotted = self.tbl_view.cellForRow(at: indexPath) as! cell_dotted
                    cell.progressBar.progress = CGFloat(prog.fractionCompleted)
                    print("Upload Progress: \(prog.fractionCompleted)")
                }).responseJSON { (resObj) in
                    switch resObj.result{
                    case .success:
                        if let resData = resObj.data{
                            do {
                                let res = try JSONSerialization.jsonObject(with: resData, options: []) as AnyObject
                                let dictResponse = res as! NSDictionary
                                let message = getStringFromDictionary(dictionary: dictResponse, key: "msg")
                                let Response = getStringFromDictionary(dictionary: dictResponse, key: "response")
                                if Response == "true" {
                                    self.imag_arry.remove(at: 0)
                                    let next = indexPath + 1
                                    if (self.imag_arry.count > 0 ) {
                                        self.uplaodImages(imag: self.imag_arry[0], parameters: parameters, indexPath: next)
                                    }
                                    else{
                                        UserDefaults.Main.set(true, forKey: .isCertificated)
                                        let vc = storyBoards.Main.instantiateViewController(withIdentifier: "SubscribeVC") as! SubscribeVC
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                } else {
                                    alert(message: message)
                                }
                            } catch let errParse{
                                jprint(items: errParse)
                            }
                        }
                        break
                    case .failure(let err):
                        jprint(items: err)
                        break
                    }
                }
                break
            case .failure(let err):
                jprint(items: err)
                break
            }
        })
    }
}

extension UploadCertificateVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imag_arry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_dotted") as! cell_dotted
            cell.img_Certi.image = imag_arry[indexPath.row]
            cell.progressBar.progress = 0.0
            cell.uploadImagetag = indexPath.row
            cell.uploadStatus = false
            cell.btnDelete.tag = indexPath.row
            return cell
    }
}
