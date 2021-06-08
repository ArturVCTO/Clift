//
//  Spouse.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/13/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class Spouse: Mappable {
    
    var name = ""
    var lastName = ""
    var email = ""
    var cellPhoneNumber = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        lastName <- map["last_name"]
        email <- map["email"]
        cellPhoneNumber <- map["cell_phone_number"]
    }
    
    
}
