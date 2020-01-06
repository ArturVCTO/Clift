//
//  CliftColor.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/16/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class CliftColor: Mappable {
    
    var id = ""
    var name = ""
    var hexCode = ""
    var products: [Product] = []
    
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        hexCode <- map["hex_code"]
        products <- map["products"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
