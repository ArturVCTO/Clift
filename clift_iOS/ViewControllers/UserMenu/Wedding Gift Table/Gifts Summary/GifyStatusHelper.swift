//
//  GifyStatusHelper.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 08/04/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation

enum GiftStatusHelperFlags {
    case unknown
    case hidden
    case grayIcon
    case greenIcon
}
struct GiftStatusHelperOptions {
    var credit: GiftStatusHelperFlags = .unknown
    var deliver: GiftStatusHelperFlags = .unknown
    var envelope: GiftStatusHelperFlags = .unknown
}
class GiftStatusHelper {
    
    static var shared: GiftStatusHelper = {
        
            let instance = GiftStatusHelper()
        
            return instance
        }()
    
    private init() {}
    
    func manageSimpleGift(giftSummaryItem: GiftSummaryItem) -> GiftStatusHelperOptions {
        var currentGiftStatusHelperOptions = GiftStatusHelperOptions()
        
        switch giftSummaryItem.eventProduct.status {
        
        case "pending":
            currentGiftStatusHelperOptions.credit = .grayIcon
            currentGiftStatusHelperOptions.deliver = .grayIcon
            
        case "requested", "delivered":
            currentGiftStatusHelperOptions.credit = .hidden
            currentGiftStatusHelperOptions.deliver = .greenIcon
        case "credit":
            currentGiftStatusHelperOptions.credit = .greenIcon
            currentGiftStatusHelperOptions.deliver = .hidden
        default:
            break
        }
        
        if giftSummaryItem.hasBeenThanked {
            currentGiftStatusHelperOptions.envelope = .greenIcon
        } else {
            currentGiftStatusHelperOptions.envelope = .grayIcon
        }
        
        return currentGiftStatusHelperOptions
    }
    
    func manageCollaborativeGift(eventProduct: EventProduct, orderItem: OrderItem) -> GiftStatusHelperOptions {
        var currentGiftStatusHelperOptions = GiftStatusHelperOptions()
        
        currentGiftStatusHelperOptions.credit = .grayIcon
        
        switch eventProduct.status {
        
        case "pending":
            if eventProduct.collaborators == eventProduct.gifted_quantity {
                currentGiftStatusHelperOptions.deliver = .grayIcon
            } else {
                currentGiftStatusHelperOptions.deliver = .hidden
            }
        case "requested", "delivered":
            currentGiftStatusHelperOptions.credit = .hidden
            currentGiftStatusHelperOptions.deliver = .greenIcon
        case "credit":
            currentGiftStatusHelperOptions.credit = .greenIcon
            currentGiftStatusHelperOptions.deliver = .hidden
        default:
            break
        }
        
        if orderItem.hasBeenThanked {
            currentGiftStatusHelperOptions.envelope = .greenIcon
        } else {
            currentGiftStatusHelperOptions.envelope = .grayIcon
        }
        
        return currentGiftStatusHelperOptions
    }
}
