//
//  CashGiftItem.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 09/04/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class CashGiftItem: Mappable {
    
    var id = ""
    var amount = ""
    var order = OrderProduct()
    var eventPool = EventPool()
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        amount <- map["amount"]
        order <- map["order"]
        eventPool <- map["event_pool"]
    }
}
