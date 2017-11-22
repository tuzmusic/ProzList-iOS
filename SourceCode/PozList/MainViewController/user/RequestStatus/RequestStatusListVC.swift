//
//  RequestStatusListViewController.swift
//  PozList
//
//  Created by Devubha Manek on 11/14/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class ReqStatusCell : UITableViewCell{
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    
}

class RequestStatusListVC: UIViewController , SideMenuItemContent {

    @IBOutlet var tblRequestList: UITableView!
    var arrReqList = [ServiceRequest]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getRequestStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Click_menu(_ sender: Any) {
        showSideMenu()
    }
    
    // MARK: - web service call
    
    func getRequestStatus() {
        let dict = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        appDelegate.showLoadingIndicator()
        MTWebCall.call.getRequest(userId: userid, type: "1", dictParam: dict) { (responas, status) in
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
                    
                    for i in 0...arrService.count - 1 {
                        let catValue = arrService[i] as! NSDictionary
                        
                        let id = createString(value:catValue.value(forKey: "id") as AnyObject)
                        let cId = createString(value:catValue.value(forKey: "cat_id") as AnyObject)
                        
                        let status = createString(value:catValue.value(forKey: "status") as AnyObject)
                        let reqDesc = createString(value:catValue.value(forKey: "request_desc") as AnyObject)
                        let reqDate = createString(value:catValue.value(forKey: "created_at") as AnyObject)
                        
                        var serImges = [String]()
                        let arrImages = getArrayFromDictionary(dictionary: catValue, key: "service_request_image")
                        for i in 0...arrImages.count - 1 {
                            let imgDict = arrImages[i] as! NSDictionary
                            let imgPath = createString(value:imgDict.value(forKey: "image") as AnyObject)
                            serImges.append(imgPath)
                        }
                        let serDetail = getDictionaryFromDictionary(dictionary: catValue, key: "service_category_name")
                        
                        var serviceReq:ServiceRequest!
                        
                        let cName = createString(value:serDetail.value(forKey: "name") as AnyObject)
                        if cName != "" {
                            serviceReq = ServiceRequest.init(id: id, serviceCatId: cId, serviceCatName:cName,  status: status, imagepath: serImges, serviceReqDesc: reqDesc, serviceReqDate: reqDate,customerProfile : Profile())
                        }
                        else {
                            serviceReq = ServiceRequest.init(id: id, serviceCatId: cId, serviceCatName:"", status: status, imagepath: serImges, serviceReqDesc: reqDesc, serviceReqDate: reqDate,customerProfile : Profile())
                        }
                        self.arrReqList.append(serviceReq)
                        print("data service \(catValue)")
                    }
                    self.tblRequestList.reloadData()
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

extension RequestStatusListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReqList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReqStatusCell") as!  ReqStatusCell
        
        let service = arrReqList[indexPath.row] as ServiceRequest
        cell.lbl_title.text = service.serviceCatName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: service.serviceReqDate)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        cell.lbl_date.text =  dateFormatter.string(from: date!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyBoards.Menu.instantiateViewController(withIdentifier: "CreateReqVC") as! CreateReqVC
        vc.isUserAvil = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
