//
//  RecentActivity.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/28/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class RecentActivity: Object, Mappable {
    
    var id = ""
    var content = ""
    var activityType = 0
    var user = User()
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        content <- map["content"]
        activityType <- map["activity_type"]
        user <- map["user"]
    }
}
