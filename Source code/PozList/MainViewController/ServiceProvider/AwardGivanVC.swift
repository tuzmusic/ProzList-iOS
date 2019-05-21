//
//  AwardGivanVC.swift
//  PozList
//
//  Created on 12/1/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class AwardCell : UITableViewCell { // Table cell

    @IBOutlet weak var imgAwardType: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
}

class AwardGivanVC: UIViewController {
    
    // Outlets
    @IBOutlet var tblAwardList: UITableView!
    @IBOutlet weak var lblNoAwardFound: UILabel!
    
    // Variables
    var arrAwardList = [Award]()
    var arrayOfIndexpath = [IndexPath]()

    //MARK: - View initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        arrAwardList.removeAll()
        self.getAwardList()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ClickMenu(_ sender: UIButton) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    // MARK: - WebService call
    func getAwardList() {
        
        let dict = [String:Any]()
//        let userid = UserDefaults.Main.string(forKey: .UserID)
        let userid = "60"
        
        appDelegate.showLoadingIndicator()
        
        MTWebCall.call.getAwards(userId: userid, dictParam: dict) { (response ,status) in
            
            appDelegate.hideLoadingIndicator()
            
            jprint(items: status)
            if (status == 200 && response != nil) {
                //Response
                let dictResponse = response as! NSDictionary
                
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

                            let dictData = getDictionaryFromDictionary(dictionary: catValue, key: "award_detail")
                            let id = createString(value:dictData.value(forKey: "id") as AnyObject)
                            let award_name = createString(value: dictData.value(forKey: "award_name") as AnyObject)
                            let description = createString(value: dictData.value(forKey: "description") as AnyObject)
                            let awardDate = createString(value: dictData.value(forKey: "created_at") as AnyObject)
                            let awardUpdateDate = createString(value: dictData.value(forKey: "updated_at") as AnyObject)
                            let awardTag = createString(value: dictData.value(forKey: "tag_line") as AnyObject)
                            
                            let awardData = Award.init(id: id, awardName: award_name, awardDesc: description, awardDate: awardDate, awardUpdateDate: awardUpdateDate, awardTag: awardTag)
                            
                            self.arrAwardList.append(awardData)
                            
                        }
                    }
                    
                    self.tblAwardList.reloadData()
                    
                    if self.arrAwardList.count == 0{
                        self.lblNoAwardFound.isHidden = false
                    }else{
                        self.lblNoAwardFound.isHidden = true
                    }
                    
                } else {
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

// MARK: - TableView Delegates
extension AwardGivanVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAwardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AwardCell") as! AwardCell
        
        let service = arrAwardList[indexPath.row] as Award
        
        if arrayOfIndexpath.contains(indexPath){
            cell.lblDesc.numberOfLines = 0
        }else{
            cell.lblDesc.numberOfLines = 2
        }
        
        if service.awardTag == "Gold" {
            cell.imgAwardType.image = #imageLiteral(resourceName: "gold")
        } else if service.awardTag == "Platinum" {
            cell.imgAwardType.image = #imageLiteral(resourceName: "platinum")
        } else {
            cell.imgAwardType.image = #imageLiteral(resourceName: "silver")
        }
        
        cell.lblTitle.text = service.awardName
        cell.lblDesc.text = service.awardDesc
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrayOfIndexpath.contains(indexPath){
            let index = arrayOfIndexpath.index(of: indexPath)
            arrayOfIndexpath.remove(at: index!)
        }else{
            arrayOfIndexpath.append(indexPath)
        }
        tblAwardList.reloadData()
       
    }
}






