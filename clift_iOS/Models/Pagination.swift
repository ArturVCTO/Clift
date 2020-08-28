//
//  Pagination.swift
//  clift_iOS
//
//  Created by Lizzie Guajardo on 18/08/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class Pagination: Mappable {
    var currentPage = Int()
    var from = Int()
    var nextPage = Int()
    var prevPage = Int()
    var to = Int()
    var totalCount = Int()
    var totalPages = Int()
    
    var errors: [String] = []
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        map["pagination"]
        let pagination = map.currentValue as! Dictionary<String, Any>
        currentPage = pagination["current_page"] as? Int ?? 1
        from = pagination["from"] as? Int ?? 1
        nextPage = pagination["next_page"] as? Int ?? 0
        prevPage = pagination["prev_page"] as? Int ?? 0
        to = pagination["to"] as? Int ?? 1
        totalCount = pagination["total_count"] as? Int ?? 1
        totalPages = pagination["total_pages"] as? Int ?? 1
        
        if let unwrappedErrors = map.JSON["errors"] as? [String] {
            for error in unwrappedErrors {
                errors.append(error)
            }
        }
    }
}
