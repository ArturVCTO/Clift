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
import Stripe

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
    case updateGuests(event: Event,guests: [String], plusOne: Bool)
    case sendInvitation(event: Event, email: String)
    case createBankAccount(bankAccount: BankAccount)
    case getBankAccounts
    case getBankAccount(bankAccount: BankAccount)
    case updateBankAccount(bankAccount: BankAccount)
    case deleteBankAccount(bankAccount: BankAccount)
    case addAddress(address: Address)
    case getAddresses
    case getAddress(addressId: String)
    case updateAddress(address: Address)
    case setDefaultAddress(address: Address)
    case deleteAddress(address: Address)
    case sendThankMessage(thankMessage: ThankMessage,event: Event,eventProduct: EventProduct)
    case addItemToCart(quantity: Int,product: Product)
    case getCartItems
    case createShoppingCart
    case updateCartQuantity(cartItem: CartItem,quantity: Int)
    case deleteItemFromCart(cartItem: CartItem)
    case getGiftThanksSummary(event: Event, hasBeenThanked: Bool, hasBeenPaid: Bool)
    case requestGifts(event: Event, ids: [String])
    case stripeCheckout(event: Event,checkout: Checkout)
    case getCredits(event: Event)
    case getCreditMovements(event: String, shop: String)
    case completeStripeAccount(account: String,params: STPConnectAccountIndividualParams)
    case verifyEventPool(event: Event)
    case getStates
    case getCities(stateId: String)
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
            return "events/\(event.id)/guests/plus_one"
        case .sendInvitation(_,_):
            return "events_sender"
        case .createBankAccount:
            return "bank_accounts"
        case .getBankAccounts:
            return "bank_accounts"
        case .getBankAccount(let bankAccount):
            return "bank_accounts/\(bankAccount.id)"
        case .updateBankAccount(let bankAccount):
            return "bank_accounts/\(bankAccount.id)"
        case .deleteBankAccount(let bankAccount):
            return "bank_accounts/\(bankAccount.id)"
        case .addAddress(_):
            return "shipping_addresses"
        case .getAddresses:
            return "shipping_addresses"
        case .getAddress(let addressId):
            return "shipping_addresses/\(addressId)"
        case .updateAddress(let address):
            return "shipping_addresses/\(address.id)"
        case .setDefaultAddress(let address):
            return "shipping_addresses/\(address.id)/set_default"
        case .deleteAddress(let address):
            return "shipping_addresses/\(address.id)/delete"
        case .sendThankMessage(_,let event,let eventProduct):
            return "events/\(event.id)/thank_message/\(eventProduct.id)"
        case .addItemToCart(_,let product):
            return "cart/\(product.id)/add_item"
        case .getCartItems:
            return "cart/get_items"
        case .createShoppingCart:
            return "shopping_carts"
        case .updateCartQuantity(let cartItem,_):
            return "cart/\(cartItem.id)/update"
        case .deleteItemFromCart(let cartItem):
            return "cart/\(cartItem.id)/remove_item"
        case .getGiftThanksSummary(let event,_,_):
            return "events/\(event.id)/registries"
        case .requestGifts(let event,_):
            return "events/\(event.id)/request_gifts"
        case.stripeCheckout(let event,_):
            return "checkout/create/\(event.id)"
        case .getCredits(let event):
            return "events/\(event.id)/credits"
        case .getCreditMovements(let event, let shop):
            return "events/\(event)/credit_movements/\(shop)"
        case .completeStripeAccount:
            return "complete_account_mobile"
        case .verifyEventPool(let event):
            return "events/\(event.id)/verify_account"
        case .getStates:
            return "states"
        case .getCities(let stateId):
            return "cities/\(stateId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postLoginSession,.postUser,.addProductToRegistry,.createExternalProducts,.createEventPools,.createInvitation,.addGuest,.addGuests,.sendInvitation,.createBankAccount,.addAddress,.stripeCheckout,.completeStripeAccount:
            return .post
        case .getInterests,.getProfile,.getEvents,.showEvent,.getProducts,.getCategory,.getCategories,.getShops,.getGroups,.getSubgroups,.getGroup,.getSubgroup, .getBrands, .getProductsAsLoggedInUser, .getColors,.getEventProducts,.getEventPools,.getEventSummary,.getInvitationTemplates,.getGuests,.getGuestAnalytics,.getBankAccounts,.getBankAccount,.getAddresses,.getAddress,.getCartItems,.createShoppingCart,.getGiftThanksSummary,.getCredits,.getCreditMovements,.verifyEventPool,.getStates,.getCities:
            return .get
        case .updateProfile,.updateEvent,.updateEventProductAsImportant,.updateEventProductAsCollaborative,.updateInvitation, .updateGuests,.updateBankAccount,.updateAddress, .setDefaultAddress,.deleteAddress,.sendThankMessage,.addItemToCart,.updateCartQuantity,.requestGifts:
            return .put
        case .deleteLogoutSession,.deleteProductFromRegistry,.deleteBankAccount,.deleteItemFromCart:
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
        case .updateGuests(_,let ids, let plusOne):
            return .requestParameters(parameters: ["guests": ["has_plus_one": plusOne, "ids": ids]], encoding: JSONEncoding.default)
        case .getGuests(_,var filters):
            var parameters = filters
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .sendInvitation(let event,let email):
            return .requestParameters(parameters: ["email": email,"event": event.id], encoding: JSONEncoding.default)
        case .createBankAccount(let bankAccount):
            return .requestParameters(parameters: ["bank_account" : bankAccount.toJSON()], encoding: JSONEncoding.default)
        case .updateBankAccount(let bankAccount):
            return .requestParameters(parameters: ["bank_account": bankAccount.toJSON()], encoding: JSONEncoding.default)
        case .addAddress(let address):
            return .requestParameters(parameters: ["shipping_address": address.toJSON()], encoding: JSONEncoding.default)
        case .updateAddress(let address):
            return .requestParameters(parameters: ["shipping_address": address], encoding: JSONEncoding.default)
        case .setDefaultAddress(let address):
            return .requestParameters(parameters: ["shipping_address": address.toJSON()], encoding: JSONEncoding.default)
        case .sendThankMessage(let thankMessage,_,_):
            return .requestParameters(parameters: ["message": thankMessage.toJSON()], encoding: JSONEncoding.default)
        case .addItemToCart(let quantity,_):
            return .requestParameters(parameters: ["shopping_cart_item": ["quantity": quantity, "wishable_type": "Product"]], encoding: JSONEncoding.default)
        case .updateCartQuantity(_, let quantity):
            return .requestParameters(parameters: ["shopping_cart_item": ["quantity": quantity]], encoding: JSONEncoding.default)
        case .getGiftThanksSummary(_,let hasBeenThanked, let hasBeenPaid):
            var parameters = [String: Any]()
            parameters["gifted"] = hasBeenPaid
            parameters["thanked"] = hasBeenThanked
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .requestGifts(_,let ids):
            return .requestParameters(parameters: ["ids": [ids]], encoding: JSONEncoding.default)
        case .stripeCheckout(_,let checkout):
            return .requestParameters(parameters: ["checkout": checkout.toJSON()], encoding: JSONEncoding.default)
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


