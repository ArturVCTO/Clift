//
//  EventPool.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/6/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class EventPool: Mappable {

    var collectedAmount = ""
    var description = ""
    var goal = ""
    var id = ""
    var imageUrl = ""
    var isImportant = Bool()
    var isPriceVisible = Bool()
    var note = ""
    var suggestedAmount = ""
    var image: UIImage? = nil
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        collectedAmount <- map["collected_amount"]
        description <- map["description"]
        goal <- map["goal"]
        id <- map["id"]
        imageUrl <- map["image_url"]
        isImportant <- map["is_important"]
        isPriceVisible <- map["is_price_visible"]
        note <- map["note"]
        suggestedAmount <- map["suggested_amount"]
        image <- map["image"]
        
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
