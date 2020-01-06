//
//  Shop.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/24/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class Shop: Mappable {

    var name = ""
    var id = ""
    var imageURL = ""
    var documents: [String] = []
    var products: [Product] = []
    var isActive = false
    
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        imageURL <- map["image_url"]
        products <- map["products"]
        documents <- map["documents"]
        isActive <- map["is_active"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
