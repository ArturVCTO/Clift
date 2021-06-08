//
//  StripeAccountToken.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 2/27/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class StripeAccountToken: Mappable {
    var token: String? = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        token <- map["token"]
    }
}
