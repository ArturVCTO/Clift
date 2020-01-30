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
    var products: [CartItem] = []
    let country = String()
    @IBOutlet weak var paymentLabel: UILabel!
    var backendBaseURL: String? = "https://stripe-demo-clift.herokuapp.com/"
//    lazy var cardTextField: STPPaymentCardTextField = {
//          let cardTextField = STPPaymentCardTextField()
//          return cardTextField
//    }()
    @IBOutlet weak var stripeContentView: UIView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    var totalAmount: Int?
    var subtotalAmount: Int?
    
    init() {
        if let backendBaseURL = UserDefaults.standard.string(forKey: "StripeBackendBaseURL") {
                   self.backendBaseURL = backendBaseURL
               }
        let backendBaseURL = self.backendBaseURL
        
        assert(backendBaseURL != nil, "You must set your backend base url at the top of CheckoutViewController.swift to run this app.")
        MyStripeApiClient.sharedClient.baseURLString = self.backendBaseURL
        
        super.init(nibName: nil, bundle: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customerContext = STPCustomerContext(keyProvider: MyStripeApiClient.sharedClient)
        let paymentContext = STPPaymentContext(customerContext: customerContext)
        self.paymentContext = paymentContext
        self.loadTotalAndSubtotal()
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

    }
        
    func pay() {
  
    }
    
    
    @IBAction func addPaymentInformationTapped(_ sender: Any) {
        self.paymentContext!.pushPaymentOptionsViewController()
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
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}


