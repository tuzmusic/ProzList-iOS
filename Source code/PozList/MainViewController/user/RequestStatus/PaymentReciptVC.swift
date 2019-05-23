//
//  PaymentRecipetVC.swift
//  PozList
//
//  Created on 06/10/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
class PaymentReceiptVC: UIViewController {

    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var view_main_top: UIView!
    @IBOutlet weak var view_main_bottom: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var requestData:ServiceRequest!
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            DispatchQueue.main.async {
                let width = self.view_main.frame.size.width
                let noOfImage = Int(width) / 35
                
                for i in 0...noOfImage  {
                    let imges = UIImageView.init(frame: CGRect(x: (35*i) , y:  0, width: 35, height: 17))
                    imges.image = #imageLiteral(resourceName: "border_payment_top")
                    self.view_main_top.addSubview(imges)
//                    let imges = UIImageView.init(frame: CGRect(x: (35*i) + Int(self.view_main.frame.origin.x) , y:  Int(self.view_main.frame.origin.y - 17), width: 35, height: 17))
//                    imges.image = #imageLiteral(resourceName: "border_payment_top")
//                    self.scrollView.addSubview(imges)
                }
                
                for i in 0...noOfImage  {
                    let imges = UIImageView.init(frame: CGRect(x: (35*i) , y: 0, width: 35, height: 17))
                    // let imges = UIImageView.init(frame: CGRect(x: (35*i) , y: Int( self.view_main.frame.size.height ) + Int(self.view_main.frame.origin.y), width: 35, height: 17))
                    imges.image = #imageLiteral(resourceName: "border_bottom_payment")
                    self.view_main_bottom.addSubview(imges)
                }
            }
        }
        self.setData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setData(){
        
    }
    
    @IBAction func ClickBack(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDownloadPressed(_ sender: Any) {
        let requestId = self.requestData.ratingNReviewObj.serviceRequestId
        let transactionId = self.requestData.transactionId
        let userId = UserDefaults.Main.string(forKey: .UserID)
        appDelegate.showLoadingIndicator()
        MTWebCall.call.downloadPdfFile(userId: userId, transactionId: transactionId, requestId: requestId, dictParam: [:]) { (path, status) in
            appDelegate.hideLoadingIndicator()
            if status == true {
                let documentInteractionController = UIDocumentInteractionController(url: URL(fileURLWithPath: path!))
                documentInteractionController.delegate = self
                documentInteractionController.presentPreview(animated: true)
            
            }else {
                //Popup
                let Title = NSLocalizedString("Somthing went wrong \n Try after sometime", comment: "")
                appDelegate.Popup(Message: Title)
            }
            
        }
    }
    @IBAction func btnEmailReceiptPressed(_ sender: Any) {
        let requestId = self.requestData.ratingNReviewObj.serviceRequestId
        let transactionId = self.requestData.transactionId
        let userId = UserDefaults.Main.string(forKey: .UserID)
        appDelegate.showLoadingIndicator()
        MTWebCall.call.emailPdfFile(userId: userId, transactionId: transactionId, requestId: requestId, dictParam: [:]) { (respons, status) in
            appDelegate.hideLoadingIndicator()
            jprint(items: status)
            if (status == 200 && respons != nil) {
                //Response
                let dictResponse = respons as! NSDictionary
                //Popup
                let message = getStringFromDictionary(dictionary: dictResponse, key: "msg")
                appDelegate.Popup(Message: "\(message)")
            }else {
                //Popup
                let Title = NSLocalizedString("Somthing went wrong \n Try after sometime", comment: "")
                appDelegate.Popup(Message: Title)
            }
            
        }
        
    }
}
//MARK: - UIDocumentInteractionController Delegate Event
extension PaymentReceiptVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
