//
//  ShoppingCart.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/29/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class ShoppingCart: Mappable {
    var id: String? = ""
    var userId: String? = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userId <- map["user_id"]
    }
}
