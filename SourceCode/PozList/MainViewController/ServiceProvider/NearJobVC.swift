//
//  NearJobVC.swift
//  PozList
//
//  Created by Devubha Manek on 11/15/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class nearJobCell: UITableViewCell{
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_areaMilles: UILabel!
}

class NearJobVC: UIViewController {

    
    @IBOutlet var btnLeftTitle: UILabel!
    @IBOutlet var btnLeftImg: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    var isMapView:Bool!
    
    @IBOutlet var tblJobList: UITableView!
    @IBOutlet var mapview: UIView!
    var arrReqList = [ServiceRequest]()
    override func viewDidLoad() {
        super.viewDidLoad()

        isMapView = false
        mapview.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - cantainer view set up
    
    private lazy var availablejobVC: AvailablejobVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "MenuScreen", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "AvailablejobVC") as! AvailablejobVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    // MARK: - Action Event
    @IBAction func btnToMapView(_ sender: Any) {
        if !isMapView {
            add(asChildViewController: availablejobVC)
            self.updateUI()
            isMapView = true
        }
        else {
            remove(asChildViewController: availablejobVC)
            self.updateUI()
            isMapView = false
        }
    }
    
    func updateUI()  {
        if !isMapView {
            btnLeftImg.image = #imageLiteral(resourceName: "menu_icon")
            btnLeftTitle.text = "List"
            lblTitle.text = "Available Job"
        }
        else {
            btnLeftImg.image = #imageLiteral(resourceName: "location_white")
            btnLeftTitle.text = "Map"
            lblTitle.text = "Near Job"
        }
    }
}



// MARK: - web serivce call
extension NearJobVC {
    
    func getServiceList() {
        
        let dic = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        appDelegate.showLoadingIndicator()
        MTWebCall.call.getRequest(userId: userid, type: "1", dictParam: dic) { (responas, status) in
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
//                        let arrImages = getArrayFromDictionary(dictionary: catValue, key: "service_request_image")
//                        for i in 0...arrImages.count - 1 {
//                            let imgDict = arrImages[i] as! NSDictionary
//                            let imgPath = createString(value:imgDict.value(forKey: "image") as AnyObject)
//                            serImges.append(imgPath)
//                        }
                        
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
                        let cutomerdata = Profile.init(id: cid, username: username, email: email, mobile: mobile, type: type, status: cstatus, city: city)
                        
                        let cName = createString(value:serDetail.value(forKey: "name") as AnyObject)
                        if cName != "" {
                            serviceReq = ServiceRequest.init(id: id, serviceCatId: cId, serviceCatName:cName,  status: status, imagepath: serImges, serviceReqDesc: reqDesc, serviceReqDate: reqDate,customerProfile : cutomerdata)
                        }
                        else {
                            serviceReq = ServiceRequest.init(id: id, serviceCatId: cId, serviceCatName:"", status: status, imagepath: serImges, serviceReqDesc: reqDesc, serviceReqDate: reqDate,customerProfile : cutomerdata)
                        }
                        self.arrReqList.append(serviceReq)
                        print("data service \(catValue)")
                    }
                    self.tblJobList.reloadData()
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
