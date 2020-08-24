//
//  EventProduct.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/21/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class EventProduct: Mappable {
    var id = ""
    var name = ""
    var status = ""
    var event = Event()
    var product = Product()
    var externalProduct = ExternalProduct()
    var gifted_quantity = Int()
    var quantity = Int()
    var paidAmount = ""
    var setImportant = Bool()
    var isImportant = false
    var setCollaborative = Bool()
    var isCollaborative = false
    var wishableType = ""
    var hasBeenThanked = false
    var hasBeenPaid = false
    var thankMessage = ""
    var thankYouUser: ThankYouUser?
    var guestData: Dictionary<String,[ThankYouUser]>?
    var collaborators = Int()
    var orderItems: [OrderItem]?
    
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        event <- map["event"]
        product <- map["product"]
        quantity <- map["quantity"]
        gifted_quantity <- map ["gifted_quantity"]
        paidAmount <- map["paid_amount"]
        setImportant <- map["set_important"]
        isImportant <- map["is_important"]
        externalProduct <- map["external_product"]
        setCollaborative <- map["set_collaborative"]
        isCollaborative <- map["is_collaborative"]
        wishableType <- map["wishable_type"]
        hasBeenPaid <- map["has_been_paid"]
        hasBeenThanked <- map["has_been_thanked"]
        thankMessage <- map["thank_message"]
        thankYouUser <- map["user"]
        guestData <- map["guest_data"]
        collaborators <- map["collaborators"]
        status <- map["status"]
        
        orderItems <- map["order_items"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}

