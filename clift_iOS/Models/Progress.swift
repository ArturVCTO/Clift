//
//  Progress.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/28/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class EventProgress: Object, Mappable {
    
    var productsHaveBeenAdded = false
    var invitationHasBeenChosen = false
    var guestsHaveBeenInvited = false
    var visibilityHasBeenSet = false
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        productsHaveBeenAdded <- map["products_have_been_added"]
        invitationHasBeenChosen <- map["invitation_has_been_chosen"]
        guestsHaveBeenInvited <- map["guests_have_been_invited"]
        visibilityHasBeenSet <- map["visibility_has_been_set"]
    }
}
