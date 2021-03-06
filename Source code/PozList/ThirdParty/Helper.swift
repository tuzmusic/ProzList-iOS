//
//  Helper.swift
//  CommonClass
//
//  Created on 5/2/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import QuartzCore

//prod
//dev
public let build_type = "dev"
public let apiversion = 1.0



enum UserType: String {
    case General = "General" // NEVER USED
    case Customer = "Customer"
    case ServiceProvider = "Service"
}
enum CertificateType:String{
    case serviceProvider = "certificate"
    case generalContractorLicence = "licence"
    case generalContractorInsurance = "insurance"
}

var isAllUpdated : Int = 0
//MARK: - Web Services Constant
struct WebURL {
    
    //static let baseURL:String = "http://project-demo-server.info/prozlist/api/v1/"
//    static let baseURL:String = "http://project-demo-server.net/prozlist/api/v1/"
     static let baseURL:String = "`"
    static let appkey:String = "da85d87b84495e41e24a55ea05bc7247"
    static let tokenKey:String = "Authorization"
//    static let ImageBaseUrl = "http://project-demo-server.info/prozlist/public/upload/"
    static let ImageBaseUrl = "http://199.250.201.83/~mobile/prozlist/public/upload/"
    static let login:String = WebURL.baseURL + "login"
    static let Register:String = WebURL.baseURL + "registration"
    static let ForgotPassword:String = WebURL.baseURL + "forgot-password"
    static let ServiceCatagory:String = WebURL.baseURL + "getsercat"
    static let UserProfile:String = WebURL.baseURL + "getprofile/"
    static let UpdateUserProfile:String = WebURL.baseURL + "update_profile/"
    static let CreateRequest:String = WebURL.baseURL + "create_request"
    static let getRequest:String = WebURL.baseURL + "get_service_request/"
    static let getNearbyJob:String = WebURL.baseURL + "get_nearbyjob"
    static let uploadCertificate:String = WebURL.baseURL + "upload_certificate"
    static let subcribeSave:String = WebURL.baseURL + "subscription_save"
    static let accetpAndDeclineReq:String = WebURL.baseURL + "save_request_status"
    static let getCurrentServiceReq:String = WebURL.baseURL + "get_current_request/"
    static let completeServiceReq:String = WebURL.baseURL + "give_rating"
    static let getCutomerReview:String = WebURL.baseURL + "get_my_review/"
    static let getCutomerStricks:String = WebURL.baseURL + "get_strike/"
    static let getAwards:String = WebURL.baseURL + "get_award/"
    static let updateLocation:String = WebURL.baseURL + "update_location"
    static let serviceProviderDuty:String = WebURL.baseURL + "service_provider_duty"
    static let getPDF:String = WebURL.baseURL + "getPDF/"
    static let emailPDF:String = WebURL.baseURL + "emailreceipt/"
}

extension UIColor{
    class func AppBlue() -> UIColor{
        return UIColor(red: 35.0 / 255.0, green: 116.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
    }
    class func placeHolder() -> UIColor{
        return UIColor(red: 156.0 / 255.0, green: 156.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)
    }
    class func textInput() -> UIColor{
        return UIColor(red: 36.0 / 255.0, green: 41.0 / 255.0, blue: 38.0 / 255.0, alpha: 1.0)
    }
    class func appGreen() -> UIColor{
        return UIColor(red: 9.0 / 255.0, green: 129.0 / 255.0, blue: 59.0 / 255.0, alpha: 1.0)
    }
    class func appBackGroundColor() -> UIColor{
        return UIColor(red: 176.0 / 255.0, green: 186.0 / 255.0, blue: 48.0 / 245.0, alpha: 1.0)
    }
    class func appNotcome() -> UIColor{
        return UIColor(red: 210.0 / 255.0, green: 51.0 / 255.0, blue: 4.0 / 255.0, alpha: 1.0)
    }
    class func appPending() -> UIColor{
        return UIColor(red: 229.0 / 255.0, green: 153.0 / 255.0, blue: 45.0 / 255.0, alpha: 1.0)
    }
    class func appLighteGreen() -> UIColor{
       return UIColor(red: 36.0 / 255.0, green: 41.0 / 255.0, blue: 38.0 / 255.0, alpha: 1.0)
    }
}

//MARK: - Device Type
enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case Phone
    case Pad
}
struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6PLUS      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}


//MARK: - Screen Size
struct ScreenSize {
    static let WIDTH         = UIScreen.main.bounds.size.width
    static let HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.WIDTH, ScreenSize.HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.WIDTH, ScreenSize.HEIGHT)
}
//MARK: - StoryBoards Constant
struct storyBoards {
    
    static let Main = UIStoryboard(name: "Main", bundle: Bundle.main)
    static let Customer = UIStoryboard(name: "Customer", bundle: Bundle.main)
    static let ServiceProvider = UIStoryboard(name: "ServiceProvider", bundle: Bundle.main)

}

//MARK: - Font Layout
struct FontName {
    //Font Name List
    static let HelveticaNeueBoldItalic = "HelveticaNeue-BoldItalic"
    static let HelveticaNeueLight = "HelveticaNeue-Light"
    static let HelveticaNeueUltraLightItalic = "HelveticaNeue-UltraLightItalic"
    static let HelveticaNeueCondensedBold = "HelveticaNeue-CondensedBold"
    static let HelveticaNeueMediumItalic = "HelveticaNeue-MediumItalic"
    static let HelveticaNeueThin = "HelveticaNeue-Thin"
    static let HelveticaNeueMedium = "HelveticaNeue-Medium"
    static let HelveticaNeueThinItalic = "HelveticaNeue-ThinItalic"
    static let HelveticaNeueLightItalic = "HelveticaNeue-LightItalic"
    static let HelveticaNeueUltraLight = "HelveticaNeue-UltraLight"
    static let HelveticaNeueBold = "HelveticaNeue-Bold"
    static let HelveticaNeue = "HelveticaNeue"
    static let HelveticaNeueCondensedBlack = "HelveticaNeue-CondensedBlack"
    static let RobotoRegular = "Roboto-Regular"
    static let RobotoLight = "Roboto-Light"
    
}
class Slider: UISlider {
    
    @IBInspectable var thumbImage: UIImage?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let thumbImage = thumbImage {
            self.setThumbImage(thumbImage, for: .normal)
        }
    }
}
//Date Formate
func getExpiryDateFormate(date:String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "mm/yyyy"
    let date = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "mm/yy"
    return dateFormatter.string(from: date!)
}
func showAlert(title: NSString, message: String) {
    let obj = UIAlertView(title: title as String, message: message, delegate: nil, cancelButtonTitle:"OK")
    obj.show()
}
func setFontLayout(strFontName:String,fontSize:CGFloat) -> UIFont {
    //Set auto font size in different devices.
    return UIFont(name: strFontName, size: (ScreenSize.WIDTH / 375) * fontSize)!
}
//MARK: - Set Color Method
func setColor(r: Float, g: Float, b: Float, aplha: Float)-> UIColor {
    return UIColor(red: CGFloat(Float(r / 255.0)), green: CGFloat(Float(g / 255.0)) , blue: CGFloat(Float(b / 255.0)), alpha: CGFloat(aplha))
}
//MARK: - Color
struct Color
{
    static let textColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
    static let keyboardHeaderColor = UIColor(red: 165.0 / 255.0, green: 177.0 / 255.0, blue: 13.0 / 255.0, alpha: 1.0)
}
//MARK : - UIColor Extension
extension UIColor {
    static var keyboardColor:UIColor {
        return UIColor(red: 165.0 / 255.0, green: 177.0 / 255.0, blue: 13.0 / 255.0, alpha: 1.0)
    }
}

//MARK: - check string nil
func createString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Int = value as? Int
    {
        returnString = String.init(format: "%d", str)
    }
        
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}

//MARK: - check string nil
func createFloatToString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Float = value as? Float
    {
        returnString = String.init(format: "%.2f", str)
    }
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}

func createDoubleToString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Float = value as? Float
    {
        returnString = String.init(format: "%f", str)
    }
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}
//MARK: - check string nil
func createIntToString(value: AnyObject) -> String
{
    var returnString: String = ""
    if let str: String = value as? String
    {
        returnString = str
    }
    else if let str: Int = value as? Int
    {
        returnString = String.init(format: "%d", str)
    }
    else if let _: NSNull = value as? NSNull
    {
        returnString = String.init(format: "")
    }
    return returnString
}

func createStringToint(value: AnyObject) -> Int
{
    var returnString: Int = 0
    
    if  value as! String == ""
    {
        returnString = 0
    } else {
        returnString = Int(value as! String)!
    }
    
    return returnString
}
func creatArray(value: AnyObject) -> NSMutableArray
{
    var tempArray = NSMutableArray()
    
    if let arrData: NSArray = value as? NSArray
    {
        tempArray = NSMutableArray.init(array: arrData)
    }
    else if let _: NSNull = value as? NSNull
    {
        tempArray = NSMutableArray.init()
    }
    
    return tempArray
}
class CircleControl: UIControl {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func updateCornerRadius() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}
func creatDictnory(value: AnyObject) -> NSMutableDictionary
{
    var tempDict = NSMutableDictionary()
    
    if let DictData: NSDictionary = value as? NSDictionary
    {
        tempDict = NSMutableDictionary.init()
        tempDict.addEntries(from:DictData as! [AnyHashable : Any])
    }
    else if let _: NSNull = value as? NSNull
    {
        tempDict = NSMutableDictionary.init()
    }
    
    return tempDict
}
func UTCToLocal(date:String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var str = ""
    if dt != nil
    {
        str = dateFormatter.string(from: dt!)
    }
    return str
}

//MARK: - Get String From Dictionary
func getStringFromDictionary(dictionary:NSDictionary, key:String) -> String {
    
    if let value = dictionary[key] {
        
        let string = NSString.init(format: "%@", value as! CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return ""
        }
        return string.removeWhiteSpace() as String
    }
    return ""
}

//MARK: - Get Dictionary From Dictionary
func getDictionaryFromDictionary(dictionary:NSDictionary, key:String) -> NSDictionary {
    
    if let value = dictionary[key] as? NSDictionary {
        
        let string = NSString.init(format: "%@", value as CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return NSDictionary()
        }
        return value
    }
    return NSDictionary()
}
//MARK: - Get Array From Dictionary
func getArrayFromDictionary(dictionary:NSDictionary, key:String) -> NSArray {
    
    if let value = dictionary[key] as? NSArray {
        
        let string = NSString.init(format: "%@", value as CVarArg) as String
        if (string == "null" || string == "NULL" || string == "nil") {
            return NSArray()
        }
        return value
    }
    return NSArray()
}
//MARK: - Scaling
struct DeviceScale {
    static let SCALE_X = ScreenSize.WIDTH / 375.0
    static let SCALE_Y = ScreenSize.HEIGHT / 667.0
}

//MARK: - Helper Class
class Helper {
    //MARK: - Shared Instance
    static let sharedInstance : Helper = {
        let instance = Helper()
        return instance
    }()
    
    static let isDevelopmentBuild:Bool = true
    //MARK: - Convert Second TO Hours,Minutes and Seconds
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    //MARK: - Add zero before single digit
    func addZeroBeforeDigit(number: Int) -> String {
        return ((number > 9) ? (String.init(format: "%d", number)) : (String.init(format: "0%d", number)))
    }
}

//MARK: - UILabel Extension
extension UILabel {
   
    //Get dynamic height
    func requiredHeight() -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.frame.width, height : CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.height
    }
    //Get dynamic width
    func requiredWidth() -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.frame.width,height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.width
    }
}


//MARK: - UIApplication Extension
extension UIApplication {
    class func topViewController(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(viewController: presented)
        }
        //        if let slide = viewController as? SlideMenuController {
        //            return topViewController(viewController: slide.mainViewController)
        //        }
        return viewController
    }
}

//MARK: - NSString Extension

extension String {
    
    func isEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
        
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }
    
    func isStringWithoutSpace() -> Bool{
        return !self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
    
    //Remove white space in string
    func removeWhiteSpace() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}


//MARK: - NSDate Extention for UTC date
extension NSDate {
    func getUTCFormateDate() -> String {
        let dateFormatter = DateFormatter()
        let timeZone = NSTimeZone(name: "UTC")
        dateFormatter.timeZone = timeZone as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self as Date)
    }
    
    func getSystemFormateDate() -> String {
        let dateFormatter = DateFormatter()
        let timeZone = NSTimeZone.system
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "dd/MM/yy hh:mma"
        return dateFormatter.string(from: self as Date)
    }
    
//    func getAppFormetedDate(date:String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let date = dateFormatter.date(from: date)
//        dateFormatter.dateFormat = "dd MMMM yyyy"
//        return  dateFormatter.string(from: date!)
//    }
    
}
extension UIView {
    
 
}
//MARK: - UIView Extension
extension UIView {
    
    //MARK: - IBInspectable
    //Set Corner Radious
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    @IBInspectable var overAllShadow : Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.overAllShadow()
            }
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    
    func addShadow(shadowColor: CGColor = UIColor.gray.cgColor,
                   shadowOffset: CGSize = CGSize(width: 0.5, height: 0.5),
                   shadowOpacity: Float = 0.5,
                   shadowRadius: CGFloat = 2.0) {
        
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    func overAllShadow(shadowColor: CGColor = UIColor.gray.cgColor,
                       shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0),
                       shadowOpacity: Float = 0.4,
                       shadowRadius: CGFloat = 4.0) {
        
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func add_shadow(demoView : UIView,height : CGFloat){
        
        let radius: CGFloat = demoView.frame.width //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: -1, y: -1, width: radius + 0.5 , height:height - 4.0))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        demoView.layer.cornerRadius = 0.0
        demoView.layer.shadowColor = UIColor.darkGray.cgColor
        demoView.layer.shadowOffset = CGSize(width: 0.1, height: 0.2)  //Here you control x and y
        demoView.layer.shadowOpacity = 0.2
        demoView.layer.shadowRadius = 2.0 //Here your control your blur
        demoView.layer.masksToBounds =  false
        demoView.layer.shadowPath = shadowPath.cgPath
    }
   
    func addShadowSmall(shadowColor: CGColor = UIColor.AppBlue().cgColor,
                        shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0),
                        shadowOpacity: Float = 0.4,
                        shadowRadius: CGFloat = 2.0) {
        
        
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        
        
    }
   
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    //Set Round
    @IBInspectable var Round:Bool {
        set {
            self.layer.cornerRadius = self.frame.size.height / 2.0
        }
        get {
            return self.layer.cornerRadius == self.frame.size.height / 2.0
        }
    }
    //Set Border Color
    @IBInspectable var borderColor:UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    //Set Border Width
    @IBInspectable var borderWidth:CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    //Set Shadow in View
    func addShadowView(width:CGFloat=0.2, height:CGFloat=0.2, Opacidade:Float=0.7, maskToBounds:Bool=false, radius:CGFloat=0.5){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Opacidade
        self.layer.masksToBounds = maskToBounds
    }
    struct NLInnerShadowDirection: OptionSet {
        let rawValue: Int
        
        static let None = NLInnerShadowDirection(rawValue: 0)
        static let Left = NLInnerShadowDirection(rawValue: 1 << 0)
        static let Right = NLInnerShadowDirection(rawValue: 1 << 1)
        static let Top = NLInnerShadowDirection(rawValue: 1 << 2)
        static let Bottom = NLInnerShadowDirection(rawValue: 1 << 3)
        static let All = NLInnerShadowDirection(rawValue: 15)
    }
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    func removeInnerShadow() {
        for view in self.subviews {
            if (view.tag == 2639) {
                view.removeFromSuperview()
                break
            }
        }
    }
    
    func addInnerShadow() {
        let c = UIColor()
        let color = c.withAlphaComponent(0.5)
        
        self.addInnerShadowWithRadius(radius: 3.0, color: color, inDirection: NLInnerShadowDirection.All)
    }
    
    func addInnerShadowWithRadius(radius: CGFloat, andAlpha: CGFloat) {
        let c = UIColor()
        let color = c.withAlphaComponent(alpha)
        
        self.addInnerShadowWithRadius(radius: radius, color: color, inDirection: NLInnerShadowDirection.All)
    }
    
    func addInnerShadowWithRadius(radius: CGFloat, andColor: UIColor) {
        self.addInnerShadowWithRadius(radius: radius, color: andColor, inDirection: NLInnerShadowDirection.All)
    }
    
    func addInnerShadowWithRadius(radius: CGFloat, color: UIColor, inDirection: NLInnerShadowDirection) {
        self.removeInnerShadow()
        
        let shadowView = self.createShadowViewWithRadius(radius: radius, andColor: color, direction: inDirection)
        
        self.addSubview(shadowView)
    }
    
    func createShadowViewWithRadius(radius: CGFloat, andColor: UIColor, direction: NLInnerShadowDirection) -> UIView {
        let shadowView = UIView(frame: CGRect(x: -5,y: 0-5,width: self.bounds.size.width+10,height: self.bounds.size.height+10))
        shadowView.backgroundColor = UIColor.clear
        shadowView.tag = 2639
        
        let colorsArray: Array = [ andColor.cgColor, UIColor.clear.cgColor ]
        
        if direction.contains(.Top) {
            let xOffset: CGFloat = 0.0
            let topWidth = self.bounds.size.width
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.startPoint = CGPoint(x:0.5,y: 0.0)
            shadow.endPoint = CGPoint(x:0.5,y: 1.0)
            shadow.frame = CGRect(x: xOffset,y: 0,width: topWidth,height: radius)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction.contains(.Bottom) {
            let xOffset: CGFloat = 0.0
            let bottomWidth = self.bounds.size.width
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.startPoint = CGPoint(x:0.5,y: 1.0)
            shadow.endPoint = CGPoint(x:0.5,y: 0.0)
            shadow.frame = CGRect(x:xOffset,y: self.bounds.size.height - radius, width: bottomWidth,height: radius)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction.contains(.Left) {
            let yOffset: CGFloat = 0.0
            let leftHeight = self.bounds.size.height
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.frame = CGRect(x:0,y: yOffset,width: radius,height: leftHeight)
            shadow.startPoint = CGPoint(x:0.0,y: 0.5)
            shadow.endPoint = CGPoint(x:1.0,y: 0.5)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction.contains(.Right) {
            let yOffset: CGFloat = 0.0
            let rightHeight = self.bounds.size.height
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.frame = CGRect(x:self.bounds.size.width - radius,y: yOffset,width: radius,height: rightHeight)
            shadow.startPoint = CGPoint(x:1.0,y: 0.5)
            shadow.endPoint = CGPoint(x:0.0,y: 0.5)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        return shadowView
    }
}
//MARK: - Bundle Information
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
//MARK: - MTViewController
class MTViewController : UIViewController
{
    //Outlet for auto resizing constraint constant set in different devices
    @IBOutlet var arrXConstraint : [NSLayoutConstraint]!
    
    
    @IBOutlet var arrYConstraint : [NSLayoutConstraint]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if arrXConstraint != nil
        {
            //Auto resizing constraint constant set in different devices
            for const in arrXConstraint {
                const.constant = const.constant * DeviceScale.SCALE_X
            }
        }
        if arrYConstraint != nil
        {
            //Auto resizing constraint constant set in different devices
            for const in arrYConstraint {
                const.constant = const.constant * DeviceScale.SCALE_Y
            }
        }
    }
    
    // MARK:- =======================================================
    // MARK: - Hex to UIcolor
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}

func alert(message: String) -> Void
{
    let alert = UIAlertController.init(title: "Alert!", message: message, preferredStyle: UIAlertControllerStyle.alert)
    let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) in
        
    })
    alert.addAction(action)
    UIApplication.topViewController()?.present(alert, animated: true) {
        
    }
}

//MARK: - MTCollectionCell
class MTCollectionCell: UICollectionViewCell
{
    @IBOutlet var arrCellConstants: [NSLayoutConstraint]!
    override func awakeFromNib() {
        
        if arrCellConstants != nil
        {
            for const in arrCellConstants {
                const.constant = const.constant * DeviceScale.SCALE_X
            }
        }
    }
}

//MARK: - MTTableCell
class MTTableCell: UITableViewCell
{
    @IBOutlet var arrTableCellConstants: [NSLayoutConstraint]!
    override func awakeFromNib() {
        
        if arrTableCellConstants != nil
        {
            for const in arrTableCellConstants {
                const.constant = const.constant * DeviceScale.SCALE_X
            }
        }
        
    }
}






//MARK: - MTLabel
class MTLabel : UILabel {
    override func awakeFromNib() {
        //Font size auto resizing in different devices
        self.font = self.font.withSize(self.font.pointSize * DeviceScale.SCALE_X)
    }
}

//MARK: - MTTextView
class MTTextView: UITextView
{
    //    override open func awakeFromNib() {
    //        self.font = self.font?.withSize((self.font?.pointSize)! * DeviceScale.SCALE_X)
    //    }
}



class MTTextFieldSimple: UITextField
{
    override open func awakeFromNib() {
        self.font = self.font?.withSize((self.font?.pointSize)! * DeviceScale.SCALE_X)
    }
}
//MARK: - UITextfield Extension
extension UITextField {
   
    
    //Set placeholder font
//    func setPlaceholderFont(font: UIFont) {
//        let lblPlaceHolder:UILabel = self.value(forKey: "_placeholderLabel") as! UILabel
//        lblPlaceHolder.font = font
//    }
    
}
//MARK: - Protocol Oriented Programming Language
protocol Shakeable { }

extension Shakeable where Self: UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.03
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x:self.center.x - 4.0, y:self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x:self.center.x + 4.0, y:self.center.y))
        layer.add(animation, forKey: "position")
    }
}
class MTImageView: UIImageView, Shakeable {
    
}
//MARK: - NSMutableArray Extension
extension NSMutableArray {
    func shuffle () {
        for i in (0..<self.count).reversed() {
            let ix1 = i
            let ix2 = Int(arc4random_uniform(UInt32(i+1)))
            (self[ix1], self[ix2]) = (self[ix2], self[ix1])
        }
    }
}

// Dictionary Contains Value
extension Dictionary where Value: Equatable {
    func containsValue(value : Value) -> Bool {
        return self.contains { $0.1 == value }
    }
}


