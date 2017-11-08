//
//  UploadCertificateVC.swift
//  PozList
//
//  Created by Devubha Manek on 16/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import GTProgressBar

class cell_dotted :UITableViewCell {
    @IBOutlet weak var img_Certi: UIImageView!
    @IBOutlet weak var lbl_certi_name: UILabel!
    @IBOutlet weak var progressBar: GTProgressBar!
    
}


class UploadCertificateVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var view_shadow: UIView!
    
    @IBOutlet weak var tbl_view: UITableView!
    @IBOutlet weak var dotted_view: UIControl!

   
    var imag_arry = [#imageLiteral(resourceName: "user")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view_shadow.layer.shadowOpacity = 0.2
        view_shadow.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        view_shadow.layer.shadowRadius = 5.0
        view_shadow.layer.shadowColor = UIColor.black.cgColor
    
        

        
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
        let vc = storyBoards.Main.instantiateViewController(withIdentifier: "SubscribeVC") as! SubscribeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension UploadCertificateVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imag_arry.count
        //return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_dotted") as! cell_dotted
            cell.img_Certi.image = imag_arry[indexPath.row]
            cell.progressBar.progress = 0.5

        
        
            return cell
        
    }
}
