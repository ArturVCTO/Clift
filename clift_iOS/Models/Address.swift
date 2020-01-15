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
    var firstName: String? = ""
    var lastName: String? = ""
    var email: String = ""
    var cellPhoneNumber: String? = ""
    var streetAndNumber: String? = ""
    var city = AddressCity()
    var state = AddressState()
    var country = AddressCountry()
    var zipCode: String? = ""
    var suburb: String? = ""
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        isDefault <- map["is_default"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        cellPhoneNumber <- map["cell_phone_number"]
        streetAndNumber <- map["street_and_number"]
        city <- map["city"]
        state <- map["state"]
        country <- map["country"]
        zipCode <- map["zip_code"]
        suburb <- map["suburb"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
