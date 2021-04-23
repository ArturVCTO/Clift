//
//  ShippingAddress.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 23/04/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class ShippingAddress: Mappable {
    var streetAndNumber: String? = ""
    var zipCode: String? = ""
    var addressStateId: String? = ""
    var addressCityId: String? = ""
    var suburb: String? = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        streetAndNumber <- map["street_and_number"]
        zipCode <- map["zipcode"]
        addressStateId <- map["address_state_id"]
        addressCityId <- map["address_city_id"]
        suburb <- map["suburb"]
    }
}
