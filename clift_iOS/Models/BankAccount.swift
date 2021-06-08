//
//  BankAccount.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/7/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class BankAccount: Mappable {
    var id = ""
    var user = User()
    var rfc = ""
    var bank = ""
    var owner = ""
    var accountName = ""
    var account = ""
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
//        user <- map["user"]
        owner <- map["owner"]
        account <- map["account"]
        bank <- map["bank"]
        accountName <- map["account_name"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
