//
//  CheckoutEnvelope.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 16/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class CheckoutEnvelope: Mappable {
    var amount: Double?
    var userData: CheckoutUserDatapeEnvelope?
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        amount <- map["amount"]
        userData <- map["user_data"]
    }
}
