//
//  EventGuest.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 12/3/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift
import Contacts

class EventGuest: Mappable {
    
    var id = ""
    var name = ""
    var email = ""
    var status = false
    var isConfirmed = ""
    var cellPhoneNumber = ""
    var eventId = ""
    var userId = ""
    var has_plus_one = false
    var companion_name = ""
    var address = ""
    
    var errors: [String] = []

    
    convenience required init?(map: Map) {
        self.init()
    }
       
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
        status <- map["status"]
        isConfirmed <- map["is_confirmed"]
        cellPhoneNumber <- map["cell_phone_number"]
        eventId <- map["event_id"]
        userId <- map["user_id"]
        has_plus_one <- map["has_plus_one"]
        companion_name <- map["companion_name"]
        address <- map["address"]
        
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
