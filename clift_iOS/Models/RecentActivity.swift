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

class RecentActivityUser: Object, Mappable {
    var name: String = ""

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
    }
    
}

class RecentActivity: Object, Mappable {
    
    enum ActivityType: Int {
        case assistance = 0
        case physicalGift = 1
        case cashGift = 2
        var description: String {
            switch self {
            case .assistance:
                return "ha confirmado su asistencia"
            case .physicalGift:
                return "te ha regalado"
            case .cashGift:
                return "ha contribuido en un sobre."
            }
        }
    }
    
    var id = ""
    var user: RecentActivityUser = RecentActivityUser()
    var activityType = ActivityType.assistance
    private var createdDateString = ""
    
    var createdDate: String {
        let getFormatter = DateFormatter()
        getFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = getFormatter.date(from: createdDateString) else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd / MM / yy - hh:mm a"
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: date)
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user <- map["content"]
        activityType <- map["activity_type"]
        user <- map["user"]
        createdDateString <- map["created_at"]
    }
}
