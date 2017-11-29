//
//  CurrentReqDetailVC.swift
//  PozList
//
//  Created by Devubha Manek on 11/29/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class CurrentReqDetailVC: UIViewController {

    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var lblNoImgs: UILabel!
    
    @IBOutlet weak var lblRequestDesc: UILabel!
    @IBOutlet weak var lblRequestAddress: UILabel!
    @IBOutlet weak var lblRequestReview: UILabel!
    @IBOutlet weak var lblRequestReviewTitle: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var ImagesView: UIView!
    var isFromCurrentReq:Bool!
    
    @IBOutlet weak var reviewView: UIView!
    var requestData:ServiceRequest!
    
    @IBOutlet weak var reviweViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        ImagesView.setNeedsLayout()
        ImagesView.layoutIfNeeded()
        
        if isFromCurrentReq {
            lblRequestReviewTitle.text = ""
            lblRequestReview.text = ""
            reviweViewHeight.constant = 0
            reviewView.clipsToBounds = true
        }
        
        self.setUpUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    @IBAction func btnCompleteClick(_ sender: Any) {
        let vc = storyBoards.ServiceProvider.instantiateViewController(withIdentifier: "RatingAndReviewVC") as! RatingAndReviewVC
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    func setUpUI() {
        
        var str1 =  WebURL.ImageBaseUrl + requestData.customerProfile.profileImg
        str1 = str1.replacingOccurrences(of: " ", with: "%20")
        userProfileImg.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
        
        lblUserName.text = requestData.customerProfile.username
        lblDistance.text = requestData.distance + "m"
        
        lblRequestDesc.text = requestData.serviceReqDesc
        lblRequestAddress.text = requestData.address
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
