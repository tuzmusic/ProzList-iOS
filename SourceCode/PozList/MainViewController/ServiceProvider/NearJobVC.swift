//
//  NearJobVC.swift
//  PozList
//
//  Created by Devubha Manek on 11/15/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import GoogleMaps

class nearJobCell: UITableViewCell{
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_areaMilles: UILabel!
}

class NearJobVC: UIViewController,SideMenuItemContent {

    
    @IBOutlet var btnLeftTitle: UILabel!
    @IBOutlet var btnLeftImg: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    var isMapView:Bool!
    @IBOutlet weak var txtCount: UITextField!
    
    @IBOutlet weak var lblRadius: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet var tblJobList: UITableView!
   // @IBOutlet var mapview: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var googleMapView: GMSMapView!
    var arrReqList = [ServiceRequest]()
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var annoImage: UIImageView!
    @IBOutlet weak var annoView: UIView!
    
    @IBOutlet weak var profileViewHeight: NSLayoutConstraint!
    
    var selectedReq:ServiceRequest!
    //var gmapView:GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        isMapView = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.arrReqList.removeAll()
        self.getServiceList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func ClickMenu(_ sender: UIButton) {
        showSideMenu()
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
        if isMapView {
            // remove(asChildViewController: availablejobVC)
            mapView.isHidden = true
            tblJobList.isHidden = false
            self.updateUI()
            isMapView = false
        }
        else {
            // add(asChildViewController: availablejobVC)
            mapView.isHidden = false
            tblJobList.isHidden = true
            self.updateUI()
            isMapView = true
        }
    }
    @IBAction func reqDetailClick(_ sender: Any) {
        let vc = storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "RequestDetailVC") as! RequestDetailVC
        vc.requestData = selectedReq
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateUI()  {
        if isMapView {
            btnLeftImg.image = #imageLiteral(resourceName: "location_white")
            btnLeftTitle.text = "Map"
            lblTitle.text = "Near Job"
        }
        else {
            btnLeftImg.image = #imageLiteral(resourceName: "menu_icon")
            btnLeftTitle.text = "List"
            lblTitle.text = "Available Job"
            self.animateMapView()
        }
    }
    
    func animateMapView() {
        
        // User Location
        let userLat = CLLocationDegrees(UserDefaults.Main.string(forKey: .userLatitude))
        let userLong = CLLocationDegrees(UserDefaults.Main.string(forKey: .userLongitude))
        let userLocatoin = CLLocation.init(latitude: userLat!, longitude: userLong!)
        let camera = GMSCameraPosition.camera(withLatitude: userLocatoin.coordinate.latitude,
                                              longitude: userLocatoin.coordinate.longitude, zoom: 05.0)
        
        //let camera = GMSCameraPosition.camera(withLatitude: 20.303236,
        //                                      longitude: 56.673532, zoom: 07.0)
        // draw circle ,
        
        
        googleMapView.camera = camera
        googleMapView.isMyLocationEnabled = true
        
//        let circle = GMSCircle(position: (userLocatoin.coordinate), radius: 2500)
//        circle.map = googleMapView
//        circle.fillColor = UIColor(red:0.03, green:0.50, blue:0.11, alpha:0.2)
//        circle.strokeColor = UIColor.clear
//        googleMapView.animate(toLocation: (userLocatoin.coordinate))
         _ = GMSCameraUpdate.setTarget((userLocatoin.coordinate))
        self.delay(seconds: 0.3, completion: { () -> () in
           
            let zoomIn = GMSCameraUpdate.zoom(to: 13)
            self.googleMapView.animate(with: zoomIn)
            
        })
        
//        self.delay(seconds: 0.5, completion: { () -> () in
//
//            _ = GMSCameraUpdate.setTarget((userLocatoin.coordinate))
//            self.googleMapView.animate(toLocation: (userLocatoin.coordinate))
//
//
//        })
        
//        delay(seconds: 0.5) { () -> () in
//            let zoomOut = GMSCameraUpdate.zoom(to: 10)
//            self.googleMapView.animate(with: zoomOut)
//
//
//        }
    }
    
    func delay(seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}
// MARK: - CLLocationManager Delegate

extension NearJobVC : GMSMapViewDelegate {
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        profileViewHeight.constant = 70
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
        let userData = marker.userData as! ServiceRequest
        var str1 =  WebURL.ImageBaseUrl + userData.customerProfile.profileImg
        str1 = str1.replacingOccurrences(of: " ", with: "%20")
        imgUserProfile.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
        lblUserName.text = userData.customerProfile.username
        lblDesignation.text = userData.serviceCatName
        lblRadius.text = userData.distance + "m"
        
        selectedReq = userData
        return true
    }
    
    func addAllMarkerPoint(serviceRequest:ServiceRequest)  {
        
        let Dlat = CLLocationDegrees(serviceRequest.latitude)
        let Dlong = CLLocationDegrees(serviceRequest.longitude)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Dlat!, longitude: Dlong!)
        marker.title = ""
        marker.snippet = ""
        marker.map = googleMapView
        marker.userData = serviceRequest //["name":custName,"proImage":imgName,"designation":designation,"radius":radius]
        
        let anoView = UIView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 60))
        let anImg = UIImageView.init(frame: CGRect(x: 0, y: 0, width: anoView.frame.size.width, height: anoView.frame.size.height))
        anImg.image = #imageLiteral(resourceName: "AnnotationIcon")
        anoView.addSubview(anImg)
        let imgProfile = UIImageView()
        imgProfile.image = #imageLiteral(resourceName: "user")
        imgProfile.contentMode = .scaleAspectFit
        imgProfile.backgroundColor = UIColor.white
        anoView.addSubview(imgProfile)
        marker.iconView = anoView
        var str1 =  WebURL.ImageBaseUrl + serviceRequest.customerProfile.profileImg
        str1 = str1.replacingOccurrences(of: " ", with: "%20")
        //print("customer name : \(custName)")
        //print("profile image : \(str1)")
        imgProfile.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
        
//        imgProfile.bringSubview(toFront: annoImage)
        
        imgProfile.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: imgProfile, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: anImg, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: imgProfile, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: anImg, attribute: NSLayoutAttribute.centerY, multiplier: 0.7, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: imgProfile, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 32)
        let heightConstraint = NSLayoutConstraint(item: imgProfile, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 32)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        imgProfile.setNeedsLayout()
        imgProfile.layoutIfNeeded()
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
        imgProfile.clipsToBounds = true
    }
    
}

// MARK: - web serivce call
extension NearJobVC {
    
    func getServiceList() {
        
        var dic = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        dic["user_id"] = userid
        let userLat = UserDefaults.Main.string(forKey: .userLatitude)
        let userLong = UserDefaults.Main.string(forKey: .userLongitude)
        dic["latitude"] = userLat
        dic["longitude"] = userLong
        appDelegate.showLoadingIndicator()
        MTWebCall.call.getNearByJob(userId: userid, dictParam: dic) { (responas, status) in
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
                            //let serDetail = getDictionaryFromDictionary(dictionary: catValue, key: "service_category_name")
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
                            let cutomerdata = Profile.init(id: cid, username: username, email: email, mobile: mobile, type: type, status: cstatus, city: city,profileImg: profileImg)
                            
                            let cName = createString(value:catValue.value(forKey: "name") as AnyObject)
                            if cName != "" {
                                serviceReq = ServiceRequest.init(id: id, serviceCatId: cId, serviceCatName:cName,  status: status, imagepath: serImges, serviceReqDesc: reqDesc, serviceReqDate: reqDate,latitude:lat,longitude:lng ,distance : distance ,address : address ,customerProfile : cutomerdata)
                            }
                            else {
                                serviceReq = ServiceRequest.init(id: id, serviceCatId: cId, serviceCatName:"", status: status, imagepath: serImges, serviceReqDesc: reqDesc, serviceReqDate: reqDate,latitude:lat,longitude:lng , distance : distance,address : address ,customerProfile : cutomerdata)
                            }
                            
                            self.addAllMarkerPoint(serviceRequest: serviceReq)
                            // self.addAllMarkerPoint(lat: lat, long: lng, imgName: profileImg ,custName: username ,designation: cName ,radius: "")
                            self.arrReqList.append(serviceReq)
                        }
                        self.tblJobList.reloadData()
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

extension NearJobVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReqList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nearJobCell") as!  nearJobCell
        
        let service = arrReqList[indexPath.row] as ServiceRequest
        cell.lbl_title.text = service.serviceCatName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: service.serviceReqDate)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        cell.lbl_date.text =  dateFormatter.string(from: date!)
        cell.lbl_areaMilles.text = service.distance + "m"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = arrReqList[indexPath.row] as ServiceRequest
        let vc = storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "RequestDetailVC") as! RequestDetailVC
        //vc.items = Int(txtCount.text!)
        vc.requestData = service
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

