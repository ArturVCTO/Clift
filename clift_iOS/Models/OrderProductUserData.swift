//
//  OrderProduct.swift
//  clift_iOS
//
//  Created by David Mar on 3/21/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class OrderProduct: Mappable {
    
    var id = ""
    var userData = OrderProductUserData()
    var orderType = ""
    var status = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userData <- map["user_data"]
        orderType <- map["order_type"]
        status <- map["status"]
    }
    
}

class OrderProductUserData: Mappable {
    
    var name = ""
    var note = ""
    var email = ""
    var lastName = ""
    var shippingAddress = ""
    var cellPhoneNumber = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        note <- map["note"]
        email <- map["email"]
        lastName <- map["last_name"]
        shippingAddress <- map["shipping_address"]
        cellPhoneNumber <- map["cell_phone_number"]
    }
}
