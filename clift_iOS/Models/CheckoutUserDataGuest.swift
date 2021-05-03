//
//  CheckoutUserDataGuest.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 28/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class CheckoutUserDataGuest: Mappable {
    var name: String? = ""
    var lastName: String? = ""
    var email: String? = ""
    var shippingAddress: ShippingAddress = ShippingAddress()
    var cellPhoneNumber: String? = ""
    var note: String? = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        lastName <- map["last_name"]
        email <- map["email"]
        shippingAddress <- map["shipping_address"]
        cellPhoneNumber <- map["cell_phone_number"]
        note <- map["note"]
    }
}

