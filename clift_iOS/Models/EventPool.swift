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
    
    var id = ""
    var description = ""
    var amount = 0
    var note = ""
    var goal = ""
    var suggestedAmount = ""
    var image: UIImage? = nil
    var imageUrl = ""
    var isImportant = Bool()
    var isPriceVisible = Bool()
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        description <- map["description"]
        amount <- map["amount"]
        note <- map["note"]
        goal <- map["goal"]
        suggestedAmount <- map["suggested_amount"]
        imageUrl <- map["image_url"]
        image <- map["image"]
        isImportant <- map["is_important"]
        isPriceVisible <- map["is_price_visible"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
