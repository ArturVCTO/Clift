//
//  CheckoutUserDataEnvelope.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 16/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class CheckoutUserDatapeEnvelope: Mappable {
    var cellPhoneNumber: String? = ""
    var email: String? = ""
    var name: String? = ""
    var lastName: String? = ""
    var note: String? = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        cellPhoneNumber <- map["cell_phone_number"]
        email <- map["email"]
        name <- map["name"]
        lastName <- map["last_name"]
        note <- map["note"]
    }
}
