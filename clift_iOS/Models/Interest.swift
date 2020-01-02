//
//  Interest.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/13/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class Interest: Object, Mappable {
    
    var id = ""
    var interestId = ""
    var imageUrl = ""
    var name = ""
    var isActive = false
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        interestId <- map["interest_id"]
        imageUrl <- map["image_url"]
        name <- map["name.es"]
        isActive <- map["is_active"]
    }
}
