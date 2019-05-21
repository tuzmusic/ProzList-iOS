//
//  ReviewDetailVC.swift
//  PozList
//
//  Created on 08/02/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ReviewDetailVC: UIViewController {

    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var rateingView: CosmosView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    var reviewDetail : Review!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.size.height / 2.0
    }
    
    func setUpUi() {
        
        lblDescription.text = reviewDetail.review
        
        rateingView.rating = Double(reviewDetail.rate)!
        lblRate.text = reviewDetail.rate + " Stars"
        
        lblUserName.text = reviewDetail.cutomerProfile.username
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: NSLocale.current.identifier)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: reviewDetail.reviewDate)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        lblDate.text =  dateFormatter.string(from: date!)
        
        var str1 =  WebURL.ImageBaseUrl + reviewDetail.cutomerProfile.profileImg
        str1 = str1.replacingOccurrences(of: " ", with: "%20")
        imgUserProfile.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "user"), options: .refreshCached)
    }
    
    @IBAction func click_bak(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
