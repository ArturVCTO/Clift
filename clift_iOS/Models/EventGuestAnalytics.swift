//
//  EventGuestAnalytics.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 12/15/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class EventGuestAnalytics: Mappable {
    
    var total = 0
    var willAttend = 0
    var pending = 0
    var willNotAttend = 0
    
    var errors: [String] = []

    
    convenience required init?(map: Map) {
        self.init()
    }
       
    func mapping(map: Map) {
        total <- map["total"]
        willAttend <- map["will_attend"]
        pending <- map["pending"]
        willNotAttend <- map["will_not_attend"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
