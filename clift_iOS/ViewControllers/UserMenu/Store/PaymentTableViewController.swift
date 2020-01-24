//
//  PaymentTableViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/22/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import GSMessages

class PaymentTableViewController: UITableViewController {
    var paymentIntentClientSecret: String?
    var paymentContext: STPPaymentContext?
    var products: [MockProduct] = []
    let country = String()
    @IBOutlet weak var paymentLabel: UILabel!
    var backendBaseURL: String? = "https://stripe-demo-clift.herokuapp.com/"
    lazy var cardTextField: STPPaymentCardTextField = {
          let cardTextField = STPPaymentCardTextField()
          return cardTextField
    }()
    @IBOutlet weak var stripeContentView: UIView!
    
    init() {
        if let backendBaseURL = UserDefaults.standard.string(forKey: "StripeBackendBaseURL") {
                   self.backendBaseURL = backendBaseURL
               }
        let backendBaseURL = self.backendBaseURL
        
        assert(backendBaseURL != nil, "You must set your backend base url at the top of CheckoutViewController.swift to run this app.")
        MyStripeApiClient.sharedClient.baseURLString = self.backendBaseURL
        let customerContext = STPCustomerContext(keyProvider: MyStripeApiClient.sharedClient)
        let paymentContext = STPPaymentContext(customerContext: customerContext)
        self.paymentContext = paymentContext
        super.init(nibName: nil, bundle: nil)
        self.paymentContext?.delegate = self
        self.paymentContext?.hostViewController = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startCheckout()
        cardTextField.frame = CGRect(x: 8, y: 48, width: self.stripeContentView.frame.maxX - 16, height: 40)
        stripeContentView.addSubview(cardTextField)
    }
    
    func startCheckout() {
        let url = URL(string: (backendBaseURL)! + "create-payment-intent")!
               let json: [String: Any] = [
                   "currency": "mxn",
                   "items": [
                       "id": "photo_subscription"
                   ]
               ]
               var request = URLRequest(url: url)
               request.httpMethod = "POST"
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")
               request.httpBody = try? JSONSerialization.data(withJSONObject: json)
               let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                   guard let response = response as? HTTPURLResponse,
                       response.statusCode == 200,
                       let data = data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                       let clientSecret = json["clientSecret"] as? String,
                       let publishableKey = json["publishableKey"] as? String else {
                           let message = error?.localizedDescription ?? "Failed to decode response from server."
                           return
                   }
                   print("Created PaymentIntent")
                   self?.paymentIntentClientSecret = clientSecret
                   // Configure the SDK with your Stripe publishable key so that it can make requests to the Stripe API
                   // For added security, our sample app gets the publishable key from the server
                   Stripe.setDefaultPublishableKey(publishableKey)
               })
               task.resume()
    }
        
    func pay() {
        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
            return
        }
        
        let cardParams = cardTextField.cardParams
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
            switch (status) {
              case .failed:
                self.showMessage("payment Failed", type: .error)
                  break
              case .canceled:
                  self.showMessage("payment canceled", type: .error)
                  break
              case .succeeded:
                  self.showMessage("payment succedded", type: .success)
                  break
              @unknown default:
                  fatalError()
                  break
              }
        }
    }
    
    @IBAction func completePaymentButtonTapped(_ sender: Any) {
        self.pay()
    }
    
    @IBAction func addShippingButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "shippingTableVC") as! ShippingTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shippingTableVC") as! ShippingTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addDiscountCuponTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "discountCodeVC") as! DiscountCodeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "discountCodeVC") as! DiscountCodeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension PaymentTableViewController: STPPaymentContextDelegate {
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
                  title: "Error",
                  message: error.localizedDescription,
                  preferredStyle: .alert
              )
              let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                  // Need to assign to _ because optional binding loses @discardableResult value
                  // https://bugs.swift.org/browse/SR-1681
                  _ = self.navigationController?.popViewController(animated: true)
              })
//              let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
//                  self.paymentContext.retryLoading()
//              })
              alertController.addAction(cancel)
//              alertController.addAction(retry)
              self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let paymentOption = paymentContext.selectedPaymentOption {
            self.paymentLabel.text = paymentOption.label
        } else {
            self.paymentLabel.text = ""
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        MyStripeApiClient.sharedClient.createPaymentIntent(cartProduct: self.products, shippingMethod: nil, country: self.country ) {(result) in
            switch result {
            case .success(let clientSecret):
                // Confirm the PaymentIntent
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.configure(with: paymentResult)
                paymentIntentParams.returnURL = "payments-example://stripe-redirect"
                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
                    switch status {
                    case .succeeded:
                        // Our example backend asynchronously fulfills the customer's order via webhook
                        // See https://stripe.com/docs/payments/payment-intents/ios#fulfillment
                        completion(.success, nil)
                    case .failed:
                        completion(.error, error)
                    case .canceled:
                        completion(.userCancellation, nil)
                    @unknown default:
                        completion(.error, nil)
                    }
                }
            case .failure(let error):
                print("Failed to create a Payment Intent: \(error)")
                completion(.error, error)
                break
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        let title: String
        let message: String
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success"
            message = "Your purchase was successful!"
        case .userCancellation:
            return()
        @unknown default:
            return()
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
extension PaymentTableViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
