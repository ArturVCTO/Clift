//
//  ThankMessage.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/26/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class ThankMessage: Mappable {
    var name: [String] = [String]()
    var thankMessage: String? = ""
    var email: [String] = [String]()
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        thankMessage <- map["thank_message"]
        email <- map["email"]
    }
}
