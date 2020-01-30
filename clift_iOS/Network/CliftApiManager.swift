//
//  CliftApiManager.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/7/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper
import Moya_ObjectMapper

let sharedApiManager: CliftApiManager = CliftApiManager()

extension Response {
    func isSuccess() -> Bool {
        return self.statusCode >= 200 && self.statusCode <= 299
    }
    
    func isRedirection() -> Bool {
        return self.statusCode >= 300 && self.statusCode <= 399
    }
    
    func isClientError() -> Bool {
        return self.statusCode >= 400 && self.statusCode <= 499
    }
    
    func isServerError() -> Bool {
        return self.statusCode >= 500 && self.statusCode <= 599
    }
    
    func isError() -> Bool {
        return self.statusCode >= 400 && self.statusCode <= 599
    }
    
    func removeWrapper(wrapper: String) -> Response {
        var newResponse = Response(statusCode: self.statusCode, data: self.data)
        if self.isSuccess() {
            guard let json = try? self.mapJSON() as? Dictionary<String, AnyObject>,
                let results = json[wrapper],
                let newData = try? JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                else {
                    return self
            }
            newResponse = Response(statusCode: self.statusCode,
                                   data: newData,
                                   response: self.response)
        } else if self.isError() {
            guard let json = try? self.mapJSON() as? Dictionary<String, AnyObject>,
                let results = json[wrapper],
                let newData = try? JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                else {
                    return self
            }
            newResponse = Response(statusCode: self.statusCode,
                                   data: newData,
                                   response: self.response)
        }
        
        return newResponse
    }
}

struct CliftApiManager {
    let endpointClosure = { (target: CliftApi) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        return defaultEndpoint.adding(newHTTPHeaderFields: [:])
    }
    
    var provider =  MoyaProvider<CliftApi>(plugins:[NetworkLoggerPlugin(verbose: true)])
    
    let disposeBag = DisposeBag()
    
    
    init() {
        provider = MoyaProvider<CliftApi>(endpointClosure: endpointClosure,plugins: [NetworkLoggerPlugin(verbose: true)])
    }
}

extension CliftApiManager {
    typealias AdditionalStepsAction = (() -> ())
    
    fileprivate func requestObjectWithResponse<T: Mappable>(_ token: CliftApi, type: T.Type, completion: @escaping (T?, Response?) -> Void, wrapper: String ) {
        
        var savedResponse: Response?
        provider.rx.request(token)
            .debug()
            .map { response -> Response in
                print(try response.mapJSON())
                savedResponse = response
                return response.removeWrapper(wrapper: wrapper)
            }
            .mapObject(T.self)
            .subscribe { event -> Void in
                Swift.debugPrint("event", event)
                
                switch event {
                case .success(let parsedObject):
                    completion(parsedObject, savedResponse)
                case .error(let error):
                    Swift.debugPrint(error)
                    completion(nil, nil)
                }
                
            }.disposed(by: disposeBag)
    }
    
    fileprivate func requestEmptyObject(_ token: CliftApi, completion: @escaping (EmptyObjectWithErrors? , Response?) -> Void, additionalSteps: AdditionalStepsAction? = nil) {
        
        var savedResponse: Response?
        
        provider.rx.request(token)
            .debug()
            .map { response -> Response in
                savedResponse = response
                return response
            }
            .mapObject(EmptyObjectWithErrors.self)
            .subscribe { event -> Void in
                
                switch event {
                case .success(let parsedObject):
                    Swift.debugPrint(parsedObject)
                    completion(parsedObject, savedResponse)
                case .error(let error):
                    Swift.debugPrint(error)
                    completion(nil, savedResponse)
                }
            }.disposed(by: disposeBag)
    }
    
    fileprivate func requestArrayWithResponse<T: Mappable>(_ token: CliftApi, type: T.Type, completion: @escaping ([T]?, Response?) -> Void, wrapper: String, additionalSteps: AdditionalStepsAction? = nil) {
        
        var savedResponse: Response?
        
        provider.rx.request(token)
            .debug()
            .map{ response -> Response in
                print(try response.mapJSON())
                savedResponse = response
                return response.removeWrapper(wrapper: wrapper)
            }
            .mapArray(T.self)
            .subscribe { event -> Void in
                Swift.debugPrint("event", event)
                switch event {
                case .success(let parsedArray):
                    completion(parsedArray,savedResponse)
                    additionalSteps?()
                case .error(let error):
                    print(error.localizedDescription)
                    Swift.debugPrint(error)
                    completion(nil, nil)
                }
            }.disposed(by: disposeBag)
    }
}

protocol ApiCalls {
    func login(email: String, password: String, completion: @escaping(Session?, Response?) -> Void)
    
    func interests(completion: @escaping ([Interest]?, Response?) -> Void)
    
    func postUsers(user: User, completion: @escaping(User?,Response?) -> Void)
    
    func getProfile(completion: @escaping (User?,Response?) -> Void)
    
    func updateProfile(profile: [MultipartFormData], completion: @escaping (EmptyObjectWithErrors?,Response?) -> Void)
    
    func getEvents(completion: @escaping ([Event]?,Response?) -> Void)
    
    func showEvent(id: String, completion: @escaping (Event?,Response?) -> Void)
    
    func updateEvent(id: String, event: [MultipartFormData], completion: @escaping (Event?,Response?) -> Void)
    
    func deleteLogoutSession(completion: @escaping(EmptyObjectWithErrors?,Response?) -> Void)
    
    func getCategories(completion: @escaping( [Category]?, Response?) -> Void)
    
    func getGroups(completion: @escaping( [Group]?, Response?) -> Void)
    
    func getSubgroups(completion: @escaping([Subgroup]?, Response?) -> Void)
    
    func getCategory(id: String, completion: @escaping(Category?, Response?) -> Void)
    
    func getGroup(id: String, completion: @escaping(Group?, Response?) -> Void)
    
    func getSubgroup(id: String, completion: @escaping(Subgroup?, Response?) -> Void)
    
    func getShops(completion: @escaping([Shop]?, Response?) -> Void)
    
    func getBrands(completion: @escaping([Brand]?, Response?) -> Void)
    
    func getProducts(group: Group, subgroup: Subgroup,brand: Brand, shop: Shop, filters: [String : Any], page: Int, completion: @escaping([Product]?,Response?) -> Void)
    
    func getProductsAsLoggedInUser(group: Group, subgroup: Subgroup, event: Event, brand: Brand, shop: Shop, filters: [String : Any], page: Int, completion: @escaping([Product]?, Response?) -> Void)
    
    func addProductToRegistry(productId: String, eventId: String,quantity: Int,paidAmount: Int, completion: @escaping(EventProduct?,Response?) -> Void)
    
    func deleteProductFromRegistry(productId: String, eventId: String, completion: @escaping(EmptyObjectWithErrors?,Response?) -> Void)
    
    func getColors(completion: @escaping([CliftColor]?, Response?) -> Void)
    
    func getEventProducts(event: Event, available: String, gifted: String, filters: [String : Any] ,completion: @escaping([EventProduct]?, Response?) -> Void)
    
    func createEventPool(event: Event, pool: [MultipartFormData], completion: @escaping(EmptyObjectWithErrors?, Response?) -> Void)
    
    func createExternalProduct(event: Event, externalProduct: [MultipartFormData], completion: @escaping(EmptyObjectWithErrors?, Response?) -> Void)
    
    func updateEventProductAsImportant(eventProduct: EventProduct, setImportant: Bool, completion: @escaping(EventProduct?, Response?) -> Void)
    
    func updateEventProductAsCollaborative(eventProduct: EventProduct, setCollaborative: Bool, completion: @escaping(EventProduct?, Response?) -> Void)
    
    func getEventPools(event: Event, completion: @escaping([EventPool]?, Response?) -> Void)
    
    func getEventSummary(event: Event, completion: @escaping([EventRegistrySummary]?, Response?) -> Void)
    
    func getInvitationTemplates(event: Event, completion: @escaping([InvitationTemplate]?, Response?) -> Void)
    
    func getGuests(event: Event,filters: [String : Any], completion: @escaping([EventGuest]?, Response?) -> Void)
    
    func createInvitation(event: Event, invitationTemplate: InvitationTemplate,invitation: Invitation, completion: @escaping(Invitation?,Response?) -> Void)
    
    func updateInvitation(event: Event,invitation: Invitation, completion: @escaping(Invitation?,Response?) -> Void)
    
    func addGuest(event: Event, guest: EventGuest, completion: @escaping(EmptyObjectWithErrors?,Response?) -> Void)
    
    func addGuests(event: Event, guest: [EventGuest], completion: @escaping(EmptyObjectWithErrors?,Response?) -> Void)
    
    func updateGuests(event: Event, isConfirmed: Int, guests: [String], completion: @escaping(EmptyObjectWithErrors?,Response?) -> Void)
    
    func getGuestAnalytics(event: Event, completion: @escaping(EventGuestAnalytics?,Response?) -> Void)
    
    func sendInvitation(event: Event, email: String, completion: @escaping(EmptyObjectWithErrors?,Response?) -> Void)
    
    func addAddress(address: Address, completion: @escaping(EmptyObjectWithErrors?, Response?) -> Void)
    
    func getAddresses(completion: @escaping([Address]?, Response?) -> Void)
    
    func getAddress(addressId: String, completion: @escaping(Address?, Response?) -> Void)
    
    func updateAddress(address: Address, completion: @escaping(Address?, Response?) -> Void)
    
    func setDefaultAddress(address: Address, completion: @escaping(Address? , Response?) -> Void)
    
    func deleteAddress(address: Address, completion: @escaping(EmptyObjectWithErrors?,Response?) -> Void)
    
    func sendThankMessage(thankMessage: ThankMessage, event: Event, eventProduct: EventProduct, completion: @escaping(EmptyObjectWithErrors?, Response?) -> Void)
    
    func addItemToCart(quantity: Int, product: Product, completion: @escaping(CartItem?,Response?) -> Void)
    
    func getCartItems(completion: @escaping([CartItem]?, Response?) -> Void)
    
    func createShoppingCart(completion: @escaping(ShoppingCart?, Response?) -> Void)
    
    func updateCartQuantity(cartItem: CartItem, quantity: Int, completion: @escaping(CartItem?,Response?) -> Void)
    
    func deleteItemFromCart(cartItem: CartItem, completion: @escaping(EmptyObjectWithErrors?, Response?) -> Void)
}

extension CliftApiManager: ApiCalls {
    func login(email: String, password: String, completion: @escaping (Session?, Response?) -> Void) {
        requestObjectWithResponse(.postLoginSession(email: email, password: password), type: Session.self, completion: completion, wrapper: "session")
    }
    
    func interests(completion: @escaping ([Interest]?, Response?) -> Void) {
        requestArrayWithResponse(.getInterests, type: Interest.self, completion: completion, wrapper: "interests")
    }
    
    func postUsers(user: User, completion: @escaping (User?, Response?) -> Void) {
        requestObjectWithResponse(.postUser(user: user), type: User.self, completion: completion, wrapper: "user")
    }
    
    func getProfile(completion: @escaping (User?, Response?) -> Void) {
        requestObjectWithResponse(.getProfile, type: User.self, completion: completion, wrapper: "profile")
    }
    
    func updateProfile(profile: [MultipartFormData], completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.updateProfile(profile: profile), completion: completion)
    }
    
    func getEvents(completion: @escaping ([Event]?, Response?) -> Void) {
        requestArrayWithResponse(.getEvents, type: Event.self, completion: completion, wrapper: "events")
    }
    
    func showEvent(id: String, completion: @escaping (Event?, Response?) -> Void) {
        requestObjectWithResponse(.showEvent(id: id), type: Event.self, completion: completion, wrapper: "event")
    }
    
    func updateEvent(id: String, event: [MultipartFormData], completion: @escaping (Event?, Response?) -> Void) {
        requestObjectWithResponse(.updateEvent(id: id, event: event), type: Event.self, completion: completion, wrapper: "event")
    }
    
    func deleteLogoutSession(completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.deleteLogoutSession, completion: completion)
    }
    
    func getCategories(completion: @escaping ([Category]?, Response?) -> Void) {
        requestArrayWithResponse(.getCategories, type: Category.self, completion: completion, wrapper: "categories")
    }
    
    func getCategory(id: String, completion: @escaping (Category?, Response?) -> Void) {
        requestObjectWithResponse(.getCategory(categoryId: id), type: Category.self, completion: completion, wrapper: "category")
    }
    
    func getGroups(completion: @escaping ([Group]?, Response?) -> Void) {
        requestArrayWithResponse(.getGroups, type: Group.self, completion: completion, wrapper: "groups")
    }
    
    func getGroup(id: String, completion: @escaping (Group?, Response?) -> Void) {
        requestObjectWithResponse(.getGroup(groupId: id),type: Group.self,completion: completion, wrapper: "group")
    }
    
    func getSubgroups(completion: @escaping ([Subgroup]?, Response?) -> Void) {
        requestArrayWithResponse(.getSubgroups, type: Subgroup.self, completion: completion, wrapper: "subgroups")
    }
    
    func getSubgroup(id: String, completion: @escaping (Subgroup?, Response?) -> Void) {
        requestObjectWithResponse(.getSubgroup(subgroupId: id), type: Subgroup.self, completion: completion, wrapper: "subgroup")
    }
    
    func getShops(completion: @escaping ([Shop]?, Response?) -> Void) {
        requestArrayWithResponse(.getShops, type: Shop.self, completion: completion, wrapper: "shops")
    }
    
    func getBrands(completion: @escaping ([Brand]?, Response?) -> Void) {
        requestArrayWithResponse(.getBrands, type: Brand.self, completion: completion, wrapper: "brands")
    }
    
    func getProducts(group: Group, subgroup: Subgroup, brand: Brand, shop: Shop, filters: [String : Any], page: Int, completion: @escaping ([Product]?, Response?) -> Void) {
        requestArrayWithResponse(.getProducts(group: group, subgroup: subgroup, brand: brand, shop: shop, filters: filters, page: page), type: Product.self, completion: completion, wrapper: "products")
    }
    
    func getProductsAsLoggedInUser(group: Group, subgroup: Subgroup, event: Event, brand: Brand, shop: Shop, filters: [String : Any], page: Int, completion: @escaping ([Product]?, Response?) -> Void) {
        requestArrayWithResponse(.getProductsAsLoggedInUser(group: group, subgroup: subgroup, event: event, brand: brand, shop: shop, filters: filters, page: page), type: Product.self, completion: completion, wrapper: "products")
    }
    
    func addProductToRegistry(productId: String, eventId: String, quantity: Int, paidAmount: Int, completion: @escaping (EventProduct?, Response?) -> Void) {
        requestObjectWithResponse(.addProductToRegistry(productId: productId, eventId: eventId, quantity: quantity, paidAmount: paidAmount), type: EventProduct.self, completion: completion, wrapper: "event_product")
    }
    
    func deleteProductFromRegistry(productId: String, eventId: String, completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.deleteProductFromRegistry(productId: productId, eventId: eventId), completion: completion)
    }
    
    func getColors(completion: @escaping ([CliftColor]?, Response?) -> Void) {
        requestArrayWithResponse(.getColors, type: CliftColor.self, completion: completion, wrapper: "colors")
    }
    
    func getEventProducts(event: Event, available: String, gifted: String, filters: [String : Any ], completion: @escaping ([EventProduct]?, Response?) -> Void) {
        requestArrayWithResponse(.getEventProducts(event: event,available: available, gifted: gifted, filters: filters), type: EventProduct.self, completion: completion, wrapper: "registries")
    }
    
    func createEventPool(event: Event, pool: [MultipartFormData], completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.createEventPools(event: event, pool: pool), completion: completion)
    }
    
    func createExternalProduct(event: Event, externalProduct: [MultipartFormData], completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.createExternalProducts(event: event, externalProduct: externalProduct), completion: completion)
    }
    
    func updateEventProductAsImportant(eventProduct: EventProduct,setImportant: Bool, completion: @escaping (EventProduct?, Response?) -> Void) {
        requestObjectWithResponse(.updateEventProductAsImportant(eventProduct: eventProduct,setImportant: setImportant), type: EventProduct.self, completion: completion, wrapper: "event_product")
    }
    
    func updateEventProductAsCollaborative(eventProduct: EventProduct, setCollaborative: Bool, completion: @escaping (EventProduct?, Response?) -> Void) {
        requestObjectWithResponse(.updateEventProductAsCollaborative(eventProduct: eventProduct,setCollaborative: setCollaborative), type: EventProduct.self, completion: completion, wrapper: "event_product")
    }
    
    func getEventPools(event: Event, completion: @escaping ([EventPool]?, Response?) -> Void) {
        requestArrayWithResponse(.getEventPools(event: event), type: EventPool.self, completion: completion, wrapper: "event_pools")
    }
    
    func getEventSummary(event: Event, completion: @escaping ([EventRegistrySummary]?, Response?) -> Void) {
        requestArrayWithResponse(.getEventSummary(event: event), type: EventRegistrySummary.self, completion: completion, wrapper: "summary")
    }
    
    func getInvitationTemplates(event: Event, completion: @escaping ([InvitationTemplate]?, Response?) -> Void) {
        requestArrayWithResponse(.getInvitationTemplates(event: event), type: InvitationTemplate.self, completion: completion, wrapper: "invitation_template")
    }
    
    func getGuests(event: Event, filters: [String : Any], completion: @escaping ([EventGuest]?, Response?) -> Void) {
        requestArrayWithResponse(.getGuests(event: event,filters: filters), type: EventGuest.self, completion: completion, wrapper: "guests")
    }
    
    func createInvitation(event: Event, invitationTemplate: InvitationTemplate, invitation: Invitation, completion: @escaping (Invitation?, Response?) -> Void) {
        requestObjectWithResponse(.createInvitation(event: event, invitationTemplate: invitationTemplate, invitation: invitation), type: Invitation.self, completion: completion, wrapper: "invitation")
    }
    
    func updateInvitation(event: Event, invitation: Invitation, completion: @escaping (Invitation?, Response?) -> Void) {
        requestObjectWithResponse(.updateInvitation(event: event, invitation: invitation), type: Invitation.self, completion: completion, wrapper: "invitation")
    }
    
    func addGuest(event: Event, guest: EventGuest, completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.addGuest(event: event, guest: guest), completion: completion)
    }
    
    func addGuests(event: Event, guest: [EventGuest], completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.addGuests(event: event, guests: guest), completion: completion)
    }
    
    func updateGuests(event: Event, isConfirmed: Int, guests: [String], completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.updateGuests(event: event, isConfirmed: isConfirmed, guests: guests), completion: completion)
    }
    
    func getGuestAnalytics(event: Event, completion: @escaping (EventGuestAnalytics?, Response?) -> Void) {
        requestObjectWithResponse(.getGuestAnalytics(event: event), type: EventGuestAnalytics.self, completion: completion, wrapper: "analytics")
    }
    
    func sendInvitation(event: Event, email: String, completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.sendInvitation(event: event, email: email), completion: completion)
    }
    
    func addAddress(address: Address, completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.addAddress(address: address), completion: completion)
    }
    
    func getAddresses(completion: @escaping([Address]?, Response?) -> Void) {
        requestArrayWithResponse(.getAddresses, type: Address.self, completion: completion, wrapper: "shipping_address")
    }
    
    func getAddress(addressId: String, completion: @escaping (Address?, Response?) -> Void) {
        requestObjectWithResponse(.getAddress(addressId: addressId), type: Address.self, completion: completion, wrapper: "shipping_address")
    }
    
    func updateAddress(address: Address, completion: @escaping (Address?, Response?) -> Void) {
        requestObjectWithResponse(.updateAddress(address: address), type: Address.self, completion: completion, wrapper: "shipping_address")
    }
    
    func setDefaultAddress(address: Address, completion: @escaping (Address?, Response?) -> Void) {
        requestObjectWithResponse(.setDefaultAddress(address: address), type: Address.self, completion: completion, wrapper: "shipping_address")
    }
    
    func deleteAddress(address: Address, completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.deleteAddress(address: address), completion: completion)
    }
    
    func sendThankMessage(thankMessage: ThankMessage, event: Event, eventProduct: EventProduct, completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.sendThankMessage(thankMessage: thankMessage, event: event, eventProduct: eventProduct), completion: completion)
    }
    
    func addItemToCart(quantity: Int, product: Product, completion: @escaping (CartItem?, Response?) -> Void) {
        requestObjectWithResponse(.addItemToCart(quantity: quantity, product: product), type: CartItem.self, completion: completion, wrapper: "shopping_cart_item")
    }
    
    func getCartItems(completion: @escaping ([CartItem]?, Response?) -> Void) {
        requestArrayWithResponse(.getCartItems, type: CartItem.self, completion: completion, wrapper: "cart_items")
    }
    
    func createShoppingCart(completion: @escaping (ShoppingCart?, Response?) -> Void) {
        requestObjectWithResponse(.createShoppingCart, type: ShoppingCart.self, completion: completion, wrapper: "shopping_cart")
    }
    
    func updateCartQuantity(cartItem: CartItem, quantity: Int, completion: @escaping (CartItem?, Response?) -> Void) {
        requestObjectWithResponse(.updateCartQuantity(cartItem: cartItem, quantity: quantity), type: CartItem.self, completion: completion, wrapper: "shopping_cart_item")
    }
    
    func deleteItemFromCart(cartItem: CartItem, completion: @escaping (EmptyObjectWithErrors?, Response?) -> Void) {
        requestEmptyObject(.deleteItemFromCart(cartItem: cartItem), completion: completion)
    }
}
