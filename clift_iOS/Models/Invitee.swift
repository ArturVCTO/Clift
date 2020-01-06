//
//  Invitee.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/21/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class Invitee: Mappable {
    var name = ""
    var email = ""
    var cellphoneNumber = ""
    var isInvited: Int? = nil
    var isConfirmed: Bool? = nil
    var event = Event()
    var user = User()
    
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        cellphoneNumber <- map["cellphone"]
        isInvited <- map["is_invited"]
        isConfirmed <- map["is_confirmed"]
        
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
