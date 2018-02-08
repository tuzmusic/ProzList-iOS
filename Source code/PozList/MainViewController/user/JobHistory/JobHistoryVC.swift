//
//  JobHistoryVC.swift
//  PozList
//
//  Created by Devubha Manek on 04/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

class JobHistoryCell : UITableViewCell{
    
    
    @IBOutlet weak var view_back_icon: UIView!
    @IBOutlet weak var img_stauts: UIImageView!
    @IBOutlet weak var view_compl: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_complete: UILabel!
    @IBOutlet weak var lbl_sub_title: UILabel!
    
}

import UIKit


class JobHistoryVC: UIViewController {
    
    @IBOutlet var tblJobHistoryList: UITableView!
    
    var arrJobHistory = [ServiceRequest]()
    
    var serviceReq:ServiceRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Click_menu(_ sender: Any) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrJobHistory.removeAll()
        self.getJobHistory()
    }
    
    func getJobHistory() {
        let dict = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        appDelegate.showLoadingIndicator()
        MTWebCall.call.getRequest(userId: userid, type: "2", dictParam: dict) { (responas, status) in
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
                            
                            let status = createString(value:catValue.value(forKey: "status") as AnyObject)
                            let reqDesc = createString(value:catValue.value(forKey: "request_desc") as AnyObject)
                            let reqDate = createString(value:catValue.value(forKey: "created_at") as AnyObject)
                            let reqUpdateDate = createString(value:catValue.value(forKey: "updated_at") as AnyObject)
                            let lat = createString(value:catValue.value(forKey: "lat") as AnyObject)
                            let lng = createString(value:catValue.value(forKey: "lng") as AnyObject)
                            let distance = createFloatToString(value:catValue.value(forKey: "distance") as AnyObject)
                            let address = createString(value:catValue.value(forKey: "lng") as AnyObject)
                            
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
                            
                            let dictData = getDictionaryFromDictionary(dictionary: catValue, key: "service_provider_detail")
                            
                            let spid = createString(value:dictData.value(forKey: "id") as AnyObject)
                            let spUsername = createString(value: dictData.value(forKey: "name") as AnyObject)
                            let spEmail = createString(value: dictData.value(forKey: "email") as AnyObject)
                            let spMobile = createString(value: dictData.value(forKey: "mobile") as AnyObject)
                            let spType = createString(value: dictData.value(forKey: "role") as AnyObject)
                            let spStatus = createString(value: dictData.value(forKey: "status") as AnyObject)
                            let spAddress = createString(value: dictData.value(forKey: "address") as AnyObject)
                            let spCountry = createString(value: dictData.value(forKey: "country") as AnyObject)
                            let spState = createString(value: dictData.value(forKey: "state") as AnyObject)
                            let splicenceNo = createString(value: dictData.value(forKey: "licence_number") as AnyObject)
                            let splicenceType = createString(value: dictData.value(forKey: "licence_type") as AnyObject)
                            let spsocialNo = createString(value: dictData.value(forKey: "social_security_number") as AnyObject)
                            let spltexId = createString(value: dictData.value(forKey: "tax_id") as AnyObject)
                            let splatitude = createString(value: dictData.value(forKey: "latitude") as AnyObject)
                            let splongitude = createString(value: dictData.value(forKey: "longitude") as AnyObject)
                            let sWorkingArea = createString(value: dictData.value(forKey: "working_area_radius") as AnyObject)
                            let spAvgRating = createFloatToString(value: dictData.value(forKey: "avg_rating") as AnyObject)
                            let spProfilePic = createString(value: dictData.value(forKey: "profile_pic") as AnyObject)
                            var arrUserService = [userService]()
                            
                            let arrService = getArrayFromDictionary(dictionary: dictData, key: "service_json")
                            if arrService.count > 0 {
                                
                                for i in 0...arrService.count - 1 {
                                    
                                    let catValue = arrService[i] as! NSDictionary
                                    
                                    let serviceId = createString(value:catValue.value(forKey: "service_id") as AnyObject)
                                    let prize = createString(value: catValue.value(forKey: "price") as AnyObject)
                                    let discount = createString(value: catValue.value(forKey: "discount") as AnyObject)
                                    let serviceName = createString(value: catValue.value(forKey: "name") as AnyObject)
                                    let status = "" //createString(value: catValue.value(forKey: "status") as AnyObject)
                                    
                                    let userServic = userService.init(serviceId: serviceId, prize: prize, discount: discount, serviceName: serviceName, status: status)
                                    
                                    arrUserService.append(userServic)
                                }
                            }
                            
                            let userdate = ServiceProvider.init(id: spid, username: spUsername, email: spEmail, mobile: spMobile, type: spType, status: spStatus, address: spAddress, city: "", country: spCountry, state: spState, licenceNo: splicenceNo, licenceType: splicenceType, socialNo: spsocialNo, texId: spltexId, latitude: splatitude,longitude: splongitude, workingArea:sWorkingArea, avgRating:spAvgRating, profilePic: spProfilePic, userServices:arrUserService)
                            
                            let cName = createString(value:serDetail.value(forKey: "name") as AnyObject)
                            if cName != "" {
                                self.serviceReq = ServiceRequest.init(id: id, serviceCatId: cId, serviceCatName:cName,  status: status, imagepath: serImges, serviceReqDesc: reqDesc, serviceReqDate: reqDate, serviceReqUpdateDate: reqUpdateDate, latitude:lat, longitude:lng , distance : distance , address : address ,customerProfile : Profile() ,serviceProvider : userdate)
                            }
                            else {
                                self.serviceReq = ServiceRequest.init(id: id, serviceCatId: cId, serviceCatName:cName,  status: status, imagepath: serImges, serviceReqDesc: reqDesc, serviceReqDate: reqDate, serviceReqUpdateDate: reqUpdateDate, latitude:lat, longitude:lng , distance : distance ,address : address , customerProfile : Profile() ,serviceProvider : userdate)
                            }
                            self.arrJobHistory.append(self.serviceReq)
                            print("data service \(catValue)")
                        }
                        self.tblJobHistoryList.reloadData()
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
extension JobHistoryVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrJobHistory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobHistoryCell") as!  JobHistoryCell
        
        let service = arrJobHistory[indexPath.row] as ServiceRequest
        
        if service.status == "Completed" {
            cell.view_compl.backgroundColor = UIColor.appGreen()
            cell.view_back_icon.backgroundColor = UIColor.appGreen()
            cell.img_stauts.image = #imageLiteral(resourceName: "completed")
            cell.lbl_complete.text = "COMPLETED"
        } else {
            cell.view_compl.backgroundColor = UIColor.red
            cell.view_back_icon.backgroundColor = UIColor.red
            cell.img_stauts.image = #imageLiteral(resourceName: "completed_not")
            cell.lbl_complete.text = "NOT COMPLETED"
        }
        
        cell.lbl_title.text = service.serviceCatName
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: NSLocale.current.identifier)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: service.serviceReqDate)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        cell.lbl_sub_title.text =  dateFormatter.string(from: date!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyBoards.Customer.instantiateViewController(withIdentifier: "JobProfileVC") as! JobProfileVC
        
        let service = arrJobHistory[indexPath.row] as ServiceRequest
        vc.requestData = service
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}