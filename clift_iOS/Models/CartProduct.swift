//
//  CartProduct.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/16/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class CartItem: Mappable, CustomStringConvertible {
    var description: String {
        return "CartItem #\(id) (\(product?.shop.name ?? ""))"
    }
    
    var id = ""
    var name: String? = ""
    var wishableType: String? = ""
    var quantity: Int? = 0
    var productCost: Int? = 0
    var availableStatus: Bool? = false
    var product: Product? = nil
    var eventProduct: EventProduct? = nil
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        product <- map["product"]
        eventProduct <- map["event_product"]
        name <- map["name"]
        quantity <- map["quantity"]
        productCost <- map["cost"]
        availableStatus <- map["status"]
    }
}
