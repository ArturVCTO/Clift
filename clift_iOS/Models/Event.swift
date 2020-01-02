//
//  Event.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/13/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class Event: Object, Mappable {
    
    @objc dynamic var id = ""
    var eventType = 0
    var date = ""
    var name = ""
    var interests = [Interest]()
    var visibility = 0
    var eventProgress = EventProgress()
    var eventImage: UIImage? = nil
    var coverImage: UIImage? = nil
    var eventImageUrl = ""
    var coverImageUrl = ""
    var eventAnalytics = EventAnalytics()
    var recentActivity = [RecentActivity]()
    var recommendations = [EventRecommendation]()
    var creator: User? = nil
    var invitation = Invitation()
    var errors: [String] = []

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        eventType <- map["event_type"]
        date <- map["date"]
        name <- map["name"]
        creator <- map["creator"]
        interests <- map["interests"]
        visibility <- map["visibility"]
        eventProgress <- map["progress"]
        eventImageUrl <- map["event_image_url"]
        eventImage <- map["event_image"]
        coverImage <- map["cover_image"]
        coverImageUrl <- map["cover_image_url"]
        eventAnalytics <- map["analytics"]
        recentActivity <- map["recent_activity"]
        recommendations <- map["recommendations"]
        invitation <- map["invitation"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
    
    
}
