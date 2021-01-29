//
//  CheckoutGuest.swift
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

class CheckoutGuest: Mappable {
    var message: String? = ""
    var cartItemIds: [String] = []
    var userDataGuest: CheckoutUserDataGuest = CheckoutUserDataGuest()
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        cartItemIds <- map["shopping_cart_items"]
        userDataGuest <- map["user_data"]
        message <- map["message"]
    }
}

