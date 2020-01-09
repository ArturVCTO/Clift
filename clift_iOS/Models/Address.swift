//
//  Address.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/9/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class Address: Mappable {
    var id = ""
    var isDefault = false
    var name = ""
    var street1 = ""
    var city = AddressCity()
    var state = AddressState()
    var country = AddressCountry()
    
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        isDefault <- map["is_default"]
        name <- map["name"]
        street1 <- map["street_1"]
        city <- map["city"]
        
    }
}
