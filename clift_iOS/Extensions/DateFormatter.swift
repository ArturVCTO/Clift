//
//  DateFormatter.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/21/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation

public extension Date {
    func eventDateFormatter() -> (String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let formattedDateInString = formatter.string(from: self)
        
        return formattedDateInString
    }
    
    func ceremonyInvitationDateFormatter() -> (String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let formattedDateInString = formatter.string(from: self)
        
        return formattedDateInString
    }
    
    func expirationDateFormatter() -> (String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDateInString = formatter.string(from: self)
        
        return formattedDateInString
    }
    
}
