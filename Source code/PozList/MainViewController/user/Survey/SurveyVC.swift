//
//  SurveyVC.swift
//  PozList
//
//  Created by Devubha Manek on 09/10/17.
//  Copyright © 2017 Devubha Manek. All rights reserved.
//

import UIKit

class AnswerCell:UITableViewCell{
    
    @IBOutlet weak var img_checkMark: UIImageView!
    @IBOutlet weak var lbl_answer: UILabel!
    @IBOutlet weak var view_back: UIView!
    
}


class SurveyVC: UIViewController {

    
    @IBOutlet weak var count_lbl: UILabel!
    @IBOutlet weak var lbl_question: UILabel!
    @IBOutlet weak var table_view: UITableView!
    
    @IBOutlet weak var cons_height_table_view: NSLayoutConstraint!
    
    @IBOutlet weak var btn_next_submit: UIButton!
    
    var  arr_answewr = [["text":"a","status" : "0" ],["text":"b","status" : "0" ],["text":"c","status" : "0" ],["text":"d","status" : "0" ]]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.table_view.reloadData()
        DispatchQueue.main.async {
              self.table_view.reloadData()
            DispatchQueue.main.async {
                self.cons_height_table_view.constant =  self.table_view.contentSize.height
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Click Events
    @IBAction func click_close(_ sender: Any) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }
    
    @IBAction func Click_submitAnswer(_ sender: UIButton) {

    }
}

extension SurveyVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_answewr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = arr_answewr[indexPath.row]
        let status  = dict["status"]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell") as! AnswerCell
        cell.lbl_answer.text = dict["text"]
        
        if status == "1"{
        cell.view_back.backgroundColor = UIColor.appBackGroundColor()
            cell.img_checkMark.image = #imageLiteral(resourceName: "chec_mark")
        }else{
            cell.view_back.backgroundColor = UIColor.lightGray
            cell.img_checkMark.image = #imageLiteral(resourceName: "round")
        }
        cell.view_back.Round = true
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0...arr_answewr.count - 1 {
            var dict = arr_answewr[i]
            dict["status"] = "0"
            arr_answewr[i] = dict
        }
        var dict = arr_answewr[indexPath.row]
         dict["status"] = "1"
         arr_answewr[indexPath.row] = dict
        self.table_view.reloadData()
        DispatchQueue.main.async {
            self.cons_height_table_view.constant =  self.table_view.contentSize.height
        }
    }
    
}
