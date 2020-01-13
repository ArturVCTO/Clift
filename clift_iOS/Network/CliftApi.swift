//
//  CliftApi.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/7/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Moya

var apiVersion = 1

enum CliftApi {
//    Sprint 1
    case postLoginSession(email: String, password: String)
    case getInterests
    case postUser(user: User)
    case deleteLogoutSession
    case getProfile
    case updateProfile(profile: [MultipartFormData])
    case getEvents
    case showEvent(id: String)
    case updateEvent(id: String,event: [MultipartFormData])
    case getProducts(group: Group,subgroup: Subgroup, brand: Brand, shop: Shop,filters: [String : Any], page: Int)
    case getCategory(categoryId: String)
    case getCategories
    case getGroups
    case getGroup(groupId: String)
    case getSubgroups
    case getSubgroup(subgroupId: String)
    case getShops
    case addProductToRegistry(productId: String, eventId: String,quantity: Int,paidAmount: Int)
    case deleteProductFromRegistry(productId: String, eventId: String)
    case getBrands
    case getProductsAsLoggedInUser(group: Group,subgroup: Subgroup,event: Event, brand: Brand,shop: Shop, filters: [String : Any], page: Int)
    case getColors
    case getEventProducts(event: Event,available: String,gifted: String, filters: [String : Any])
    case createExternalProducts(event: Event,externalProduct: [MultipartFormData])
    case createEventPools(event: Event,pool: [MultipartFormData])
    case updateEventProductAsImportant(eventProduct: EventProduct,setImportant: Bool)
    case updateEventProductAsCollaborative(eventProduct: EventProduct,setCollaborative: Bool)
    case getEventPools(event: Event)
    case getEventSummary(event: Event)
    case getInvitationTemplates(event: Event)
    case getGuests(event: Event,filters: [String : Any])
    case getGuestAnalytics(event: Event)
    case createInvitation(event: Event,invitationTemplate: InvitationTemplate, invitation: Invitation)
    case updateInvitation(event: Event, invitation: Invitation)
    case addGuest(event: Event, guest: EventGuest)
    case addGuests(event: Event, guests: [EventGuest])
    case updateGuests(event: Event,isConfirmed: Int,guests: [String])
    case sendInvitation(event: Event, email: String)
    case addAddress(address: Address)
    case getAddresses
}

extension CliftApi: TargetType {
    var baseURL: URL {
        return URL(string: Bundle.main.infoDictionary!["API_BASE_URL_ENDPOINT"]
            as! String)!
    }
    
    var path: String {
        switch self {
        case .postLoginSession:
            return "sessions"
        case .getInterests:
            return "interests"
        case .postUser(_):
            return "users"
        case .deleteLogoutSession:
            return "sessions"
        case .getProfile:
            return "profile"
        case .updateProfile(_):
            return "profile"
        case .getEvents:
            return "events"
        case .showEvent(let id):
            return "events/\(id)"
        case .updateEvent(let id,_):
            return "events/\(id)"
        case .getProductsAsLoggedInUser(_, _,let event,_,_,_,_):
            return "events/\(event.id)/products"
        case .getCategory(let id):
            return "categories/\(id)"
        case .getCategories:
            return "categories"
        case .getShops:
            return "shops"
        case .getGroup(let id):
            return "groups/\(id)"
        case .getGroups:
            return "groups"
        case .getSubgroups:
            return "subgroups"
        case .getSubgroup(let id):
            return "subgroups/\(id)"
        case .addProductToRegistry(let productId, let eventId,_,_):
            return "events/\(eventId)/products/\(productId)"
        case .deleteProductFromRegistry(let productId, let eventId):
            return "events/\(eventId)/products/\(productId)"
        case .getBrands:
            return "brands"
        case .getProducts(_,_,_,_,_,_):
            return "products"
        case .getColors:
            return "colors"
        case .getEventProducts(let event,_,_,_):
            return "events/\(event.id)/registries"
        case .createExternalProducts(let event,_):
            return "events/\(event.id)/external_products"
        case .createEventPools(let event,_):
            return "events/\(event.id)/event_pools"
        case .updateEventProductAsImportant(let eventProduct,_):
            return "event_products/\(eventProduct.id)/set_important"
        case .updateEventProductAsCollaborative(let eventProduct,_):
            return "event_products/\(eventProduct.id)/set_collaborative"
        case .getEventPools(let event):
            return "events/\(event.id)/event_pools"
        case .getEventSummary(let event):
            return "events/\(event.id)/summary"
        case .getInvitationTemplates(let event):
            return "events/\(event.id)/invitation_templates"
        case .getGuests(let event,_):
            return "events/\(event.id)/guests"
        case .getGuestAnalytics(let event):
            return "events/\(event.id)/guests"
        case .createInvitation(let event, let invitationTemplate,_):
            return "events/\(event.id)/\(invitationTemplate.id)"
        case .updateInvitation(let event,let invitation):
            return "events/\(event.id)/invitations/\(invitation.id)"
        case .addGuest(let event, _):
            return "events/\(event.id)/guests"
        case .addGuests(let event, _):
            return "events/\(event.id)/guests"
        case .updateGuests(let event, _,_):
            return "events/\(event.id)/guests"
        case .sendInvitation(_,_):
            return "events_sender"
        case .addAddress(_):
            return "address"
        case .getAddresses:
            return "addresses"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postLoginSession,.postUser,.addProductToRegistry,.createExternalProducts,.createEventPools,.createInvitation,.addGuest,.addGuests,.sendInvitation, .addAddress:
            return .post
        case .getInterests,.getProfile,.getEvents,.showEvent,.getProducts,.getCategory,.getCategories,.getShops,.getGroups,.getSubgroups,.getGroup,.getSubgroup, .getBrands, .getProductsAsLoggedInUser, .getColors,.getEventProducts,.getEventPools,.getEventSummary,.getInvitationTemplates,.getGuests,.getGuestAnalytics,.getAddresses:
            return .get
        case .updateProfile,.updateEvent,.updateEventProductAsImportant,.updateEventProductAsCollaborative,.updateInvitation, .updateGuests:
            return .put
        case .deleteLogoutSession,.deleteProductFromRegistry:
            return .delete
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .postLoginSession(let email, let password):
            return .requestParameters(parameters: ["session": ["email": email, "password": password]], encoding: JSONEncoding.default)
        case .postUser(let user):
            return .requestParameters(parameters: ["user": user.toJSON()], encoding: JSONEncoding.default)
        case .updateProfile(let profile):
            return .uploadMultipart(profile)
        case .updateEvent(_,let event):
            return .uploadMultipart(event)
        case .getProducts(let group, let subgroup, let brand, let shop, var filters, let page):
            var parameters = filters
            parameters["group"] = group.id
            parameters["subgroup"] = subgroup.id
            parameters["brand"] = brand.id
            parameters["shop"] = shop.id

            parameters["page"] = page
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .addProductToRegistry(_,_,let quantity, let paidAmount):
            return .requestParameters(parameters: ["event_product": ["paid_amount" : 0, "quantity" : quantity, "wishable_type": "Product"]], encoding: JSONEncoding.default)
        case .getProductsAsLoggedInUser(let group, let subgroup,_, let brand, let shop, var filters, let page):
            var parameters = filters
            parameters["group"] = group.id
            parameters["subgroup"] = subgroup.id
            parameters["brand"] = brand.id
            parameters["shop"] = shop.id

            parameters["page"] = page
                       
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .createEventPools(_, let pool):
            return .uploadMultipart(pool)
        case .createExternalProducts(_, let externalProduct):
            return .uploadMultipart(externalProduct)
        case .updateEventProductAsImportant(_,let setImportant):
            return .requestParameters(parameters: ["event_product": ["set_important" : setImportant]], encoding: JSONEncoding.default)
        case .updateEventProductAsCollaborative(_,let setCollaborative):
            return .requestParameters(parameters: ["event_product": ["set_collaborative" : setCollaborative]], encoding: JSONEncoding.default)
        case .getEventProducts(_,let available,let gifted, var filters):
            var parameters = filters
            parameters["available"] = available
            parameters["gifted"] = gifted
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .createInvitation(_,_,let invitation):
            return .requestParameters(parameters: ["invitation":  invitation.toJSON()], encoding: JSONEncoding.default)
        case .updateInvitation(_,let invitation):
            return .requestParameters(parameters: ["invitation": invitation.toJSON()], encoding: JSONEncoding.default)
        case .addGuest(_,let guest):
            return .requestParameters(parameters: ["guests": [guest.toJSON()]], encoding: JSONEncoding.default)
        case .addGuests(_, let guests):
            return .requestParameters(parameters: ["guests": guests.toJSON()], encoding: JSONEncoding.default)
        case .updateGuests(_,let isConfirmed, let ids):
            return .requestParameters(parameters: ["guests": ["is_confirmed": isConfirmed, "ids": ids]], encoding: JSONEncoding.default)
        case .getGuests(_,var filters):
            var parameters = filters
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .sendInvitation(let event,let email):
            return .requestParameters(parameters: ["email": email,"event": event.id], encoding: JSONEncoding.default)
        case .addAddress(let address):
            return .requestParameters(parameters: ["address": address], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let realm = try! Realm()
        let session = realm.objects(Session.self)
        
        if (session.isEmpty) {
            return ["Accept": "application/vnd.cft.v1+json", "Content-Type": "application/json", "X-Client": "app"]
        } else {
            switch self {
            case .updateProfile(_):
                return  ["Accept": "application/vnd.cft.v1+json", "Content-Type": "application/x-www-form-urlencoded", "X-Client": "app",
                         "Authorization": session.first!.token]
            default:
                return  ["Accept": "application/vnd.cft.v1+json", "Content-Type": "application/json", "X-Client": "app",
                         "Authorization": session.first!.token]
            }
        }
        
    }
}


