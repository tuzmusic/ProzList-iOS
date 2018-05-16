//
//  Card.swift
//  PozList
//
//  Created by Devubha Manek on 16/05/18.
//  Copyright © 2018 Devubha Manek. All rights reserved.
//

import UIKit

class Card: NSObject {
    var id: String = ""
    var card_cvc : String = ""
    var card_date : String = ""
    var card_holder_name : String = ""
    var card_number : String = ""
    var issubscribed : String = ""
    var status : String = ""
    var user_id : String = ""
    
    override init() {
        
    }
    
    init(id: String, card_cvc: String,card_date: String, card_holder_name: String, card_number: String, issubscribed: String, status:String, user_id:String)
    {
        self.id = id
        self.card_cvc = card_cvc
        self.card_date = card_date
        self.card_holder_name = card_holder_name
        self.card_number = card_number
        self.issubscribed = issubscribed
        self.status = status
        self.user_id = user_id
        
    }
}
