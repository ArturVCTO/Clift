//
//  EventRecommendation.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/28/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class EventRecommendation: Object, Mappable {
    
    var registeredCount = 0
    var giftedCount = 0
    var idealCount = 0
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        registeredCount <- map["registered_count"]
        giftedCount <- map["gifted_count"]
        idealCount <- map["ideal_count"]
    }
}
