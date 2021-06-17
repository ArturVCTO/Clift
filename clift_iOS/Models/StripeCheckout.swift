//
//  StripeCheckout.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 2/4/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class StripeCheckout: Mappable {
    var id: String? = ""
    var successUrl: String? = ""
    var cancelUrl: String? = ""
    var clientSecret: String = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        successUrl <- map["success_url"]
        cancelUrl <- map["cancel_url"]
        clientSecret <- map["client_secret"]
    }
}
