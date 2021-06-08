//
//  ExternalProduct.swift
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

class ExternalProduct: Mappable {
    var id = ""
    var name = ""
    var price = 0
    var note = ""
    var quantity = 0
    var shopName = ""
    var image: UIImage? = nil
    var imageUrl = ""
    var isImportant = Bool()
    var isCollaborative = Bool()
    var redirectToUrl = Bool()
    var url = ""
    var wishableType = "ExternalProduct"
    var gifted_quantity = Int()
    
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
        note <- map["note"]
        quantity <- map["quantity"]
        shopName <- map["shop_name"]
        imageUrl <- map["image_url"]
        image <- map["image"]
        isImportant <- map["is_important"]
        isCollaborative <- map["is_collaborative"]
        redirectToUrl <- map["redirect_to_url"]
        wishableType <- map["wishable_type"]
        url <- map["url"]
        gifted_quantity <- map ["gifted_quantity"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
