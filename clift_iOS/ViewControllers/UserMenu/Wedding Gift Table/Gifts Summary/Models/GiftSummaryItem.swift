//
//  GiftSummaryItem.swift
//  clift_iOS
//
//  Created by David Mar on 3/18/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

struct GiftsSummaryParams {
    
    enum Status {
        case requested
        case declined
    }
    
    var collaborative: Bool?
    var status: Status?
}

class GiftSummaryItem: Mappable {
    
    var id = ""
    var eventProduct = EventProduct()
    var order = OrderProduct()
    var hasBeenThanked = false
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        eventProduct <- map["event_product"]
        id <- map["id"]
        order <- map["order"]
        hasBeenThanked <- map["has_been_thanked"]
    }
    
}
