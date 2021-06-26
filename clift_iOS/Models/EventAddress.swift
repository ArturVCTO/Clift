//
//  EventAddress.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 23/06/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class EventAddress: Mappable {
    var addressState: AddressState = AddressState()
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        addressState <- map["address_state"]
    }
}
