//
//  ShopCredit.swift
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

class ShopCredit: Mappable {
    var id = ""
    var code = ""
    var balance = 0.0
    var event = Event()
    var expirationDate = ""
    var shop = Shop()
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        code <- map["credit_code"]
        balance <- map["amount"]
        expirationDate <- map["expiration_date"]
        event <- map["event"]
        shop <- map["shop"]
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
