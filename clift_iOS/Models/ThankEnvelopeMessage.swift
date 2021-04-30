//
//  ThankEnvelopeMessage.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 30/04/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class ThankEnvelopeMessage: Mappable {
    var name: String? = ""
    var thankMessage: String? = ""
    var email: String? = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        thankMessage <- map["thank_message"]
        email <- map["email"]
    }
}

