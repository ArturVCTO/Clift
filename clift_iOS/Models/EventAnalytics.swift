//
//  EventAnalytics.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/28/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class EventAnalytics: Object, Mappable {
    
    var assistance = 0
    var giftCount = 0
    var thankYouNoteCount = 0
    var cashGiftTotal = 0
    var physicalGiftTotal = 0
    var thankYouNoteTotal = 0
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        assistance <- map["assistance"]
        giftCount <- map["gift_count"]
        thankYouNoteCount <- map["thank_you_note_count"]
        cashGiftTotal <- map["cash_gift_total"]
        physicalGiftTotal <- map["physical_gift_total"]
        thankYouNoteTotal <- map["thank_you_note_total"]
    }
}
