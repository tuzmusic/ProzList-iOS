
import Foundation
import Alamofire

// MARK: Web Operation
let kInternetDown       = "Your internet connection seems to be down"
let kHostDown           = "Your host seems to be down"
let kTimeOut            = "The request timed out"
let kTokenExpire        = "Session expired - please login again."
let _appName            = "SmartQueue"

//Pring json object
func jprint(items: Any...) {
    for item in items {
        print(item)
    }
}

//Set/get Authentication token key
class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: WebURL.tokenKey)
        return urlRequest
    }
}

//Block for throw response
typealias WSBlock = (_ json: Any?, _ flag: Int) -> ()
typealias WSProgress = (Progress) -> ()?
typealias WSFileBlock = (_ path: String?, _ success: Bool) -> ()

//MARK: - Create Web service calling class
class MTWebCall:NSObject{

    //Variable Declaration
    static var call: MTWebCall = MTWebCall()
    
    let manager: SessionManager
    var networkManager: NetworkReachabilityManager
    
    var headers: HTTPHeaders = [
        //"Content-Type": "application/x-www-form-urlencoded",
        "apikey":WebURL.appkey
    ]
    
    var paramEncode: ParameterEncoding = URLEncoding.default
    
    var successBlock: (String, HTTPURLResponse?, AnyObject?, WSBlock) -> Void
    var errorBlock: (String, HTTPURLResponse?, NSError, WSBlock) -> Void
    
    //NSObject override methos
    override init() {
        manager = Alamofire.SessionManager.default
        networkManager = NetworkReachabilityManager()!
        
        // Will be called on success of web service calls.
        successBlock = { (relativePath, res, respObj, block) -> Void in
            // Check for response it should be there as it had come in success block
            if let response = res{
                jprint(items: "Response Code: \(response.statusCode)")
                jprint(items: "Response(\(relativePath)): \(String(describing: respObj))")
                if response.statusCode == 200 {
                    block(respObj, response.statusCode)
                } else {
                    block(respObj, response.statusCode)
                }
            } else {
                // There might me no case this can get execute
                block(nil, 404)
            }
        }
        
        // Will be called on Error during web service call
        errorBlock = { (relativePath, res, error, block) -> Void in
            // First check for the response if found check code and make decision
            if let response = res {
                jprint(items: "Response Code: \(response.statusCode)")
                jprint(items: "Error Code: \(error.code)")
                if let data = error.userInfo["com.alamofire.serialization.response.error.data"] as? NSData {
                    let errorDict = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                    if errorDict != nil {
                        jprint(items: "Error(\(relativePath)): \(errorDict!)")
                        block(errorDict!, response.statusCode)
                        if response.statusCode == 423{

                        }
                    } else {
                        let code = response.statusCode
                        block(nil, code)
                    }
                } else {
                    block(nil, response.statusCode)
                }
                // If response not found rely on error code to find the issue
            } else if error.code == -1009  {
                jprint(items: "Error(\(relativePath)): \(error)")
                block([_appName: kInternetDown] as AnyObject, error.code)
                return
            } else if error.code == -1003  {
                jprint(items: "Error(\(relativePath)): \(error)")
                block([_appName: kHostDown] as AnyObject, error.code)
                return
            } else if error.code == -1001  {
                jprint(items: "Error(\(relativePath)): \(error)")
                block([_appName: kTimeOut] as AnyObject, error.code)
                return
            } else {
                jprint(items: "Error(\(relativePath)): \(error)")
                block(nil, error.code)
            }
        }
        super.init()
        addInterNetListner()
    }
    
    deinit {
        networkManager.stopListening()
    }
}

// MARK: Other methods
extension MTWebCall {
    
    //Get Full URL
    func getFullUrl(relPath : String) throws -> URL{
        do{
            if relPath.lowercased().contains("http") || relPath.lowercased().contains("www"){
                return try relPath.asURL()
            }else{
                return try (WebURL.baseURL+relPath).asURL()
            }
        }catch let err{
            throw err
        }
    }
    
    //Set Authentication token in header
    func setAccesTokenToHeader(token:String){
        manager.adapter = AccessTokenAdapter(accessToken: token)
    }
    
    //Remove Authentication token in header
    func removeAccessTokenFromHeader(){
        manager.adapter = nil
    }
}

// MARK: - Request, ImageUpload and Dowanload methods
extension MTWebCall{
    func getRequest(relPath: String, param: [String: Any]?, block: @escaping WSBlock)-> DataRequest?{
        
        do{
            return manager.request(try getFullUrl(relPath: relPath), method: HTTPMethod.get, parameters: param, encoding: paramEncode, headers: headers).responseJSON { (resObj) in
                switch resObj.result{
                case .success:
                    if let resData = resObj.data{
                        do {
                            let res = try JSONSerialization.jsonObject(with: resData, options: []) as AnyObject
                            self.successBlock(relPath, resObj.response, res, block)
                        } catch let errParse{
                            jprint(items: errParse)
                            self.errorBlock(relPath, resObj.response, errParse as NSError, block)
                        }
                    }
                    break
                case .failure(let err):
                    jprint(items: err)
                    self.errorBlock(relPath, resObj.response, err as NSError, block)
                    break
                }
            }
            
        }catch let error{
            jprint(items: error)
            errorBlock(relPath, nil, error as NSError, block)
            return nil
        }
    }
    func getHTMLRequest(relPath: String, param: [String: Any]?, block: @escaping WSBlock)-> DataRequest?{
        
        do{
            return manager.request(try getFullUrl(relPath: relPath), method: HTTPMethod.get, parameters: param, encoding: paramEncode, headers: headers).responseString { resObj in
                    
                    switch(resObj.result) {
                    case .success(_):
                        
                        if let resData = resObj.result.value{
                            self.successBlock(relPath, resObj.response, resData as AnyObject, block)
                        } else {
                        
                            self.errorBlock(relPath, resObj.response, NSError(), block)
                        }
                        
                    case .failure(let err):
                        jprint(items: err)
                        self.errorBlock(relPath, resObj.response, err as NSError, block)
                        break
                    }
            }
        }catch let error{
            jprint(items: error)
            errorBlock(relPath, nil, error as NSError, block)
            return nil
        }
    }
    func postRequest(relPath: String, param: [String: Any]?, block: @escaping WSBlock)-> DataRequest? {
        do{
            
            return manager.request(try getFullUrl(relPath: relPath), method: HTTPMethod.post, parameters: param, encoding: paramEncode, headers: headers).responseJSON { (resObj) in
                switch resObj.result{
                case .success:
                    if let resData = resObj.data{
                        do {
                            let res = try JSONSerialization.jsonObject(with: resData, options: []) as AnyObject
                            self.successBlock(relPath, resObj.response, res, block)
                        } catch let errParse{
                            jprint(items: errParse)
                            self.errorBlock(relPath, resObj.response, errParse as NSError, block)
                        }
                    }
                    break
                case .failure(let err):
                    jprint(items: err)
                    self.errorBlock(relPath, resObj.response, err as NSError, block)
                    break
                }
            }
        }catch let error{
            jprint(items: error)
            errorBlock(relPath, nil, error as NSError, block)
            return nil
        }
    }
    
    func putRequest(relPath: String, param: [String: Any]?, block: @escaping WSBlock)-> DataRequest?{
        do{
            return manager.request(try getFullUrl(relPath: relPath), method: HTTPMethod.put, parameters: param, encoding: paramEncode, headers: headers).responseJSON { (resObj) in
                switch resObj.result{
                case .success:
                    if let resData = resObj.data{
                        do {
                            let res = try JSONSerialization.jsonObject(with: resData, options: []) as AnyObject
                            self.successBlock(relPath, resObj.response, res, block)
                        } catch let errParse{
                            jprint(items: errParse)
                            self.errorBlock(relPath, resObj.response, errParse as NSError, block)
                        }
                    }
                    break
                case .failure(let err):
                    jprint(items: err)
                    self.errorBlock(relPath, resObj.response, err as NSError, block)
                    break
                }
            }
        }catch let error{
            jprint(items: error)
            errorBlock(relPath, nil, error as NSError, block)
            return nil
        }
    }
    
    func uploadImage(relPath: String,img: UIImage,imgKey: String,param: [String: String]?, block: @escaping WSBlock, progress: WSProgress?){
        do{
            manager.upload(multipartFormData: { (formData) in
                let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))
                formData.append(UIImageJPEGRepresentation(img, 1.0)!, withName: imgKey, fileName: currentTimeStamp + "image" + ".jpeg", mimeType: "image/jpeg")
                if let _ = param{
                    for (key, value) in param!{
                        formData.append(value.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
            }, to: try getFullUrl(relPath: relPath), method: HTTPMethod.post, headers: headers, encodingCompletion: { encoding in
                switch encoding{
                case .success(let req, _, _):
                    req.uploadProgress(closure: { (prog) in
                        progress?(prog)
                    }).responseJSON { (resObj) in
                        switch resObj.result{
                        case .success:
                            if let resData = resObj.data{
                                do {
                                    let res = try JSONSerialization.jsonObject(with: resData, options: []) as AnyObject
                                    self.successBlock(relPath, resObj.response, res, block)
                                } catch let errParse{
                                    jprint(items: errParse)
                                    self.errorBlock(relPath, resObj.response, errParse as NSError, block)
                                }
                            }
                            break
                        case .failure(let err):
                            jprint(items: err)
                            self.errorBlock(relPath, resObj.response, err as NSError, block)
                            break
                        }
                    }
                    break
                case .failure(let err):
                    jprint(items: err)
                    self.errorBlock(relPath, nil, err as NSError, block)
                    break
                }
            })
        }catch let err{
            self.errorBlock(relPath, nil, err as NSError, block)
        }
    }
    
    func uploadMultiImage(relPath: String,img: [UIImage],imgKey: String,param: [String: String]?, block: @escaping WSBlock, progress: WSProgress?){
        do{
            manager.upload(multipartFormData: { (formData) in
                var i = 0
                for imageData in img {
                    let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))
                   formData.append(UIImageJPEGRepresentation(imageData, 1.0)!, withName: "\(imgKey)[]", fileName: currentTimeStamp + "\(i)" + "image.jpeg", mimeType: "image/jpeg")
                    i += 1
                }
                
                if let _ = param{
                    for (key, value) in param!{
                        formData.append(value.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
            }, to: try getFullUrl(relPath: relPath), method: HTTPMethod.post, headers: headers, encodingCompletion: { encoding in
                switch encoding{
                case .success(let req, _, _):
                    req.uploadProgress(closure: { (prog) in
                        progress?(prog)
                    }).responseJSON { (resObj) in
                        switch resObj.result{
                        case .success:
                            if let resData = resObj.data{
                                do {
                                    let res = try JSONSerialization.jsonObject(with: resData, options: []) as AnyObject
                                    self.successBlock(relPath, resObj.response, res, block)
                                } catch let errParse{
                                    jprint(items: errParse)
                                    self.errorBlock(relPath, resObj.response, errParse as NSError, block)
                                }
                            }
                            break
                        case .failure(let err):
                            jprint(items: err)
                            self.errorBlock(relPath, resObj.response, err as NSError, block)
                            break
                        }
                    }
                    break
                case .failure(let err):
                    jprint(items: err)
                    self.errorBlock(relPath, nil, err as NSError, block)
                    break
                }
            })
        }catch let err{
            self.errorBlock(relPath, nil, err as NSError, block)
        }
    }
    
    func dowanloadFile(relPath : String, saveFileWithName: String, progress: WSProgress?, block: @escaping WSFileBlock){
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("pig.png")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        do{
            manager.download(try getFullUrl(relPath: relPath), to: destination).downloadProgress { (prog) in
                progress?(prog)
                }.response { (responce) in
                    if responce.error == nil, let path = responce.destinationURL?.path{
                        block(path, true)
                    }else{
                        block(nil, false)
                    }
                }.resume()

        }catch{
            block(nil, false)
        }
    }
    func dowanloadPdfFile(relPath : String, saveFileWithName: String, progress: WSProgress?, block: @escaping WSFileBlock){
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("receipt.pdf")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        do{
            manager.download(try getFullUrl(relPath: relPath), to: destination).downloadProgress { (prog) in
                progress?(prog)
                }.response { (responce) in
                    if responce.error == nil, let path = responce.destinationURL?.path{
                        block(path, true)
                    }else{
                        block(nil, false)
                    }
                }.resume()
            
        }catch{
            block(nil, false)
        }
    }
}


// MARK: - Internet Availability
extension MTWebCall{
    func addInterNetListner(){
        networkManager.listener = { (status) in
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable{
                print("No InterNet")
            }else{
                print("Internet Avail")
            }
        }
        networkManager.startListening()
    }
    
    func isInternetAvailable() -> Bool {
        if networkManager.isReachable{
            return true
        }else{
            return false
        }
    }
}

//MARK: - API Call extention
extension MTWebCall{
    //MARK: - Login API calling
    func login(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.login
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
    
    //MARK: - Register owner API calling
    func registerUser(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.Register
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - Forgot Password API calling
    func forgotPassword(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.ForgotPassword
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - get User Profile API calling
    func getUserProfile(userId: String,dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.UserProfile + userId
        let _ = getRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - update User Profile with image API calling
    func updateUserProfile(userId: String,image:UIImage,dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.UpdateUserProfile + userId
        let _ = uploadImage(relPath: relPath, img: image, imgKey: "profile_pic", param: dictParam as? [String : String], block: block, progress: nil)
    }
    //MARK: - update User Profile API calling
    func updateUserProfile(userId: String,dictParam:[String : Any],block: @escaping WSBlock) {
        let relPath = WebURL.UpdateUserProfile + userId
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - Load Catagory API calling
    func getServiceCat(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.ServiceCatagory
        let _ = getRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - Create Request API calling
    func createRequest(images:[UIImage],dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.CreateRequest
        let _ = uploadMultiImage(relPath: relPath, img: images, imgKey: "images", param: dictParam as? [String : String], block: block, progress: nil)
    }
    //MARK: - Create Request API calling
    func getRequest(userId: String, type: String,dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.getRequest + userId + "/" + type
        let _ = getRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - Create Request API calling
    func getNearByJob(userId: String,dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.getNearbyJob  //+ userId
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - Subcription API calling
    func subcriptionSave(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.subcribeSave
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - Accept and Decline API calling
    func requestAcceptAndDecline(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.accetpAndDeclineReq
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - get User Current Requestt API calling
    func getCurrentServiceReq(userId: String, type: String,dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.getCurrentServiceReq + userId + "/" + type
        let _ = getRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - Complete service API calling
    func serviceCompleted(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.completeServiceReq
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - get User Review API calling
    func getCutomerReview(userId: String, type: String,dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.getCutomerReview + userId + "/" + type
        let _ = getRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - get User Strickes API calling
    func getStricks(userId: String, dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.getCutomerStricks + userId
        let _ = getRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - get Awards API calling
    func getAwards(userId: String, dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.getAwards + userId
        let _ = getRequest(relPath: relPath, param: dictParam, block: block)
    }
    
    //MARK: - Accept and Decline API calling
    func updateLocationAPI(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.updateLocation
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
    
    //MARK: - Set Duty On Off
    func setDutyOnOffAPI(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.serviceProviderDuty
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
    //MARK: - email PDF
    func emailPdfFile(userId: String, transactionId: String, requestId: String, dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.emailPDF + userId + "/" + transactionId + "/" + requestId
        let _ = getRequest(relPath: relPath, param: dictParam, block: block)
    }
    func downloadPdfFile(userId: String, transactionId: String, requestId: String, dictParam:[String : Any],block: @escaping WSFileBlock) {
        
        let relPath = WebURL.getPDF + userId + "/" + transactionId + "/" + requestId
        let _ = dowanloadPdfFile(relPath: relPath, saveFileWithName: "receipt.pdf", progress: nil, block: block)
    }
    
}
/*extension MTWebCall{
    
//MARK: - Search API Calling
    func serch(location:String, page:Int, per_page:Int, block: @escaping WSBlock) {
        
        let relPath = WebURL.search + "?location=" + location + "&page=" + String(page) + "&per_page=" + String(per_page)
        let escapedSearch = relPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let _ = getRequest(relPath: escapedSearch!, param: nil, block: block)
    }
//MARK: - Images Backgrounds API Calling
    func imageBackgrounds(block: @escaping WSBlock) {
        
        let relPath = WebURL.imagesBackgrounds
        let _ = getRequest(relPath: relPath, param: nil, block: block)
    }
//MARK: - Top destinations API Calling
    func topDestinations(block: @escaping WSBlock) {
        
        let relPath = WebURL.topDestinations
        let _ = getRequest(relPath: relPath, param: nil, block: block)
    }
//MARK: - Filter property types API Calling
    func topFeatures(page:Int, per_page:Int, block: @escaping WSBlock) {
        
        var relPath = WebURL.topFeatures
        relPath = relPath + "?page=" + String(page)
        relPath = relPath + "&per_page=" + String(per_page)
        print(relPath)
        let _ = getRequest(relPath: relPath, param: nil, block: block)
    }
//MARK: - Filter location types API Calling
    func filterLocationTypes(block: @escaping WSBlock) {
        
        let relPath = WebURL.filterLocation
        let _ = getRequest(relPath: relPath, param: nil, block: block)
    }
//MARK: - Filter property types API Calling
    func filterPropertyTypes(block: @escaping WSBlock) {
        
        let relPath = WebURL.filterProperty
        let _ = getRequest(relPath: relPath, param: nil, block: block)
    }
//MARK: - Search filter API Calling
    func searchFilter(location:String, page:Int, per_page:Int, luxury:String, check_in:String, check_out:String, min_price:Int, max_price:Int, min_sleeps:Int, max_sleeps:Int, min_bedrooms:Int, max_bedrooms:Int, bedrooms:Int, min_bathrooms:Int, max_bathrooms:Int, bathrooms:Int, block: @escaping WSBlock) {
        
        var relPath = WebURL.searchFilter
        
        relPath = relPath + "?location=" + location
        relPath = relPath + "&page=" + String(page)
        relPath = relPath + "&per_page=" + String(per_page)
        relPath = relPath + "&luxury=" + luxury
        relPath = relPath + "&check_in=" + check_in
        relPath = relPath + "&check_out=" + check_out
        relPath = relPath + "&min_price=" + String(min_price)
        relPath = relPath + "&max_price=" + String(max_price)
        relPath = relPath + "&min_sleeps=" + String(min_sleeps)
        relPath = relPath + "&max_sleeps=" + String(max_sleeps)
        relPath = relPath + "&min_bedrooms=" + String(min_bedrooms)
        relPath = relPath + "&max_bedrooms=" + String(max_bedrooms)
        relPath = relPath + "&bedrooms=" // + String(bedrooms) // Default "" blanck
        relPath = relPath + "&min_bathrooms=" + String(min_bathrooms)
        relPath = relPath + "&max_bathrooms=" + String(max_bathrooms)
        relPath = relPath + "&bathrooms=" // + String(bathrooms)  // Default "" blanck
        
        print(relPath)
        let escapedSearch = relPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let _ = getRequest(relPath: escapedSearch!, param: nil, block: block)
    }
/*//MARK: - Search filter property type API Calling
    func searchFilterPropertyType(location:String, page:Int, per_page:Int, luxury:String, check_in:String, check_out:String, min_price:Int, max_price:Int, min_sleeps:Int, max_sleeps:Int, min_bedrooms:Int, max_bedrooms:Int, bedrooms:Int, min_bathrooms:Int, max_bathrooms:Int, bathrooms:Int,filterType:[ModelSearchResultFilterType], block: @escaping WSBlock) {
        
        var relPath = WebURL.searchFilter
        
        relPath = relPath + "?location=" + location
        relPath = relPath + "&page=" + String(page)
        relPath = relPath + "&per_page=" + String(per_page)
        relPath = relPath + "&luxury=" + luxury
        relPath = relPath + "&check_in=" + check_in
        relPath = relPath + "&check_out=" + check_out
        relPath = relPath + "&min_price=" + String(min_price)
        relPath = relPath + "&max_price=" + String(max_price)
        relPath = relPath + "&min_sleeps=" + String(min_sleeps)
        relPath = relPath + "&max_sleeps=" + String(max_sleeps)
        relPath = relPath + "&min_bedrooms=" + String(min_bedrooms)
        relPath = relPath + "&max_bedrooms=" + String(max_bedrooms)
        relPath = relPath + "&bedrooms="  // + String(bedrooms) // Default "" blanck
        relPath = relPath + "&min_bathrooms=" + String(min_bathrooms)
        relPath = relPath + "&max_bathrooms=" + String(max_bathrooms)
        relPath = relPath + "&bathrooms=" // + String(bathrooms)  // Default "" blanck
        
        var i = 0
        for type in filterType {
            
            var j = 0
            
            for subType in type.category {
            
                if (i == 0 && subType.isSelected) {
                    //Amenities
                    relPath = relPath + "&amenities[\(j)]=" + subType.name.value
                    j = j + 1
                    
                } else if (i == 1 && subType.isSelected) {
                    //Property Type
                    
                    relPath = relPath + "&property_type[\(j)]=" + subType.name.name
                    j = j + 1
                    
                } else if (i == 2 && subType.isSelected) {
                    //Location Type
                    relPath = relPath + "&location_type[\(j)]=" + subType.name.name
                    j = j + 1
                }
            }
            i = i + 1
        }
        
        print(relPath)
        let escapedSearch = relPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(escapedSearch ?? "nil")
        let _ = getRequest(relPath: escapedSearch!, param: nil, block: block)
    }*/
//MARK: - Get property contacts API Calling
    func getPropertiesContacts(searchLocationID:String, block: @escaping WSBlock) {
        
        let relPath = WebURL.properties + "/" + searchLocationID + "/" + WebURL.propertiesContacts
        let escapedRelPath = relPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(escapedRelPath ?? "nil")
        let _ = getRequest(relPath: escapedRelPath!, param: nil, block: block)
    }
//MARK: - Get property API Calling
    func getProperties(searchLocationID:String, block: @escaping WSBlock) {
        
        let relPath = WebURL.properties + "/" + searchLocationID
        let escapedRelPath = relPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(escapedRelPath ?? "nil")
        let _ = getRequest(relPath: escapedRelPath!, param: nil, block: block)
    }
//MARK: - Get property reviews API Calling
    func getPropertiesReviews(searchLocationID:String, page:Int, per_page:Int, block: @escaping WSBlock) {
        
        var relPath = WebURL.properties + "/" + searchLocationID + "/" + WebURL.propertiesReviews
        
        relPath = relPath + "?page=" + String(page)
        relPath = relPath + "&per_page=" + String(per_page)
        relPath = relPath + "&status=all"
        
        let escapedRelPath = relPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(escapedRelPath ?? "nil")
        let _ = getRequest(relPath: escapedRelPath!, param: nil, block: block)
    }
//MARK: - Get property calendar API Calling
    func getPropertiesCalendar(searchLocationID:String, check_in:String, check_out:String, block: @escaping WSBlock) {
        
        var relPath = WebURL.properties + "/" + searchLocationID + "/" + WebURL.propertiesCalendar
        
        relPath = relPath + "?check_in=" + check_in
        relPath = relPath + "&check_out=" + check_out
        relPath = relPath + "&status=all"
        
        let escapedRelPath = relPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(escapedRelPath ?? "nil")
        let _ = getRequest(relPath: escapedRelPath!, param: nil, block: block)
    }
//MARK: - Terms use API Calling
    func termsUse(block: @escaping WSBlock) {
        
        let relPath = WebURL.termsUse
        let _ = getHTMLRequest(relPath: relPath, param: nil, block: block)
        
    }
//MARK: - Terms Privacy API Calling
    func termsPrivacy(block: @escaping WSBlock) {
        
        let relPath = WebURL.termsPrivacy
        let _ = getHTMLRequest(relPath: relPath, param: nil, block: block)
        
    }
//MARK: - Terms Payment API Calling
    func termsPayment(block: @escaping WSBlock) {
        
        let relPath = WebURL.termsPayment
        let _ = getHTMLRequest(relPath: relPath, param: nil, block: block)
        
    }
//MARK: - Terms epp API Calling
    func termsEPP(block: @escaping WSBlock) {
        
        let relPath = WebURL.termsEPP
        let _ = getHTMLRequest(relPath: relPath, param: nil, block: block)
        
    }
//MARK: - Terms srp API Calling
    func termsSRP(block: @escaping WSBlock) {
        
        let relPath = WebURL.termsSRP
        let _ = getHTMLRequest(relPath: relPath, param: nil, block: block)
        
    }
//MARK: - Terms credits API Calling
    func termsCredits(block: @escaping WSBlock) {
        
        let relPath = WebURL.termsCredits
        let _ = getHTMLRequest(relPath: relPath, param: nil, block: block)
        
    }
//MARK: - Terms referral API Calling
    func termsReferral(block: @escaping WSBlock) {
        
        let relPath = WebURL.termsReferral
        let _ = getHTMLRequest(relPath: relPath, param: nil, block: block)
        
    }
//MARK: - Register traveler API calling
    func registerTraveler(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.registerTraveler
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
//MARK: - Register owner API calling
    func registerOwner(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.registerOwner
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
//MARK: - Login API calling
    func login(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.logIn
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
//MARK: - Contact support API calling
    func contactSupport(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.contactSupport
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
//MARK: - Messages API calling
    func contactOwner(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.messages
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
//MARK: - Booking Check API Calling
    func bookingCheck(searchLocationID:String, check_in:String, check_out:String, adults:String, children:String, pets:String, block: @escaping WSBlock) {
        
        var relPath = WebURL.properties + "/" + searchLocationID + "/" + WebURL.checkPrice
        
        relPath = relPath + "?check_in=" + check_in
        relPath = relPath + "&check_out=" + check_out
        relPath = relPath + "&adults=" + adults
        relPath = relPath + "&children=" + children
        relPath = relPath + "&pets=" + pets
        
        let escapedRelPath = relPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print(escapedRelPath ?? "nil")
        let _ = getRequest(relPath: escapedRelPath!, param: nil, block: block)
    }
//MARK: - traveler booking API calling
    func travelerBooking(dictParam:[String : Any],block: @escaping WSBlock) {
        
        let relPath = WebURL.travelerBooking
        let _ = postRequest(relPath: relPath, param: dictParam, block: block)
    }
//MARK: - Properties Policies API Calling
    func getPropertiesPolicies(searchLocationID:String, block: @escaping WSBlock) {
        
        let relPath = WebURL.properties + "/" + searchLocationID + "/" + WebURL.propertiesPolicies
        let _ = getRequest(relPath: relPath, param: nil, block: block)
    }
//MARK: - Properties Rates API Calling
    func getPropertiesRates(searchLocationID:String, block: @escaping WSBlock) {
        
        let relPath = WebURL.properties + "/" + searchLocationID + "/" + WebURL.propertiesRates
        let _ = getRequest(relPath: relPath, param: nil, block: block)
    }
}*/
