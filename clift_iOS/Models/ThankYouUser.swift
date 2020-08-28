//
//  ThankYouUser.swift
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

class ThankYouUser: Mappable {
    var id: String? = ""
    var email: String? = ""
    var lastName: String? = ""
    var phone: String? = ""
    var name: String? = ""
    var note: String? = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
        lastName <- map["last_name"]
        phone <- map["cell_phone_number"]
        name <- map["name"]
        note <- map["note"]
    }
}
