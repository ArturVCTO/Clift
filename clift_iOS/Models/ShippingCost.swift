//
//  ShippingCost.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 29/06/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class ShippingCost: Mappable {
    var shopId: String = ""
    var cost: String = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        shopId <- map["id"]
        cost <- map["cost"]
    }
}
