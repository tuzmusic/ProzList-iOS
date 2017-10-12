//
//  AppDelegate.swift
//  PozList
//
//  Created by Devubha Manek on 28/09/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()
   
  
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        GMSServices.provideAPIKey("AIzaSyD5dRdfmT4dpHjAo7Rdy-WOK4YMixclnuo")
        GMSPlacesClient.provideAPIKey("AIzaSyD5dRdfmT4dpHjAo7Rdy-WOK4YMixclnuo")
        locationManager = CLLocationManager()
        if (CLLocationManager.locationServicesEnabled())
        {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestAlwaysAuthorization()
            //locationManager.allowsBackgroundLocationUpdates = true
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().previousNextDisplayMode = .alwaysHide
        
       
        
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
    
    
   
    
    
    // Location Manager
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error while updating location " + error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.stopUpdatingLocation()
        if locations.count > 0
        {
            self.checkLocation(location: locations)
        }
        
    }
    
    func checkLocation(location: [CLLocation]) -> Void
    {
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
           
            currentLocation = location[0]
            
            let latitude :CLLocationDegrees = currentLocation.coordinate.latitude
            let longitude :CLLocationDegrees = currentLocation.coordinate.longitude

            let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
            
//            let ServiceCl = ServiceClass()
//            ServiceCl.callForLocationUpdate(lat: "\(latitude)" as NSString, Long:"\(longitude)" as NSString)
            
            
            
            let lat = NSNumber(value: location.coordinate.latitude)
            let lon = NSNumber(value: location.coordinate.longitude)
            let DriverLocation: NSDictionary = ["lat": lat, "long": lon]
            
//            UserDefaults.Main.set(DriverLocation, forKey: .driverLocation)
//            UserDefaults.standard.synchronize()
            
            
            
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

