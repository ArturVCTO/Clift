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
    var id: String? = ""
    var email: String? = ""
    var shippingAddress: String? = ""
    var cellPhoneNumber: String? = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
        shippingAddress <- map["shipping_address"]
        cellPhoneNumber <- map["cell_phone_number"]
    }
}
