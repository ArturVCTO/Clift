//
//  StripeApiClient.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/17/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import Stripe

class MyStripeApiClient: NSObject, STPCustomerEphemeralKeyProvider {
    enum APIError: Error {
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .unknown:
                return "Unknown Error"
            }
        }
    }
    
     static let sharedClient = MyStripeApiClient()
      var baseURL: URL {
             return URL(string: Bundle.main.infoDictionary!["API_BASE_URL_ENDPOINT"]
                 as! String)!
         }
       
       func createPaymentIntent(cartProduct: [CartItem], shippingMethod: Address?, country: String? = nil, completion: @escaping ((Result<String, Error>) -> Void)) {
           let url = self.baseURL.appendingPathComponent("")
            var params: [String: Any] = [:]
           params["products"] = cartProduct.map({ (p) -> String in
            return p.product!.name
           })
           
           let jsonData = try? JSONSerialization.data(withJSONObject: params)
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.httpBody = jsonData
           let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
               guard let response = response as? HTTPURLResponse,
                   response.statusCode == 200,
                   let data = data,
                   let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??),
                   let secret = json?["secret"] as? String else {
                       completion(.failure(error ?? APIError.unknown))
                       return
               }
               completion(.success(secret))
           })
           task.resume()
       }
    
    func completeAccount(accountId: String,accountParams: [String: Any],token: String,completion: @escaping((Result <String, Error>) -> Void)) {
        let url = self.baseURL.appendingPathComponent("complete_account_mobile")
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        var request = URLRequest(url: urlComponents.url!)
        var params: [String: Any] = [:]
        var nestedParams: [String: Any] = [:]
        var headers: [String: String] = [:]
        nestedParams["account_id"] = accountId
        nestedParams["account_params"] = accountParams
        params["stripe_account"] = nestedParams
        headers["Content-Type"] = "application/json"
        headers["X-Client"] = "app"
        headers["Accept"] = "application/vnd.cft.v1+json"
        headers["Authorization"] = "\(token)"
//        request.setValue("app", forHTTPHeaderField: "X-Client")
//        request.setValue("applicaton/vnd.cft.v1+json", forHTTPHeaderField: "Accept")
//        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??),
                let secret = json?["secret"] as? String else {
                    completion(.failure(error ?? APIError.unknown))
                    return
            }
            completion(.success(secret))
        })
        task.resume()

    }

       func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
           let url = self.baseURL.appendingPathComponent("ephemeral_keys")
           var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
           urlComponents.queryItems = [URLQueryItem(name: "api_version", value: apiVersion)]
           var request = URLRequest(url: urlComponents.url!)
           request.httpMethod = "POST"
           let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
               guard let response = response as? HTTPURLResponse,
                   response.statusCode == 200,
                   let data = data,
                   let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
                   completion(nil, error)
                   return
               }
               completion(json, nil)
           })
           task.resume()
       }
}
