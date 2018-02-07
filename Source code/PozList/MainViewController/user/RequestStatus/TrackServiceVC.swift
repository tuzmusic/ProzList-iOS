//
//  TrackServiceVC.swift
//  PozList
//
//  Created by Devubha Manek on 05/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class TrackServiceVC: UIViewController,GMSMapViewDelegate {
    
    //Mapview data show
    var GmapView: GMSMapView!
    
    var GmapUserMark: GMSMarker!
    var GmapDiverMark: GMSMarker!
    var GmapShoprmarker: GMSMarker!
    var GmapDrliverMark: GMSMarker!
    
    var usrPosition =  CLLocationCoordinate2D()
    var ShopPosition =  CLLocationCoordinate2D()
    var DeliverPosition =  CLLocationCoordinate2D()

    @IBOutlet weak var MapView: UIView!
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!    
    @IBOutlet weak var lbl_ServiceType: UILabel!

    @IBOutlet weak var lblRemainTime: UILabel!
    
    var providerRequestData:ServiceRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.MapView.layoutIfNeeded()

    
        // Create a GMSCameraPosition that tells the map to display the
        let camera = GMSCameraPosition.camera(withLatitude: 23, longitude: 72, zoom: 11.0)
        GmapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.MapView.frame.size.width , height: self.MapView.frame.size.height), camera: camera)
        
      //  let location = UserDefaults.Main.object(forKey: .driverLocation) as! NSDictionary
     //   if location != nil{
            
            let lat = 23.033863
            let lon = 72.585022
        
//        let lat = Double(providerRequestData.serviceProviderProfile.latitude)
//        let lon = Double(providerRequestData.serviceProviderProfile.longitude)
        
        let position = CLLocationCoordinate2D(latitude:CLLocationDegrees(lat) , longitude: CLLocationDegrees(lon))
            let camera_google :GMSCameraPosition  = GMSCameraPosition.camera(withTarget: position, zoom: 12.0)
            self.GmapView.animate(to: camera_google)
        
       // }
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        marker.map = GmapView

        
       // 23.0265° N, 72.5609° E
        
        self.MapView.addSubview(GmapView)
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "googleMapsStyle", withExtension: "json") {
                GmapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        GmapView.delegate = self
        let position1 = CLLocationCoordinate2D(latitude:CLLocationDegrees(lat) , longitude: CLLocationDegrees(lon))
//        let position2 = CLLocationCoordinate2D(latitude:CLLocationDegrees(UserDefaults.Main.string(forKey: .userLatitude))! , longitude: CLLocationDegrees(UserDefaults.Main.string(forKey: .userLongitude))!)
        let position2 = CLLocationCoordinate2D(latitude:CLLocationDegrees(23.0265) , longitude: CLLocationDegrees(72.5609))
        getPolylineRoute(from: position1, to:position2)
        
        var str1 =  WebURL.ImageBaseUrl + providerRequestData.serviceProviderProfile.profilePic
        str1 = str1.replacingOccurrences(of: " ", with: "%20")
        imgProfilePic.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
        
        self.lblUserName.text = providerRequestData.serviceProviderProfile.username.capitalized
        self.lbl_ServiceType.text = providerRequestData.serviceCatName
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Click_bak(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                do {
                    if let  json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        let routes = json["routes"] as? [Any]
                        if let dataArr:NSArray = creatArray(value: json["routes"] as AnyObject )
                        {
                            let dict = creatDictnory(value: dataArr[0] as AnyObject)
                            let overlayPolyline = creatDictnory(value: dict["overview_polyline"] as AnyObject)
                            print(overlayPolyline)
                            let point = createString(value: overlayPolyline.object(forKey: "points") as AnyObject)
                            print(point)
                            
                            let path = GMSPath.init(fromEncodedPath: point)
                            
                            DispatchQueue.main.async {
                                let polyline = GMSPolyline.init(path: path)
                                polyline.strokeWidth = 2.0
                                polyline.geodesic = true
                                polyline.strokeColor = .orange
                                polyline.map = self.GmapView
                            }
                            
                        }
                    }
                }catch{
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }

}
//extension TrackServiceVC{
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//
//
//        if (self.mapView.selectedMarker?.iconView?.isKind(of: MarkerSmallView.self))!{
//                let marker  = self.mapView.selectedMarker?.iconView as! MarkerSmallView
//                self.ChangesAnimation_icon(text: marker.title.text!)
//            }else if(self.mapView.selectedMarker?.iconView?.isKind(of: MarkerView.self))!{
//                let marker  = self.mapView.selectedMarker?.iconView as! MarkerView
//                self.ChangesAnimation_icon(text: marker.lbl_title.text!)
//            }
//
//        }
//
//
//        // GmapUserMark.iconView = myCustomView
//        let view = UIView()
//        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//        return view
//    }
//
//
//
//    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//
//        UIView.animate(withDuration: 5.0, animations: { () -> Void in
//
//        }, completion: {(finished) in
//            // Stop tracking view changes to allow CPU to idle.
//        })
//
//    }
//}
//extension TrackServiceVC{
//
//    func drawPath(origin:String,Destination:String)
//    {
////        if (self.appDelegate.manager?.isReachable)! == false
////        {
////            self.alert(message: "The network connection was lost.")
////            return
////        }
//
//
//
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(Destination)&mode=driving&key=AIzaSyB_ZHYKjHIDLFg8kVszyWicj3xear4TBZI"
//
//        Alamofire.request(url).responseJSON { (response) in
//
//            switch response.result
//            {
//            case .success:
//                if let JSON:NSDictionary = response.result.value as? NSDictionary
//                {
//                    let success = JSON.object(forKey: "status") as! String
//                    if success == "OK"
//                    {
//                        if let dataArr:NSArray = JSON.object(forKey: "routes") as? NSArray
//                        {
//                            print(dataArr)
//
//                            self.GmapView.clear()
//
//                            self.CheckProductInfoCurrent { (current_Order_Info ) in
//
//
//
//                                let destination = current_Order_Info.driver_latitude + "," + current_Order_Info.driver_longitude
//                                let origin = current_Order_Info.delivery_latitude + "," + current_Order_Info.delivery_longitude
//
//                                self.driverPath(origin:origin , destination: destination)
//                            }
//
//
//
//                            let dic = dataArr.object(at: 0) as! NSDictionary
//                            print(dic)
//
//                            if let legs:NSArray = dic.object(forKey: "legs") as? NSArray
//                            {
//                                print(legs)
//
//                                let legsdic = legs.object(at: 0) as! NSDictionary
//                                print(legsdic)
//
//
//                                let start_location = legsdic.object(forKey: "start_location") as! NSDictionary
//                                print(start_location)
//
//                                let myCustomView: MarkerSmallView = .instanceFromNibSmall(Marker_image: #imageLiteral(resourceName: "DriverMarkerWeed"), Window_image: #imageLiteral(resourceName: "DriverWindow"), MakerTitle: "", Window_title: "You")
//
//                                let positionstart = CLLocationCoordinate2D(latitude: start_location.object(forKey: "lat") as! CLLocationDegrees, longitude: start_location.object(forKey: "lng") as! CLLocationDegrees)
//                                self.usrPosition = positionstart
//                                self.GmapDiverMark = GMSMarker(position: positionstart)
//                                self.GmapDiverMark.iconView = myCustomView
//                                self.GmapDiverMark.tracksViewChanges = true
//                                self.GmapDiverMark.map = self.GmapView
//
//
//
//
//
//
//                                let end_location = legsdic.object(forKey: "end_location") as! NSDictionary
//                                print(end_location)
//
//                                let myCustomView1: MarkerSmallView = .instanceFromNibSmall(Marker_image: #imageLiteral(resourceName: "ShopMarkerWeed"), Window_image:  #imageLiteral(resourceName: "ShopWindow"), MakerTitle: "", Window_title: "Shop")
//
//                                let positionEnd = CLLocationCoordinate2D(latitude: end_location.object(forKey: "lat") as! CLLocationDegrees, longitude: end_location.object(forKey: "lng") as! CLLocationDegrees)
//                                self.ShopPosition = positionEnd
//                                self.GmapShoprmarker = GMSMarker(position: positionEnd)
//                                self.GmapShoprmarker.iconView = myCustomView1
//                                self.GmapShoprmarker.tracksViewChanges = true
//                                self.GmapShoprmarker.map = self.GmapView
//
//                                let distance = legsdic.object(forKey: "distance") as! NSDictionary
//                                print(distance)
//
//                                let duration = legsdic.object(forKey: "duration") as! NSDictionary
//                                print(duration)
//
//                                let end_address = createString(value: legsdic.object(forKey: "end_address") as AnyObject)
//                                print(end_address)
//                                let start_address = createString(value: legsdic.object(forKey: "start_address") as AnyObject)
//                                print(start_address)
//
//
//
//                            }
//
//                            let overlayPolyline = dic.object(forKey: "overview_polyline") as! NSDictionary
//                            print(overlayPolyline)
//                            let point = createString(value: overlayPolyline.object(forKey: "points") as AnyObject)
//                            print(point)
//                            let path = GMSPath.init(fromEncodedPath: point)
//                            let polyline = GMSPolyline.init(path: path)
//                            polyline.strokeWidth = 2.0
//                            polyline.geodesic = true
//                            polyline.strokeColor = .black
//                            polyline.map = self.GmapView
//
//                            //                            let lat = Double(self.orderStatusMapData.delivery_latitude)
//                            //                            let lon = Double(self.orderStatusMapData.delivery_longitude)
//                            //                            let origin = CLLocationCoordinate2D.init(latitude: lat!, longitude: lon!)
//                            //
//                            //                            let lat1 = Double(self.orderStatusMapData.store_latitude)
//                            //                            let lon1 = Double(self.orderStatusMapData.store_longitude)
//                            //                            let destinationShop = CLLocationCoordinate2D.init(latitude: lat1!, longitude: lon1!)
//                            //
//                            //                            let bounds = GMSCoordinateBounds(coordinate: origin, coordinate: destinationShop)
//                            //                            self.GmapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
//                        }
//                    }
//                }
//            case .failure(let error):
//                print(error)
//
//                self.alert(message: error.localizedDescription)
//                break
//            }
//        }
//
//    }
//
//}

