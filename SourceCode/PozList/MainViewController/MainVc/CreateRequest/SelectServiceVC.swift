//
//  SelectServiceVC.swift
//  ProzList
//
//  Created by Devubha Manek on 28/09/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

class CreateReq_main: UITableViewCell{
    
    @IBOutlet weak var img_bag: UIImageView!
    @IBOutlet weak var img_arrow: UIImageView!
    @IBOutlet weak var img_icon: UIImageView!
     @IBOutlet weak var lbl_service_name: UILabel!
}

import UIKit
import InteractiveSideMenu


class SelectServiceVC: UIViewController, SideMenuItemContent {
    
    var arr_service_list = [["Service":"Plumbing","img":#imageLiteral(resourceName: "plumbing")],["Service":"Eletrical","img":#imageLiteral(resourceName: "electricle")],["Service":"HVAC","img":#imageLiteral(resourceName: "HVAC")],["Service":"Plumbing","img":#imageLiteral(resourceName: "plumbing")],["Service":"Handyman","img":#imageLiteral(resourceName: "handyman")]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ClickMenu(_ sender: UIButton) {
          showSideMenu()
    }
}
extension SelectServiceVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_service_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = arr_service_list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateReq_main") as! CreateReq_main
        cell.img_icon.image = dict["img"] as? UIImage
        cell.lbl_service_name.text = dict["Service"] as? String
        cell.img_bag.image = #imageLiteral(resourceName: "back")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyBoards.Menu.instantiateViewController(withIdentifier: "ServiceReqDetailVC") as! ServiceReqDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
