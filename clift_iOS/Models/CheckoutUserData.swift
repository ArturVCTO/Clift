//
//  CheckoutUserData.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 2/4/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class CheckoutUserData: Mappable {
    var shippingAddress: String? = ""
    var email: String? = ""
    var cellPhoneNumber: String? = ""
    var name: String? = ""
    var lastName: String? = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        shippingAddress <- map["shipping_address"]
        email <- map["email"]
        cellPhoneNumber <- map["cell_phone_number"]
        name <- map["name"]
        lastName <- map["last_name"]
    }
}
