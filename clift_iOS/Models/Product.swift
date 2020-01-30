//
//  Product.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/12/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class Product: Mappable {
    
    var id = ""
    var name = ""
    var price = 0
    var brand = Brand()
    var sku = ""
    var description = ""
    var specs = ""
    var color = CliftColor()
    var imageUrl = ""
    var shouldShowBrand = false
    var inStock = false
    var isInEvent = false
    var shippingCost = 0
    var shipping = false
    var shop = Shop()
    var categories: [Category] = []
    
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
        brand <- map["brand"]
        imageUrl <- map["image_url"]
        sku <- map["sku"]
        shop <- map["shop"]
        description <- map["description"]
        specs <- map["specs"]
        shippingCost <- map["shipping_cost"]
        shipping <- map["shipping"]
        color <- map["color"]
        inStock <- map["in_stock"]
        isInEvent <- map["is_in_event"]
        categories <- map["categories"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}

