//
//  CurrentRequestVC.swift
//  PozList
//
//  Created on 11/29/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class CurrentReqCell : UITableViewCell{
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_radius: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
}

class CurrentRequestVC: UIViewController {

    @IBOutlet var tblRequestList: UITableView!
    var arrReqList = [ServiceRequest]()
    @IBOutlet weak var lblNoRequestFound: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrReqList.removeAll()
        self.getRequestList()
    }
    
    @IBAction func ClickMenu(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    // MARK: - web service call
    
    func getRequestList() {
        let dict = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        appDelegate.showLoadingIndicator()
        MTWebCall.call.getCurrentServiceReq(userId: userid,type: "1", dictParam: dict) { (responas, status) in
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
                            let cId = createString(value:catValue.value(forKey: "cat_id") as AnyObject)
                            let transactionId = createString(value:catValue.value(forKey: "transaction_id") as AnyObject)
                            let status = createString(value:catValue.value(forKey: "status") as AnyObject)
                            let userServiceStatus = createString(value:catValue.value(forKey: "user_service_status") as AnyObject)
                            let reqDesc = createString(value:catValue.value(forKey: "request_desc") as AnyObject)
                            let reqDate = createString(value:catValue.value(forKey: "created_at") as AnyObject)
                            let reqUpdateDate = createString(value:catValue.value(forKey: "updated_at") as AnyObject)
                            let lat = createString(value:catValue.value(forKey: "lat") as AnyObject)
                            let lng = createString(value:catValue.value(forKey: "lng") as AnyObject)
                            let distance = createFloatToString(value:catValue.value(forKey: "distance") as AnyObject)
                            let address = createString(value:catValue.value(forKey: "address") as AnyObject)
                            
                            var serImges = [String]()
                            let arrImages = getArrayFromDictionary(dictionary: catValue, key: "service_request_image")
                            if arrImages.count > 0 {
                                for i in 0...arrImages.count - 1 {
                                    let imgDict = arrImages[i] as! NSDictionary
                                    let imgPath = createString(value:imgDict.value(forKey: "image") as AnyObject)
                                    serImges.append(imgPath)
                                }
                            }
                            
                            let serDetail = getDictionaryFromDictionary(dictionary: catValue, key: "service_category_name")
                            var serviceReq:ServiceRequest!
                            
                            let dictData = getDictionaryFromDictionary(dictionary: catValue, key: "service_customer_detail")
                            let cid = createString(value:dictData.value(forKey: "id") as AnyObject)
                            let username = createString(value: dictData.value(forKey: "name") as AnyObject)
                            let email = createString(value: dictData.value(forKey: "email") as AnyObject)
                            let mobile = createString(value: dictData.value(forKey: "phone") as AnyObject)
                            let type = createString(value: dictData.value(forKey: "role") as AnyObject)
                            let cstatus = createString(value: dictData.value(forKey: "status") as AnyObject)
                            let city = createString(value: dictData.value(forKey: "status") as AnyObject)
                            let profileImg = createString(value: dictData.value(forKey: "profile_pic") as AnyObject)
                            let avgRating = dictData.getString(key: "avg_rating")
                            
                            let cutomerdata = Profile.init(id: cid, username: username, email: email, mobile: mobile, type: type, status: cstatus, city: city,profileImg: profileImg, avgRating: avgRating)
                            
                            //Review & Rating
                            let reviewRatingObj = RatingNReview.init(id: "",
                                                                     serviceRequestId: "",
                                                                     customerId: "",
                                                                     serviceProviderId: "",
                                                                     rating: "",
                                                                     review: "",
                                                                     reviewFrom: "",
                                                                     createdAt: "",
                                                                     updated_at: "")
                            
                            // let arrayOfRating = getArrayFromDictionary(dictionary: catValue, key: "rating")
                            let arrayOfRating = catValue.getArray(key: "rating")
                            
                            for counter in 0..<arrayOfRating.count{
                                let dictRating = arrayOfRating[counter] as! NSDictionary
                                if let reviewFrom = dictRating["review_from"], reviewFrom as! String == "Customer"{
                                    reviewRatingObj.id = dictRating.getString(key: "id")
                                    reviewRatingObj.serviceRequestId = dictRating.getString(key: "service_request_id")
                                    reviewRatingObj.customerId = dictRating.getString(key: "customer_id")
                                    reviewRatingObj.serviceProviderId = dictRating.getString(key: "service_provider_id")
                                    reviewRatingObj.rating = dictRating.getString(key: "rating")
                                    reviewRatingObj.review = dictRating.getString(key: "review")
                                    reviewRatingObj.reviewFrom = dictRating.getString(key: "review_from")
                                    reviewRatingObj.createdAt = dictRating.getString(key: "created_at")
                                    reviewRatingObj.updated_at = dictRating.getString(key: "updated_at")
                                    break
                                }
                            }
                            
                            let cName = createString(value: serDetail.value(forKey: "name") as AnyObject)
                            if cName != "" {
                                serviceReq = ServiceRequest.init(id: id, serviceCatId: cId, transactionId: transactionId, serviceCatName:cName,  status: status, userServiceStatus:userServiceStatus,  imagepath: serImges, serviceReqDesc: reqDesc, serviceReqDate: reqDate, serviceReqUpdateDate: reqUpdateDate,latitude:lat,longitude:lng ,distance : distance ,address : address ,customerProfile : cutomerdata, serviceProvider : ServiceProvider(), ratingNReviewObj:reviewRatingObj)
                            }
                            else {
                                serviceReq = ServiceRequest.init(id: id, serviceCatId: cId, transactionId: transactionId, serviceCatName:"", status: status, userServiceStatus:userServiceStatus, imagepath: serImges, serviceReqDesc: reqDesc, serviceReqDate: reqDate, serviceReqUpdateDate: reqUpdateDate,latitude:lat,longitude:lng , distance : distance,address : address ,customerProfile : cutomerdata, serviceProvider : ServiceProvider(), ratingNReviewObj:reviewRatingObj)
                            }
                            
                            self.arrReqList.append(serviceReq)
                        }
                    }
                    self.tblRequestList.reloadData()
                    
                    //Set no request found label
                    if self.arrReqList.count == 0{
                        self.lblNoRequestFound.text = "No new Jobs found!"
                        self.lblNoRequestFound.isHidden = false
                    }else{
                        self.lblNoRequestFound.isHidden = true
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
}

// MARK: - Table view deleget
extension CurrentRequestVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReqList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentReqCell") as!  CurrentReqCell
        
        let service = arrReqList[indexPath.row] as ServiceRequest
        cell.lbl_title.text = service.serviceCatName
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: NSLocale.current.identifier)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: service.serviceReqDate)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        cell.lbl_date.text =  dateFormatter.string(from: date!)
        cell.lblAddress.text = service.address
        if service.distance == "" {
            cell.lbl_radius.text = "0.00m"
        } else {
            cell.lbl_radius.text = service.distance + "m"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = arrReqList[indexPath.row]
        let vc = storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "CurrentReqDetailVC") as! CurrentReqDetailVC
        vc.isFromCurrentReq = true
        vc.requestData = service
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
