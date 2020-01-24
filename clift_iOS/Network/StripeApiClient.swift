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
       var baseURLString: String? = nil
       var baseURL: URL {
           if let urlString = self.baseURLString, let url = URL(string: urlString) {
               return url
           } else {
               fatalError()
           }
       }
       
       func createPaymentIntent(cartProduct: [MockProduct], shippingMethod: Address?, country: String? = nil, completion: @escaping ((Result<String, Error>) -> Void)) {
           let url = self.baseURL.appendingPathComponent("create_payment_intent")
            var params: [String: Any] = [:]
           params["products"] = cartProduct.map({ (p) -> String in
                return p.name
           })
           
           params["country"] = "MX"
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
