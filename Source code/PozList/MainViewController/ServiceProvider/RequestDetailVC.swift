
//
//  RequestDetailVC.swift
//  PozList
//
//  Created by Devubha Manek on 11/24/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class RequestDetailVC: UIViewController {

    @IBOutlet weak var lblNoImgs: UILabel!
    
    @IBOutlet weak var lblRequestDesc: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var ImagesView: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    var items:Int!
    var requestData:ServiceRequest!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblRatingPoint: UILabel!
    
    
    //MARK:- View initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        ImagesView.setNeedsLayout()
        ImagesView.layoutIfNeeded()
        
        self.setUpUI()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - All Acion Event

    @IBAction func btnDeclineClick(_ sender: Any) {
        self.requestAcceptAndDecline(status: "Rejected")
    }
    @IBAction func btnAcceptClick(_ sender: Any) {
        self.requestAcceptAndDecline(status: "Accepted")
    }
    @IBAction func click_bak(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpUI() {
        
        var str1 =  WebURL.ImageBaseUrl + requestData.customerProfile.profileImg
        str1 = str1.replacingOccurrences(of: " ", with: "%20")
        userProfileImg.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
        
        lblUserName.text = requestData.customerProfile.username
        if requestData.distance == "" {
            lblDistance.text = "0.00m"
        } else {
            lblDistance.text = requestData.distance + "m"
        }
        
        //Set rating
        if requestData.customerProfile.avgRating.length > 0{
            ratingView.rating = Double(requestData.customerProfile.avgRating)!
            lblRatingPoint.text = requestData.customerProfile.avgRating + " Stars"
        }else{
            lblRatingPoint.text = "0 Star"
        }
        
        lblRequestDesc.text = requestData.serviceReqDesc
        lblAddress.text = requestData.address
        let arrImg = requestData.imagePath
        
        let count = arrImg.count
        
        if count > 5 {
            
            var height:Int = Int(ImagesView.frame.size.height)
            var width:Int = Int(ImagesView.frame.size.width / 2)
            var x = 0
            var y = 0
            
            let view = UIImageView()
            view.backgroundColor = UIColor.red
            view.cornerRadius = 8
            view.frame = CGRect(x: x, y: y, width: width - 2, height: height)
            x += width
            var str1 =  WebURL.ImageBaseUrl + arrImg[0]
            str1 = str1.replacingOccurrences(of: " ", with: "%20")
            view.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
            ImagesView.addSubview(view)
            
            width = width / 2
            height = height / 2
            var k = 1
            for _ in 1...2 {
                var innerX:Int  = x
                
                for _ in 1...2 {
                    
                    let view = UIImageView()
                    view.backgroundColor = UIColor.red
                    view.cornerRadius = 8
                    view.frame = CGRect(x: innerX, y: y, width: width - 2, height: height - 1)
                    var str1 =  WebURL.ImageBaseUrl + arrImg[k]
                    str1 = str1.replacingOccurrences(of: " ", with: "%20")
                    view.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
                    ImagesView.addSubview(view)
                    
                    if k == 4 {
                        let btnTotal = UIButton()
                        btnTotal.backgroundColor = UIColor.red
                        btnTotal.cornerRadius = 8
                        btnTotal.frame = CGRect(x: innerX, y: y, width: width - 2, height: height - 1)
                        innerX += width
                        btnTotal.setTitle("+" + String(count), for: .normal)
                        ImagesView.addSubview(btnTotal)
                    }
                    else {
                        innerX += width
                        k += 1
                    }
                }
                y += height + 1
            }
        } else if  count > 4 {
            
            var height:Int = Int(ImagesView.frame.size.height)
            var width:Int = Int(ImagesView.frame.size.width / 2)
            var x = 0
            var y = 0
            
            let view = UIImageView()
            view.backgroundColor = UIColor.red
            view.cornerRadius = 8
            view.frame = CGRect(x: x, y: y, width: width - 2, height: height)
            x += width
            var str1 =  WebURL.ImageBaseUrl + arrImg[0]
            str1 = str1.replacingOccurrences(of: " ", with: "%20")
            view.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
            ImagesView.addSubview(view)
            
            width = width / 2
            height = height / 2
            var k = 1
            for _ in 1...2 {
                var innerX:Int  = x
                
                for _ in 1...2 {
                    
                    let view = UIImageView()
                    view.backgroundColor = UIColor.red
                    view.cornerRadius = 8
                    view.frame = CGRect(x: innerX, y: y, width: width - 2, height: height - 1)
                    innerX += width
                    var str1 =  WebURL.ImageBaseUrl + arrImg[k]
                    str1 = str1.replacingOccurrences(of: " ", with: "%20")
                    view.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
                    ImagesView.addSubview(view)
                    k += 1
                }
                y += height + 1
            }
        }  else if count > 3 {
            
            var height:Int = Int(ImagesView.frame.size.height)
            var width:Int = Int(ImagesView.frame.size.width / 2)
            var x = 0
            var y = 0
            
            let view = UIImageView()
            view.backgroundColor = UIColor.red
            view.cornerRadius = 8
            view.frame = CGRect(x: x, y: y, width: width - 2, height: height)
            x += width
            var str1 =  WebURL.ImageBaseUrl + arrImg[0]
            str1 = str1.replacingOccurrences(of: " ", with: "%20")
            view.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
            ImagesView.addSubview(view)
            
            width = width / 2
            height = height / 2
            var k = 1
            for i in (1...2).reversed() {
                var innerX:Int  = x
                
                for _ in (1...i).reversed(){
                    
                    let view = UIImageView()
                    view.backgroundColor = UIColor.red
                    view.cornerRadius = 8
                    view.frame = CGRect(x: innerX, y: y, width: width - 2, height: height - 1)
                    innerX += width
                    var str1 =  WebURL.ImageBaseUrl + arrImg[k]
                    str1 = str1.replacingOccurrences(of: " ", with: "%20")
                    view.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
                    ImagesView.addSubview(view)
                    k += 1
                }
                y += height + 1
            }
        } else if count > 2 {
            
            var height:Int = Int(ImagesView.frame.size.height)
            var width:Int = Int(ImagesView.frame.size.width / 2)
            var x = 0
            let y = 0
            
            let view = UIImageView()
            view.backgroundColor = UIColor.red
            view.cornerRadius = 8
            view.frame = CGRect(x: x, y: y, width: width - 2, height: height)
            x += width
            var str1 =  WebURL.ImageBaseUrl + arrImg[0]
            str1 = str1.replacingOccurrences(of: " ", with: "%20")
            view.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
            ImagesView.addSubview(view)
            
            width = width / 2
            height = height / 2
            
            var innerX:Int  = x
            for i in 1...2 {
                
                let view = UIImageView()
                view.backgroundColor = UIColor.red
                view.cornerRadius = 8
                view.frame = CGRect(x: innerX, y: y, width: width - 2, height: height - 1)
                var str1 =  WebURL.ImageBaseUrl + arrImg[i]
                str1 = str1.replacingOccurrences(of: " ", with: "%20")
                view.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
                innerX += width
                ImagesView.addSubview(view)
            }
            
        } else if count > 1 {
            
            let height:Int = Int(ImagesView.frame.size.height)
            let width:Int = Int(ImagesView.frame.size.width / 2)
            var x = 0
            let y = 0
            
            for i in 0...1 {
                
                let view = UIImageView()
                view.backgroundColor = UIColor.red
                view.cornerRadius = 8
                view.frame = CGRect(x: x, y: y, width: width - 2, height: height - 1)
                x += width
                var str1 =  WebURL.ImageBaseUrl + arrImg[i]
                str1 = str1.replacingOccurrences(of: " ", with: "%20")
                view.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
                ImagesView.addSubview(view)
            }
            
        } else if count > 0 {
            
            let view = UIImageView()
            view.backgroundColor = UIColor.red
            view.cornerRadius = 8
            view.frame = CGRect(x: 0, y: 0, width: ImagesView.frame.size.width, height: ImagesView.frame.size.height)
            var str1 =  WebURL.ImageBaseUrl + arrImg[0]
            str1 = str1.replacingOccurrences(of: " ", with: "%20")
            view.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
            ImagesView.addSubview(view)
            
        } else {
            ImagesView.isHidden = true
            lblNoImgs.isHidden = false
        }
    }
    
   
}

// MARK: - Webservice call

extension RequestDetailVC {
    
    func requestAcceptAndDecline(status:String) {
        
        var dic = [String:Any]()
        let userid = UserDefaults.Main.string(forKey: .UserID)
        dic["user_id"] = userid
        dic["status"] = status
        dic["request_id"] = requestData.id
        //Gautam - Pass Distance and Duration in API
        
        
        
//        if status == "" {
//            dic["distance"] = requestData.id
//        }
        
        appDelegate.showLoadingIndicator()
        MTWebCall.call.requestAcceptAndDecline(dictParam: dic) { (respons, status) in
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
                    appDelegate.Popup(Message: "\(message)")
                    
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
