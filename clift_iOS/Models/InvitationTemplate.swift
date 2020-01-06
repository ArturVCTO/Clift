//
//  InvitationTemplate.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/29/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class InvitationTemplate: Mappable {
    var name = ""
    var id: String? = nil
    var imageUrl = ""
    var thumbnailUrl = ""
    var eventType = ""
    var templateArrangement = 0
    
    
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        imageUrl <- map["image_url"]
        thumbnailUrl <- map["thumbnail_url"]
        eventType <- map["event_type"]
        templateArrangement <- map["template_arrangement"]
    }
}
