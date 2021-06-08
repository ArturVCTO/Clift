//
//  OnboardingShippingAddress.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 5/14/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class OnboardingShippingAddress: Mappable {
    var streetAndNumber = ""
    var zipCode = ""
    var addressStateId = ""
    var addressCityId = ""
    var suburb = ""
    var cellPhoneNumber = ""
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        streetAndNumber <- map["street_and_number"]
        zipCode <- map["zip_code"]
        addressStateId <- map["address_state_id"]
        addressCityId <- map["address_city_id"]
        cellPhoneNumber <- map["cell_phone_number"]
        suburb <- map["suburb"]
    }
}
