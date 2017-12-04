//
//  StricksAndReviewVC.swift
//  PozList
//
//  Created by Devubha Manek on 12/1/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class ReviewCell : UITableViewCell{
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblRates: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
}

class StrickCell : UITableViewCell{
    
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
}

class StricksAndReviewVC: UIViewController ,SideMenuItemContent{

    
    @IBOutlet weak var viewReview: UIView!
    @IBOutlet weak var viewStricks: UIView!
    var isReview:Bool!
    var arrReview = [Review]()
    var arrStrcks = [Stricks]()
    
    @IBOutlet weak var tblStricksAndReview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        isReview = false
        self.setUpUi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func ClickMenu(_ sender: UIButton) {
        showSideMenu()
    }
    
    @IBAction func btnViewMoreClick(_ sender: UIButton) {
    
    }
    @IBAction func btnStricksClick(_ sender: Any) {
        isReview = false
        self.setUpUi()
    }
    
    @IBAction func btnReviewClick(_ sender: Any) {
        isReview = true
        self.setUpUi()
    }
    
    func setUpUi() {
        if isReview {
            viewReview.isHidden = false
            self.getReview()
        } else {
            viewStricks.isHidden = true
            self.getStricks()
        }
    }
}

// MARK: - Table view deleget

extension StricksAndReviewVC {
    
    func getReview() {
        arrReview.removeAll()
        let dict = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        appDelegate.showLoadingIndicator()
        MTWebCall.call.getCutomerReview(userId: userid,type: UserType.ServiceProvider.rawValue, dictParam: dict) { (responas, status) in
            appDelegate.hideLoadingIndicator()
            jprint(items: status)
            if (status == 200 && responas != nil) {
                //Response
                let dictResponse = responas as! NSDictionary
                
                let Response = getStringFromDictionary(dictionary: dictResponse, key: "response")
                if Response == "true"
                {
                    //Message
                    let message = getStringFromDictionary(dictionary: dictResponse, key: "msg")
                    print(message)
                    
                    let arrService = getArrayFromDictionary(dictionary: dictResponse, key: "data")
                    
                    if arrService.count > 0 {
                        
                        for i in 0...arrService.count - 1 {
                            let catValue = arrService[i] as! NSDictionary
                            
                            let id = createString(value:catValue.value(forKey: "id") as AnyObject)
                            let rate = createString(value:catValue.value(forKey: "cat_id") as AnyObject)
                            let strReview = createString(value:catValue.value(forKey: "status") as AnyObject)
                            
                            let dictData = getDictionaryFromDictionary(dictionary: catValue, key: "service_customer_detail")
                            let cid = createString(value:dictData.value(forKey: "id") as AnyObject)
                            let username = createString(value: dictData.value(forKey: "name") as AnyObject)
                            let email = createString(value: dictData.value(forKey: "email") as AnyObject)
                            let mobile = createString(value: dictData.value(forKey: "phone") as AnyObject)
                            let type = createString(value: dictData.value(forKey: "role") as AnyObject)
                            let cstatus = createString(value: dictData.value(forKey: "status") as AnyObject)
                            let city = createString(value: dictData.value(forKey: "status") as AnyObject)
                            let profileImg = createString(value: dictData.value(forKey: "profile_pic") as AnyObject)
                            let cutomerdata = Profile.init(id: cid, username: username, email: email, mobile: mobile, type: type, status: cstatus, city: city,profileImg: profileImg)
                            
                            let dictSPData = getDictionaryFromDictionary(dictionary: catValue, key: "service_provider_detail")
                            
                            let spid = createString(value:dictSPData.value(forKey: "id") as AnyObject)
                            let spUsername = createString(value: dictSPData.value(forKey: "name") as AnyObject)
                            let spEmail = createString(value: dictSPData.value(forKey: "email") as AnyObject)
                            let spMobile = createString(value: dictSPData.value(forKey: "mobile") as AnyObject)
                            let spType = createString(value: dictSPData.value(forKey: "role") as AnyObject)
                            let spStatus = createString(value: dictSPData.value(forKey: "status") as AnyObject)
                            let spAddress = createString(value: dictSPData.value(forKey: "address") as AnyObject)
                            let spCountry = createString(value: dictSPData.value(forKey: "country") as AnyObject)
                            let spState = createString(value: dictSPData.value(forKey: "state") as AnyObject)
                            let splicenceNo = createString(value: dictSPData.value(forKey: "licence_number") as AnyObject)
                            let splicenceType = createString(value: dictSPData.value(forKey: "licence_type") as AnyObject)
                            let spsocialNo = createString(value: dictSPData.value(forKey: "social_security_number") as AnyObject)
                            let spltexId = createString(value: dictSPData.value(forKey: "tax_id") as AnyObject)
                            let splatitude = createString(value: dictSPData.value(forKey: "latitude") as AnyObject)
                            let splongitude = createString(value: dictSPData.value(forKey: "longitude") as AnyObject)
                            let sWorkingArea = createString(value: dictSPData.value(forKey: "working_area_radius") as AnyObject)
                            let arrUserService = [userService]()
                            
                            let userdate = ServiceProvider.init(id: spid, username: spUsername, email: spEmail, mobile: spMobile, type: spType, status: spStatus, address: spAddress, city: "", country: spCountry, state: spState, licenceNo: splicenceNo, licenceType: splicenceType, socialNo: spsocialNo, texId: spltexId, latitude: splatitude,longitude: splongitude, workingArea:sWorkingArea, userServices:arrUserService)
                            
                            let review = Review.init(id: id, rate: rate, review: strReview, customerProfile: cutomerdata, serviceProvider: userdate)
                            self.arrReview.append(review)
                        }
                        self.tblStricksAndReview.reloadData()
                    }
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
    
    func getStricks() {
        arrStrcks.removeAll()
        let dic = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        appDelegate.showLoadingIndicator()
        MTWebCall.call.getStricks(userId: userid, dictParam: dic) { (respons, status) in
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
                    if arrCat.count > 0 {
                        for i in 0...arrCat.count - 1 {
                            let catValue = arrCat[i] as! NSDictionary
                            
                            let id = createString(value:catValue.value(forKey: "id") as AnyObject)
                            let userId = createString(value:catValue.value(forKey: "user_id") as AnyObject)
                            let comment = createString(value:catValue.value(forKey: "comments") as AnyObject)
                            let updateDate = createString(value:catValue.value(forKey: "updated_at") as AnyObject)
                            let service = Stricks.init(id: id, userId: userId, comment: comment, updateDate: updateDate)
                            
                            self.arrStrcks.append(service)
                        }
                    }
                    self.tblStricksAndReview.reloadData()
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

// MARK: - Table view deleget
extension StricksAndReviewVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isReview {
            return arrReview.count
        } else {
            return arrStrcks.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isReview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as!  ReviewCell
            
            let Review = arrReview[indexPath.row] as Review
            cell.lblDescription.text = Review.review
            cell.lblRates.text = Review.rate
            cell.lblUserName.text = Review.cutomerProfile.username
            
            var str1 =  WebURL.ImageBaseUrl + Review.cutomerProfile.profileImg
            str1 = str1.replacingOccurrences(of: " ", with: "%20")
            cell.profileImg.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
           
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StrickCell") as!  StrickCell
            
            let strick = arrStrcks[indexPath.row] as Stricks
            cell.lblDiscription.text =  strick.comment
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: strick.updateDate)
            dateFormatter.dateFormat = "dd MMMM yyyy"
            cell.lblDate.text =  dateFormatter.string(from: date!)
            
            return cell
            
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let service = arrReqList[indexPath.row]
//        let vc = storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "CurrentReqDetailVC") as! CurrentReqDetailVC
//        vc.isFromCurrentReq = true
//        vc.requestData = service
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
}
