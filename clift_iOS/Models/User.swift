//
//  User.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/13/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class User: Mappable {
    
    var id = ""
    var name = ""
    var lastName = ""
    var email = ""
    var cellPhoneNumber = ""
    var imageUrl = ""
    var image: UIImage? = nil
    var event = Event()
    var spouse = Spouse()
    var password = ""
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        lastName <- map["last_name"]
        email <- map["email"]
        cellPhoneNumber <- map["cell_phone_number"]
        event <- map["event"]
        spouse <- map["spouse"]
        password <- map["password"]
        imageUrl <- map["image_url"]
        image <- map["image"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
    
    func fullName() -> (String) {
        return "\(self.name) \(self.lastName)"
    }
}
