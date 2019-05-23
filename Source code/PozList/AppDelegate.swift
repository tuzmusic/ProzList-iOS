//
//  AppDelegate.swift
//  PozList
//
//  Created on 28/09/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Fabric
import Crashlytics

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()
    var loadingIndicator:MTLoadingIndicator!
    var isLoadingIndicatorOpen:Bool = false
    var updatedLocation:LocationCoordinate!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("AIzaSyA9Tfqqo1J0wbVqTRDUzOH68vU-yK5JspI")
        GMSPlacesClient.provideAPIKey("AIzaSyA9Tfqqo1J0wbVqTRDUzOH68vU-yK5JspI")
        locationManager = CLLocationManager()
        if (CLLocationManager.locationServicesEnabled())
        {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestWhenInUseAuthorization()
            //locationManager.allowsBackgroundLocationUpdates = true
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().previousNextDisplayMode = .alwaysHide
        
        if UserDefaults.Main.bool(forKey: .isLogin) {
            let userType = UserDefaults.Main.string(forKey: .Appuser)
            if userType == "Service"{
                if !UserDefaults.Main.bool(forKey: .isCertificated) {
                    let vc = storyBoards.Main.instantiateViewController(withIdentifier: "UploadCertificateVC") as! UploadCertificateVC
//                    self.window?.rootViewController = UINavigationController.init(rootViewController: vc)
                    let navCtrl = UINavigationController.init(rootViewController: vc)
                    navCtrl.navigationBar.isHidden = true
                    self.window?.rootViewController = navCtrl
                    self.window?.makeKeyAndVisible()
                }else if !UserDefaults.Main.bool(forKey: .isSubscribed) {
                    let vc = storyBoards.Main.instantiateViewController(withIdentifier: "SubscribeVC") as! SubscribeVC
                    let navCtrl = UINavigationController.init(rootViewController: vc)
                    navCtrl.navigationBar.isHidden = true
                    self.window?.rootViewController = navCtrl
                    self.window?.makeKeyAndVisible()
                }else {
                    let ContainerVC = storyBoards.Customer.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
                    self.window?.rootViewController = UINavigationController.init(rootViewController: ContainerVC)
                    self.window?.makeKeyAndVisible()
                }
            }else {
                let ContainerVC = storyBoards.Customer.instantiateViewController(withIdentifier:"HostViewController") as! HostViewController
                self.window?.rootViewController = UINavigationController.init(rootViewController: ContainerVC)
                self.window?.makeKeyAndVisible()
            }
        }
        else {
            
            let ContainerVC = storyBoards.Main.instantiateViewController(withIdentifier: "LoginVC") as! UINavigationController
            self.window?.rootViewController = ContainerVC
            self.window?.makeKeyAndVisible()
        }
        
        //Set observer location
        updatedLocation = LocationCoordinate.init(strLatitude: UserDefaults.Main.string(forKey: .userLatitude), strLongitude: UserDefaults.Main.string(forKey: .userLongitude))
        
        Fabric.with([Crashlytics.self])
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //MARK: - Show/Hide Loading Indicator
    func showLoadingIndicator() {
        
        if (isLoadingIndicatorOpen == false) {
            
            DispatchQueue.global(qos: .background).async {
                
                DispatchQueue.main.async {
                    
                    self.loadingIndicator = MTLoadingIndicator.init(frame: UIScreen.main.bounds).show(isAnimated: true)
                    self.isLoadingIndicatorOpen = true
                }
            }
        }
    }
    func hideLoadingIndicator() {
        
        if self.loadingIndicator != nil && isLoadingIndicatorOpen == true {
            self.loadingIndicator.hide(isAnimated: true)
            isLoadingIndicatorOpen = false
        }
    }
    
    //MARK: - Alert View
    
    func Popup(Message:String){
        var alert = UIAlertController()
        if Message.characters.count > 0
        {
            alert = UIAlertController(title: "Alert!", message: Message, preferredStyle: UIAlertControllerStyle.alert)
        } else {
            alert = UIAlertController(title: "Alert!", message: "Check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
        }
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { ACTION in
        }))
        UIApplication.topViewController()?.present(alert, animated: false, completion: {
        })
    }
    
    func showAlert(Message:String, completion:((Bool)->())?){
        let alert = UIAlertController(title: "Alert!", message: NSLocalizedString(Message, comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            if completion != nil {
                completion!(true)
            }
        }))
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Location Manager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error while updating location " + error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        if locations.count > 0
        {
            self.checkLocation(location: locations)
            //locationManager.stopUpdatingLocation()
        }
        
    }
    
    
    
    func checkLocation(location: [CLLocation]) -> Void
    {
        var currentLocation = CLLocation()
        
            //CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse){
           
            currentLocation = location[0]
            
            let latitude :CLLocationDegrees = currentLocation.coordinate.latitude
            let longitude :CLLocationDegrees = currentLocation.coordinate.longitude

            let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
            
//            let ServiceCl = ServiceClass()
//            ServiceCl.callForLocationUpdate(lat: "\(latitude)" as NSString, Long:"\(longitude)" as NSString)
            
            
            
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            
            let DriverLocation: NSDictionary = ["lat": lat, "long": lon]
            
            UserDefaults.Main.set(lat, forKey: .userLatitude)
            UserDefaults.Main.set(lon, forKey: .userLongitude)
            
            updatedLocation.strLatitude = lat
            updatedLocation.strLongitude = lon
            
            //UserDefaults.Main.set(DriverLocation, forKey: .driverLocation)
            //UserDefaults.standard.synchronize()
            
            //http://maps.googleapis.com/maps/api/geocode/json?sensor=true&latlng="+latLng.latitude+","+latLng.longitude
            
        
//            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
//                print(location)
//
//                if error != nil {
//                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
//                    return
//                }
//
//                if (placemarks!.count) > 0
//                {
//                    let pm = placemarks![0]
//
//                    if pm.locality !=  nil
//                    {
//                        print(pm.locality!)
//                        print(pm.addressDictionary!)
//
//
//                        let lat = NSNumber(value: location.coordinate.latitude)
//                        let lon = NSNumber(value: location.coordinate.longitude)
//                        let DriverLocation: NSDictionary = ["lat": lat, "long": lon, "locationName": pm.locality!]
//
//                        if UserDefaults.Main.object(forKey: .driverLocation) != nil
//                        {
//                            let userLocation: NSDictionary  = UserDefaults.Main.object(forKey: .driverLocation) as! NSDictionary
//                            if userLocation.allKeys.count > 0 {
//
//                                let lat = NSNumber(value: location.coordinate.latitude)
//                                let lon = NSNumber(value: location.coordinate.longitude)
//                                let DriverLocation: NSDictionary = ["lat": lat, "long": lon, "locationName": (pm.locality!)]
//
//                                UserDefaults.Main.set(userLocation, forKey: .driverLocation)
//                                UserDefaults.standard.synchronize()
//                            }
//                        }
//
//                        let tempAddress = pm.addressDictionary!
//                        print(tempAddress)
//
//                        let state = tempAddress[AnyHashable("State")] as! String
//                        let countryCode = tempAddress[AnyHashable("CountryCode")] as! String
//
//                        if (state == "Gujarat" && countryCode == "IN") || (state == "CA" && countryCode == "US")
//                        {
//                            print("in Area")
//
//                            var vc = self.window?.rootViewController
//                            if vc is UINavigationController
//                            {
//                                vc = (vc as! UINavigationController).visibleViewController
//                                print(vc!)
//
//                                if vc is LocationVerificationVC
//                                {
//                                    self.window?.rootViewController?.dismiss(animated: true, completion: {
//                                    })
//                                }
//                            }
//                        }
//                        else
//                        {
//                            let vc = self.storyBoard.instantiateViewController(withIdentifier: "LocationVerificationVC") as! LocationVerificationVC
//                            self.window?.rootViewController?.present(vc, animated: true, completion: {
//
//                            })
//
//                        }
//
//                    }
//                    else
//                    {
//                        let vc = self.storyBoard.instantiateViewController(withIdentifier: "LocationVerificationVC") as! LocationVerificationVC
//                        self.window?.rootViewController?.present(vc, animated: true, completion: {
//
//                        })
//
//                    }
//                }
//                else {
//                    print("Problem with the data received from geocoder")
//                }
//            })
            
            
        }
        
    }
}

// Add your userdefault key here :
extension UserDefaults
{
    struct Main : UserDefaultable {
        private init() { }
        
        enum BoolDefaultKey : String {
            case isLogin
            case isSignUp
            case isCertificated
            case isSubscribed
            case isDutyOnOff
        }
        
        enum FloatDefaultKey:String {
            case floatKey
        }
        enum DoubleDefaultKey: String {
            case doubleKey
        }
        enum IntegerDefaultKey: String {
            case IntKey
        }
        enum StringDefaultKey: String {
            
            case UserID
            case token
            case Appuser
            case userLatitude
            case userLongitude
        }
        enum URLDefaultKey: String {
            case urlKey
        }
        enum ObjectDefaultKey: String {
            case Profile
            case Card
            
        }
    }
}

