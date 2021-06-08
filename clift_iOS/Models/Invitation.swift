//
//  Invitation.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 12/3/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class Invitation: Mappable {
    
    var id = ""
    var message = ""
    var creatorName = ""
    var spouseName = ""
    var ceremonyPlace = ""
    var receptionPlace = ""
    var dressCode = Int()
    var locationCeremonyUrl = ""
    var locationReceptionUrl = ""
    var hasInvitedRelatives = false
    var relativeOne = ""
    var relativeTwo = ""
    var relativeThree = ""
    var relativeFour = ""

    var invitationTemplate: InvitationTemplate? = nil
    
    var errors: [String] = []

    
    convenience required init?(map: Map) {
        self.init()
    }
       
    func mapping(map: Map) {
        id <- map["id"]
        creatorName <- map["creator_name"]
        spouseName <- map["spouse_name"]
        ceremonyPlace <- map["ceremony_place"]
        receptionPlace <- map["reception_place"]
        locationCeremonyUrl <- map["location_ceremony_url"]
        locationReceptionUrl <- map["location_reception_url"]
        dressCode <- map["dress_code"]
        message <- map["message"]
        invitationTemplate <- map["invitation_template"]
        hasInvitedRelatives <- map["has_invited_relatives"]
        relativeOne <- map["relative_one"]
        relativeTwo <- map["relative_two"]
        relativeThree <- map["relative_three"]
        relativeFour <- map["relative_four"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}

//      Invitation JSON
//
//        "invitation": {
//          "message": "No esta muerto lo que yace eternamente y con el paso de eones hasta la muerte puede morir",
//          "creator_name": "Hermione Granger",
//          "spouse_name": "Deckard Cain",
//          "date": "Sun, 28 Jun 2020",
//          "ceremony_place": "Flourish & Blotts",
//          "start_time_ceremony": "Thu, 16 Jan 2020 08:05:47-0600",
//          "location_ceremony_url": "http://www.googlemapls.com/location_ceremony_url",
//          "reception_place": "Sinner's End",
//          "start_time_reception": "Fri, 17 Apr 2020 05:20:29 -0600",
//          "location_reception_url": "http://www.googlemapls.com/location_reception_url",
//          "dress_code": 1
//        }
//}
