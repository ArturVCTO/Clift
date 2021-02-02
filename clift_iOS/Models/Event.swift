//
//  Event.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/13/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class Event: Object, Mappable {
    
    @objc dynamic var id = ""
    var eventType = 0
    var date = ""
    var name = ""
    var interests = [Interest]()
    var visibility = 0
    var eventProgress = EventProgress()
    var eventImage: UIImage? = nil
    var coverImage: UIImage? = nil
    var eventImageUrl = ""
    var coverImageUrl = ""
    var eventAnalytics = EventAnalytics()
    var recentActivity = [RecentActivity]()
    var recommendations = [EventRecommendation]()
    var creator: User? = nil
    var invitation = Invitation()
    var errors: [String] = []

    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        eventType <- map["event_type"]
        date <- map["date"]
        name <- map["name"]
        creator <- map["creator"]
        interests <- map["interests"]
        visibility <- map["visibility"]
        eventProgress <- map["progress"]
        eventImageUrl <- map["event_image_url"]
        eventImage <- map["event_image"]
        coverImage <- map["cover_image"]
        coverImageUrl <- map["cover_image_url"]
        eventAnalytics <- map["analytics"]
        recentActivity <- map["recent_activity"]
        recommendations <- map["recommendations"]
        invitation <- map["invitation"]
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
    
	func formattedDate() -> String {
		let getFormatter = DateFormatter()
		getFormatter.dateFormat = "yyyy-mm-dd"
		
		let formatter = DateFormatter()
		formatter.dateFormat = "dd MMMM yyyy"
		formatter.locale = Locale(identifier: "es_MX")
		
		let date = getFormatter.date(from: self.date)
		guard let safeDate = date else {
			return ""
		}
		return formatter.string(from: safeDate)
	}
    
    func dateWithOfWord() -> String {
        let month = date.formateStringDate(format: "MMMM")
        let year = date.formateStringDate(format: "yyyy")
        let day = date.formateStringDate(format: "dd")
        return day + " DE " + month + " DE " + year
    }
	
	func stringVisibility() -> String {
		switch visibility {
		case 0:
			return "Evento Privado"
		case 1:
			return "Evento Público"
		default:
			return ""
		}
	}
	
	func stringType() -> String {
		switch eventType {
		case 0:
			return "Boda"
		case 1:
			return "XV Años"
		case 2:
			return "Baby Shower"
		case 3:
			return "Cumpleaños"
		case 4:
			return "Otro"
		default:
			return ""
		}
	}
}
