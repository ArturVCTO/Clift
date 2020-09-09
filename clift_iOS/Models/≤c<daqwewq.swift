//
//  OrderItem.swift
//  clift_iOS
//
//  Created by Lizzie Guajardo on 24/08/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class OrderItem: Mappable {
    
    var id = ""
    var quantity = Int()
    var hasBeenThanked = Bool()
    var thankMessage = ""
    var amount = ""
    var status = ""
    var orderId = ""
    
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        quantity <- map["quantity"]
        hasBeenThanked <- map["has_been_thanked"]
        thankMessage <- map["thank_message"]
        amount <- map["amount" ]
        status <- map["status"]
        orderId <- map["order_id"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
