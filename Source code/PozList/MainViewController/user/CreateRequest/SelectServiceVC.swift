//
//  SelectServiceVC.swift
//  ProzList
//
//  Created on 28/09/17.
//  Copyright © 2017. All rights reserved.
//

class CreateReq_main: UITableViewCell{
    
    @IBOutlet weak var img_bag: UIImageView!
    @IBOutlet weak var img_arrow: UIImageView!
    @IBOutlet weak var img_icon: UIImageView!
     @IBOutlet weak var lbl_service_name: UILabel!
}

import UIKit

class SelectServiceVC: UIViewController {
    
    //var arr_service_list = [["Service":"Plumbing","img":#imageLiteral(resourceName: "plumbing")],["Service":"Eletrical","img":#imageLiteral(resourceName: "electricle")],["Service":"HVAC","img":#imageLiteral(resourceName: "HVAC")],["Service":"Handyman","img":#imageLiteral(resourceName: "handyman")]]
    var arr_service_list = [Service]()
    var arr_servic_icon:[UIImage] = [#imageLiteral(resourceName: "plumbing"),#imageLiteral(resourceName: "electricle"),#imageLiteral(resourceName: "HVAC"),#imageLiteral(resourceName: "handyman")]
    
    @IBOutlet var tblServiceList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
    }
	
    @IBAction func ClickMenu(_ sender: UIButton) {
          self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.arr_service_list.removeAll()
        self.getServiceList()
    }
    
    func getServiceList() {
        
        let dic = [String:Any]()
        appDelegate.showLoadingIndicator()
        MTWebCall.call.getServiceCat(dictParam: dic) { (respons, status) in
            appDelegate.hideLoadingIndicator()
            if (status == 200 && respons != nil) {
                //Response
                let dictResponse = respons as! NSDictionary
                
                let Response = getStringFromDictionary(dictionary: dictResponse, key: "response")
                if Response == "true"
                {
                    let message = getStringFromDictionary(dictionary: dictResponse, key: "msg")
                    print(message)
                    let arrCat = getArrayFromDictionary(dictionary: dictResponse, key: "data")
                    
                    self.arr_service_list.removeAll()
                    
                    for i in 0...arrCat.count - 1 {
                        let catValue = arrCat[i] as! NSDictionary
                        
                        let id = createString(value:catValue.value(forKey: "id") as AnyObject)
                        let sName = createString(value:catValue.value(forKey: "name") as AnyObject)
                        let status = createString(value:catValue.value(forKey: "status") as AnyObject)
                        let imgPath = createString(value:catValue.value(forKey: "image") as AnyObject)
                        let service = Service.init(id: id, servicename: sName, status: status, imagepath: imgPath)
                        
                        self.arr_service_list.append(service)
                        print("data service \(catValue)")
                    }
                    print("count service \(self.arr_service_list.count)")
                    self.tblServiceList.reloadData()
                }else {
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
extension SelectServiceVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 4
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_service_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let service = arr_service_list[indexPath.row] as Service
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateReq_main") as! CreateReq_main
        cell.img_icon.image = arr_servic_icon[indexPath.row] as UIImage
        
        cell.lbl_service_name.text = service.servicename
        
       // cell.img_bag.setShowActivityIndicator(true)
       // cell.img_bag.setIndicatorStyle(.gray)
        var str1 =  WebURL.ImageBaseUrl + service.imagePath
        str1 = str1.replacingOccurrences(of: " ", with: "%20")
        cell.img_bag.sd_setImage(with: URL.init(string: str1), placeholderImage: UIImage.init(named: "121212"), options: .refreshCached)
        cell.img_arrow.image = #imageLiteral(resourceName: "right_arrow")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0...arr_service_list.count - 1 {
            let dict = arr_service_list[i] as Service
            dict.isSelected = false
        }
        let service = arr_service_list[indexPath.row] as Service
        service.isSelected = true
        let vc = storyBoards.Customer.instantiateViewController(withIdentifier: "ServiceReqDetailVC") as! ServiceReqDetailVC
        vc.arr_service_list = arr_service_list
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
