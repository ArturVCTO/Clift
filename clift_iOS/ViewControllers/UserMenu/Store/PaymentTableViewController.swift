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
    var products: [CartItem] = []
    var checkoutObject = Checkout()
    var userData = CheckoutUserData()
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    var totalAmount: Int?
    var subtotalAmount: Int?
    var currentEvent = Event()
    var hasAddressSet = false
    var userType: PaymentType = .userLogIn
    var address: Address? = Address()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTotalAndSubtotal()
        if userType == .userLogIn {
            getEvent()
        }
        startCheckout()
    }
    
    func loadTotalAndSubtotal() {
        self.subtotalLabel.text = "\((getPriceStringFormat(value: Double(subtotalAmount ?? 0))))"
        self.totalLabel.text = "\((getPriceStringFormat(value: Double(totalAmount ?? 0))))"
    }
    
    func getPriceStringFormat(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
              
        return formatter.string(from: NSNumber(value: value))!
    }
    
    func startCheckout() {
        for product in products {
            self.checkoutObject.cartItemIds.append(product.id)
        }
        self.checkoutObject.userData = self.userData
    }
        
    func pay() {
        sharedApiManager.stripeCheckout(event: self.currentEvent , checkout: self.checkoutObject) { (stripe, result) in
            if let response = result {
                if response.isSuccess() {
                    if #available(iOS 13.0, *) {
                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "stripeCheckoutVC") as! StripeCheckoutViewController
                        vc.checkoutSessionId = stripe!.id!
                        vc.successUrl = stripe!.successUrl!
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "stripeCheckoutVC") as! StripeCheckoutViewController
                        vc.checkoutSessionId = stripe!.id!
                        vc.successUrl = stripe!.successUrl!
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func payPurchaseForMe() {
        var checkoutGuest = prepareCheckoutGuest()
        sharedApiManager.stripeCheckoutPurchaseForMe(checkout: checkoutGuest) { (stripe, result) in
            if let response = result {
                if response.isSuccess() {
                    if #available(iOS 13.0, *) {
                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "stripeCheckoutVC") as! StripeCheckoutViewController
                        vc.checkoutSessionId = stripe!.id!
                        vc.successUrl = stripe!.successUrl!
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "stripeCheckoutVC") as! StripeCheckoutViewController
                        vc.checkoutSessionId = stripe!.id!
                        vc.successUrl = stripe!.successUrl!
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    func prepareCheckoutGuest() -> CheckoutGuest {
        var checkoutGuest = CheckoutGuest()
        checkoutGuest.cartItemIds = checkoutObject.cartItemIds
        checkoutGuest.userDataGuest.name = address?.firstName
        checkoutGuest.userDataGuest.lastName = address?.lastName
        checkoutGuest.userDataGuest.email = address?.email
        checkoutGuest.userDataGuest.cellPhoneNumber = address?.cellPhoneNumber
        checkoutGuest.userDataGuest.shippingAddress.streetAndNumber = address?.streetAndNumber
        checkoutGuest.userDataGuest.shippingAddress.suburb = address?.suburb
        checkoutGuest.userDataGuest.shippingAddress.zipCode = address?.zipCode
        checkoutGuest.userDataGuest.shippingAddress.addressStateId = address?.state.code
        checkoutGuest.userDataGuest.shippingAddress.addressCityId = address?.city.code
        return checkoutGuest
    }
    
    func getEvent() {
          sharedApiManager.getEvents() { (events, result) in
              if let response = result {
                  if (response.isSuccess()) {
                      if let events = events {
                        self.currentEvent = events.first!
                      }
                  }
              }
          }
      }
    
    @IBAction func completePaymentButtonTapped(_ sender: Any) {
        if hasAddressSet {
            if userType == .userLogIn {
                pay()
            } else {
                payPurchaseForMe()
            }
        }
        else {
            self.showMessage("No has seleccionado dirección para enviar.", type: .error)
        }
    }
    
    @IBAction func addShippingButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "shippingTableVC") as! ShippingTableViewController
            vc.userType = userType
            vc.paymentTableVC = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shippingTableVC") as! ShippingTableViewController
            vc.userType = userType
            vc.paymentTableVC = self
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
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}


