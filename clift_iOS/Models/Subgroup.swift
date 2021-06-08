//
//  Subgropus.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/24/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class Subgroup: Mappable {
    
    var id = ""
    var name = ""
    var imageUrl = ""
    var products: [Product] = []
    
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        products <- map["products"]
        imageUrl <- map["image_url"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
