//
//  CreditMovement.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 3/4/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class CreditMovement: Mappable {
    var id = ""
    var movementType = 0
    var amount = 0.0
    var event = Event()
    var reason = ""
    var createdAt = ""
    var shop = Shop()
    var user = User()
    var customer = User()
    var product = Product()
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        amount <- map["amount"]
        reason <- map["reason"]
        customer <- map["customer"]
        movementType <- map["movement_type"]
        createdAt <- map["created_at"]
        product <- map["product"]
        shop <- map["shop"]
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}


