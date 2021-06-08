//
//  Subcategory.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/12/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class Group: Mappable {
    
    var id = ""
    var name = ""
    var imageUrl = ""
    var subgroups: [Subgroup] = []
    
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        subgroups <- map["subgroups"]
        imageUrl <- map["image_url"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
