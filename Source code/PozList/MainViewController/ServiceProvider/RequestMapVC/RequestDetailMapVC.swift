//
//  RequestDetailMapVC.swift
//  PozList
//
//  Created by Devubha Manek on 3/5/18.
//  Copyright © 2018 Devubha Manek. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire


class RequestDetailMapVC: UIViewController {

    //MARK: - IBOutlet declaration
    
    @IBOutlet weak var profileViHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var mapVi: GMSMapView!
    var requestData:ServiceRequest!
    var selectedReq:ServiceRequest!
    
    var observationForLong:NSKeyValueObservation!
    var observationForLatitude:NSKeyValueObservation!
    
    //MARK: - Variable declaration
    
    //MARK: - Initial view
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUserName.text = requestData.serviceCatName
        lblDistance.text = requestData.distance
        
        //Animte map view
        animateMapView()
        
        self.addAllMarkerPoint(serviceRequest: requestData)
        
        observationForLong = appDelegate.updatedLocation.observe(\LocationCoordinate.strLongitude, options: [.new], changeHandler: { (coordinateObj, updatedValue) in
            
            if let newValue = updatedValue.newValue{
                print(newValue)
                
                //Animate Map to change location pin
               // self.animateMapView()
                
                //Call API to update location
                self.updateLocationAPI()
            }
        })
        
//        observationForLatitude = appDelegate.updatedLocation.observe(\LocationCoordinate.strLongitude, options: [.new], changeHandler: { (coordinateObj, updatedValue) in
//
//            if let newValue = updatedValue.newValue{
//                print(newValue)
//
//                //Animate Map to change location pin
//                self.animateMapView()
//
//                //Call API to update location
//                self.updateLocationAPI()
//            }
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func animateMapView() {
        
        // User Location
        let userLat = CLLocationDegrees(UserDefaults.Main.string(forKey: .userLatitude))
        let userLong = CLLocationDegrees(UserDefaults.Main.string(forKey: .userLongitude))
        let userLocatoin = CLLocation.init(latitude: userLat!, longitude: userLong!)
        let camera = GMSCameraPosition.camera(withLatitude: userLocatoin.coordinate.latitude,
                                              longitude: userLocatoin.coordinate.longitude, zoom: 05.0)
        
        mapVi.camera = camera
        mapVi.isMyLocationEnabled = true
        
        _ = GMSCameraUpdate.setTarget((userLocatoin.coordinate))
        self.delay(seconds: 0.3, completion: { () -> () in
            
            let zoomIn = GMSCameraUpdate.zoom(to: 13)
            self.mapVi.animate(with: zoomIn)
            
        })
        
    }
    func delay(seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    deinit {
        observationForLong.invalidate()
        observationForLatitude.invalidate()
    }
}
//MARK: - IBAction method
extension RequestDetailMapVC{
    
    //Click to back screen
    @IBAction func btnBackTapped(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - CLLocationManager Delegate

extension RequestDetailMapVC : GMSMapViewDelegate {
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        profileViHeightConstant.constant = 70
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
        let userData = marker.userData as! ServiceRequest
        var str1 =  WebURL.ImageBaseUrl + userData.customerProfile.profileImg
        str1 = str1.replacingOccurrences(of: " ", with: "%20")
        imgUserProfile.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
        lblUserName.text = userData.customerProfile.username
        lblDesignation.text = userData.serviceCatName
        lblDistance.text = userData.distance + "m"
        
        selectedReq = userData
        return true
    }
    
    func addAllMarkerPoint(serviceRequest:ServiceRequest) {
        
        let Dlat = CLLocationDegrees(serviceRequest.latitude)
        let Dlong = CLLocationDegrees(serviceRequest.longitude)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Dlat!, longitude: Dlong!)
        marker.title = ""
        marker.snippet = ""
        marker.map = mapVi
        marker.userData = serviceRequest //["name":custName,"proImage":imgName,"designation":designation,"radius":radius]
        
        
        drawPath()
        
//        let userLat = CLLocationDegrees(UserDefaults.Main.string(forKey: .userLatitude))
//        let userLong = CLLocationDegrees(UserDefaults.Main.string(forKey: .userLongitude))
        
        /*let path = GMSMutablePath()
        path.add(CLLocationCoordinate2DMake(CDouble(serviceRequest.latitude)!, CDouble(serviceRequest.longitude)!))
        path.add(CLLocationCoordinate2DMake(CDouble(UserDefaults.Main.string(forKey: .userLatitude))!, CDouble(UserDefaults.Main.string(forKey: .userLongitude))!))
        let rectangle = GMSPolyline.init(path: path)
        rectangle.strokeWidth = 2.0
        rectangle.map = mapVi
       // self.view = mapView*/
        
        
        let anoView = UIView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 60))
        let anImg = UIImageView.init(frame: CGRect(x: 0, y: 0, width: anoView.frame.size.width, height: anoView.frame.size.height))
        anImg.image = #imageLiteral(resourceName: "AnnotationIcon")
        anoView.addSubview(anImg)
        let imgProfile = UIImageView()
        imgProfile.image = #imageLiteral(resourceName: "user")
        imgProfile.contentMode = .scaleToFill
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
    
    
    func drawPath()
    {
        let origin = "\(CDouble(UserDefaults.Main.string(forKey: .userLatitude))!),\(CDouble(UserDefaults.Main.string(forKey: .userLongitude))!)"
        let destination = "\(CDouble(requestData.latitude)!),\(CDouble(requestData.longitude)!)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&sensor=false&alternatives=true&mode=driving"
        
        var startPoint = CLLocationCoordinate2D()
        var endPoint = CLLocationCoordinate2D()
        startPoint.latitude = (CDouble(UserDefaults.Main.string(forKey: .userLatitude))!)
        startPoint.longitude = (CDouble(UserDefaults.Main.string(forKey: .userLongitude))!)
        
        endPoint.latitude = (CDouble(requestData.latitude)!)
        endPoint.longitude = (CDouble(requestData.longitude)!)
        
        Alamofire.request(url).responseJSON { (response) in
            
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "status") as! String
                    if success == "OK"
                    {
                        if let dataArr:NSArray = JSON.object(forKey: "routes") as? NSArray
                        {
//                            for i in 0..<dataArr.count
//                            {
                                let dic = dataArr.object(at: dataArr.count-1) as! NSDictionary
                                let overlayPolyline = dic.object(forKey: "overview_polyline") as! NSDictionary
                                let point = createString(value: overlayPolyline.object(forKey: "points") as AnyObject)
                                let path = GMSPath.init(fromEncodedPath: point)
                                let polyline = GMSPolyline.init(path: path)
                                polyline.strokeWidth = 5.0
                                polyline.geodesic = true
                               // polyline.strokeColor = .blue
                                polyline.geodesic = true
                                polyline.map = self.mapVi
//                                if i == 1{
                                    polyline.strokeColor = .blue
//                                }
//                            }
                            
                           
                            let bounds = GMSCoordinateBounds(coordinate: startPoint, coordinate: endPoint)
                            self.mapVi.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                            
                            
                        }
                        else{
                          //  self.view.makeToast("Could not retrive routes, please retry")
//                            self.clearRoute()
                        }
                    }
                    else{
                       // self.view.makeToast("Could not retrive routes, please retry")
//                        self.clearRoute()
                    }
                }
                else{
                  //  self.view.makeToast("Could not retrive routes, please retry")
//                    self.clearRoute()
                }
            case .failure(let error):
                print(error)
               // self.alert(message: error.localizedDescription)
                break
            }
        }
    }
    
    
    /*func drawPath()
    {
        let reach = Reachability.init()
        if reach.currentReachabilityStatus() == false{
            self.alert(message: "The network connection was lost.")
            return
        }
        
        let origin = "\(startPoint.latitude),\(startPoint.longitude)"
        let destination = "\(endPoint.latitude),\(endPoint.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&alternatives=true&key=AIzaSyB_ZHYKjHIDLFg8kVszyWicj3xear4TBZI"
        
        Alamofire.request(url).responseJSON { (response) in
            
            switch response.result
            {
            case .success:
                if let JSON:NSDictionary = response.result.value as? NSDictionary
                {
                    let success = JSON.object(forKey: "status") as! String
                    if success == "OK"
                    {
                        if let dataArr:NSArray = JSON.object(forKey: "routes") as? NSArray
                        {
                            for i in 0..<dataArr.count
                            {
                                let dic = dataArr.object(at: i) as! NSDictionary
                                
                                if let legs:NSArray = dic.object(forKey: "legs") as? NSArray
                                {
                                    let legsdic = legs.object(at: 0) as! NSDictionary
                                    let distance = legsdic.object(forKey: "distance") as! NSDictionary
                                    let duration = legsdic.object(forKey: "duration") as! NSDictionary
                                    
                                    if i == 0
                                    {
                                        self.viewRed.isHidden = false
                                        self.lblRedBoxText.isHidden = false
                                        self.lblRedBoxText.text = String.init(format: "%@, %@", distance.object(forKey: "text") as! CVarArg,duration.object(forKey: "text") as! CVarArg)
                                    }
                                    else if i == 1
                                    {
                                        self.viewBlue.isHidden = false
                                        self.lblBlueBoxText.isHidden = false
                                        self.lblBlueBoxText.text = String.init(format: "%@, %@", distance.object(forKey: "text") as! CVarArg,duration.object(forKey: "text") as! CVarArg)
                                    }
                                    else
                                    {
                                        self.viewYellow.isHidden = false
                                        self.lblYelloBoxText.isHidden = false
                                        self.lblYelloBoxText.text = String.init(format: "%@, %@", distance.object(forKey: "text") as! CVarArg,duration.object(forKey: "text") as! CVarArg)
                                    }
                                }
                                
                                let overlayPolyline = dic.object(forKey: "overview_polyline") as! NSDictionary
                                let point = createString(value: overlayPolyline.object(forKey: "points") as AnyObject)
                                let path = GMSPath.init(fromEncodedPath: point)
                                let polyline = GMSPolyline.init(path: path)
                                polyline.strokeWidth = 3.0
                                polyline.geodesic = true
                                
                                if i == 0
                                {
                                    polyline.strokeColor = .red
                                }
                                else if i == 1
                                {
                                    polyline.strokeColor = .blue
                                }
                                else
                                {
                                    polyline.strokeColor = .yellow
                                }
                                polyline.map = self.viewMap
                            }
                            
                            let bounds = GMSCoordinateBounds(coordinate: self.startPoint, coordinate: self.endPoint)
                            self.viewMap.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                            
                            let showGoogleMap = createString(value: UserDefaults.standard.object(forKey: UserDefaultsKey.showGoogleMap) as AnyObject)
                            if showGoogleMap != "YES"
                            {
                                self.routePopupType = true
                                self.lblRoutePopupTitle.text = "Show on Google Maps"
                                self.lblRoutePopupSubTitle.text = "Touch a route to open it on Google Maps."
                                self.imgCheckBoxRoutePopup.image = UIImage.init(named: "checkboxUnSelect")
                                
                                self.viewHeaderSearch.alpha = 0.0
                                self.viewHeaderDate.alpha = 1.0
                                self.viewPopupRoutes.alpha = 1.0
                                self.viewSavedRoutes.alpha = 0
                                self.viewNameOfRoute.alpha = 0
                                self.viewClearNReset.alpha = 0
                                
                                UIView.animate(withDuration: 0.5) {
                                    self.viewPopupBG.alpha = 1.0
                                }
                            }
                        }
                        else{
                            self.view.makeToast("Could not retrive routes, please retry")
                            self.clearRoute()
                        }
                    }
                    else{
                        self.view.makeToast("Could not retrive routes, please retry")
                        self.clearRoute()
                    }
                }
                else{
                    self.view.makeToast("Could not retrive routes, please retry")
                    self.clearRoute()
                }
            case .failure(let error):
                print(error)
                self.alert(message: error.localizedDescription)
                break
            }
        }
    }*/
}


// MARK: - Webservice call

extension RequestDetailMapVC {
    
    func updateLocationAPI() {
        
        var dic = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        dic["user_id"] = userid
        dic["latitude"] = UserDefaults.Main.string(forKey: .userLatitude)
        dic["longtitude"] = UserDefaults.Main.string(forKey: .userLongitude)
        
//        request_id (pass if we want to get user updated location)
        
        MTWebCall.call.updateLocationAPI(dictParam: dic) { (respons, status) in
            appDelegate.hideLoadingIndicator()
            jprint(items: status)
            if (status == 200 && respons != nil) {
                //Response
                let dictResponse = respons as! NSDictionary
                
                let Response = getStringFromDictionary(dictionary: dictResponse, key: "response")
                if Response == "true"
                {
                    //Message
                    let message = getStringFromDictionary(dictionary: dictResponse, key: "msg")
                    print(message)
                    
                    let dictData = getDictionaryFromDictionary(dictionary: dictResponse, key: "data")
                    print(dictData)
                    
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
