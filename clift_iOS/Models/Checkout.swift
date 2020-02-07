//
//  Checkout.swift
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

class Checkout: Mappable {
    var id: String? = ""
    var cartItemIds: [String] = []
    var userData: CheckoutUserData?
    var message: String? = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        cartItemIds <- map["shopping_cart_items"]
        userData <- map["user_data"]
        message <- map["message"]
    }
}
