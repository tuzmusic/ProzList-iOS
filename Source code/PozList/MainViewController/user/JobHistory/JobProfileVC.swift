//
//  JobProfileVC.swift
//  PozList
//
//  Created by Devubha Manek on 04/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class JobProfileVC: UIViewController,CustomToolBarDelegate {
   
    

    @IBOutlet weak var NavigationView: UIView!
    @IBOutlet weak var scroll_view: UIScrollView!
    //@IBOutlet weak var cons_heighte_txtView: NSLayoutConstraint!
   // @IBOutlet weak var text_view: UITextView!
    @IBOutlet weak var lbl_naviga: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet var viewRequestStatus: UIView!
    @IBOutlet var imgRequestStauts: UIImageView!
    @IBOutlet var lbl_complete: UILabel!
    
    var profileHeaderView:ProfileHeaderView!
    var flexibleHeaderView:DKStickyHeaderView!
    
    var placeholderLabel1 : UILabel!
    var toolBar : CustomToolBar = CustomToolBar.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.WIDTH, height: 40),isSegment: false)
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    var requestData:ServiceRequest!
    
    //MARK: - Initialization view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      //  cosmosView.didTouchCosmos = true
        
        // Called when user finishes changing the rating by lifting the finger from the view.
        // This may be a good place to save the rating in the database or send to the server.
        cosmosView.didFinishTouchingCosmos = { rating in }
        
        // A closure that is called when user changes the rating by touching the view.
        // This can be used to update UI as the rating is being changed by moving a finger.
        cosmosView.didTouchCosmos = { rating in }
        
//        // Reset float rating view's background color
//        floatRatingView.backgroundColor = UIColor.clear
//
//        /** Note: With the exception of contentMode, type and delegate,
//         all properties can be set directly in Interface Builder **/
//       // floatRatingView.delegate = self
//        floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
//        floatRatingView.type = .wholeRatings
//
        
        flexibleHeaderView = DKStickyHeaderView(minHeight: 250) //less status bar size (20) from view size 436
        flexibleHeaderView.backgroundColor = UIColor.init(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        profileHeaderView = Bundle.main.loadNibNamed("ProfileHeaderView", owner: nil, options: nil)![0] as! ProfileHeaderView
        flexibleHeaderView.addSubview(profileHeaderView)
        profileHeaderView.frame = flexibleHeaderView.bounds
        profileHeaderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       
        
       // profileHeaderView.lblUserName.text = "dfsgdfg"
        
        var str1 =  WebURL.ImageBaseUrl + requestData.serviceProviderProfile.profilePic
        str1 = str1.replacingOccurrences(of: " ", with: "%20")
        profileHeaderView.profileImgView.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "imgUserPlaceholder"), options: .refreshCached)
        
        let userType = UserDefaults.Main.string(forKey: .Appuser)
        if userType == "Service"{
            //Login using Service Provider
            let dblRate = Double (requestData.customerProfile.avgRating )
            profileHeaderView.lbl_star.text = "\(String(format: "%.1f", dblRate!))"
            profileHeaderView.lblUserName.text = requestData.customerProfile.username
           profileHeaderView.lblUserDetail.text = "-"
            str1 =  WebURL.ImageBaseUrl + requestData.customerProfile.profileImg
            profileHeaderView.profileImgView.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)


        }else{
            //Login using Customer
            let dblRate = Double (requestData.serviceProviderProfile.avgRating )
            profileHeaderView.lbl_star.text = "\(String(format: "%.1f", dblRate!))"
            profileHeaderView.lblUserName.text = requestData.serviceProviderProfile.username.capitalized
            profileHeaderView.lblUserDetail.text = requestData.serviceCatName
            profileHeaderView.control_profile_click.addTarget(self, action:#selector(JobProfileVC.click_profile_service), for: .touchUpInside)
            
        }
        
        self.scroll_view.delegate = self
        self.scroll_view.addSubview(flexibleHeaderView)
        self.scroll_view.bringSubview(toFront: NavigationView)

        placeholderLabel1 = UILabel()
        placeholderLabel1.text = "Add your review here"
        placeholderLabel1.font = UIFont.init(name: FontName.RobotoLight, size: 17.0)
        placeholderLabel1.sizeToFit()
        //text_view.addSubview(placeholderLabel1)
        placeholderLabel1.frame.origin = CGPoint(x: 4, y: placeholderLabel1.font.pointSize / 2)
        placeholderLabel1.textColor = UIColor.lightGray
        //placeholderLabel1.isHidden = !text_view.text.isEmpty
       // print(self.text_view.contentSize.height)
       // self.cons_heighte_txtView.constant = self.text_view.contentSize.height
        // Do any additional setup after loading the view.
        
        //Set Service Description
        lblDescription.text = requestData.serviceReqDesc
        
        //Set Service Address
        lblAddress.text = requestData.address
        
        //Set review
        if requestData.ratingNReviewObj.review == ""{
            lblReview.text = "No enough review"
        }else{
            lblReview.text = requestData.ratingNReviewObj.review
        }
        
        //Set Ratings
        if requestData.ratingNReviewObj.rating == ""{
            cosmosView.rating = 0.0
        }else{
            cosmosView.rating = Double(requestData.ratingNReviewObj.rating)!
        }
        
        //Set Request Status
        
            viewRequestStatus.backgroundColor = UIColor.appGreen()
            imgRequestStauts.image = #imageLiteral(resourceName: "electricle_light_green")
            lbl_complete.text = requestData.status
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        profileHeaderView.profileImgView.layer.cornerRadius = profileHeaderView.profileImgView.frame.size.height / 2.0
//        profileHeaderView.control_profile_click.layer.cornerRadius = profileHeaderView.control_profile_click.frame.size.height / 2.0
        //self.view.layoutIfNeeded()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func click_profile_service() {
        let vc = storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "ServiceProviderProfileVC") as! ServiceProviderProfileVC
        vc.isOnlyShowProfile = true
        vc.serviceProviderId = requestData.serviceProviderProfile.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func back_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPaymentDetailPressed(_ sender: Any) {
        let vc = storyBoards.Customer.instantiateViewController(withIdentifier: "PaymentRecipetVC") as! PaymentRecipetVC
        vc.requestData = self.requestData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func closeKeyBoard() {
        resignFirstResponder()
    }
}

extension JobProfileVC :UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scroll_view {
            if scrollView.contentOffset.y > 186 {
                UIView.animate(withDuration: 0.5, animations: {
//                    self.NavigationView.backgroundColor = UIColor.init(red: 243/255.0, green: 44/255.0, blue: 128/255.0, alpha: 1.0) //0.4
                    self.lbl_naviga.text = self.requestData.serviceProviderProfile.username.capitalized
                })
            }else{
                UIView.animate(withDuration: 0.5, animations: {
                     self.lbl_naviga.text =  "Job Detail"
                   // self.NavigationView.backgroundColor = UIColor.clear
                })
            }
        }
    }
}

/*extension JobProfileVC :UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.autocorrectionType = .no
        textView.inputAccessoryView = toolbarInit(textField: UITextField())
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("chars \(textView.text.characters.count) \( text)")
        return true;
    }
    func textViewDidChange(_ textView: UITextView) {
        
        self.placeholderLabel1.isHidden = !textView.text.isEmpty
        print(self.text_view.contentSize.height)
        self.cons_heighte_txtView.constant = self.text_view.contentSize.height + 20
        
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
    
}*/
//extension JobProfileVC:FloatRatingViewDelegate {
//
//    // MARK: FloatRatingViewDelegate
//
//    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
//        print(String(format: "%.2f", self.floatRatingView.rating))
//       // liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
//    }
//    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
//        print(String(format: "%.2f", self.floatRatingView.rating))
//        //updatedLabel.text = String(format: "%.2f", self.floatRatingView.rating)
//    }
//
//}

