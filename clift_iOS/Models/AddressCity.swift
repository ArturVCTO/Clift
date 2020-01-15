//
//  AddressCity.swift
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

class AddressCity: Mappable {
    var id = ""
    var name: String? = ""
    var code: String? = ""
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
