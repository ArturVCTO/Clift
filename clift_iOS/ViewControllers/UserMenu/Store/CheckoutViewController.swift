//
//  CheckoutViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/16/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import Stripe

//  This struct is for mock purposes only
struct MockProduct {
    let price: Double
    let name: String
    let image: UIImage
    let quantity: Int
}

class CheckoutViewController: UIViewController {
    @IBOutlet weak var checkoutProductTableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var totalShopsShippingLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalProductsLabel: UILabel!
//    This variable object is for mock purposes only
    var cartItems: [MockProduct] = [
        MockProduct(price: 2000, name: "Licuadora SmartPower ™ Duet de 500 vatios.",image: UIImage(named: "15")!, quantity: 1),
        MockProduct(price: 2500, name: "1.5 Qt Fruit Scoop Máquina de postres congelados.",image: UIImage(named: "15")!, quantity: 1),
        MockProduct(price: 2750, name: "Banco de almacenamiento de zapatos tapizado en cuero.",image: UIImage(named: "15")!, quantity: 1)
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()
        self.view.addSubview(checkoutProductTableView)
        self.checkoutProductTableView.delegate = self
        self.checkoutProductTableView.dataSource = self
        self.checkoutProductTableView.translatesAutoresizingMaskIntoConstraints = false
        self.checkoutProductTableView.reloadData()
        self.getTotalAmountAndSubtotal(cartItems: cartItems)
    }
    
    func getPriceStringFormat(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
              
        return formatter.string(from: NSNumber(value: value))!
    }
    
    func tableViewSetup() {
        self.checkoutProductTableView.separatorStyle = .singleLine
        self.checkoutProductTableView.rowHeight = 134
    }
    
    func getTotalAmountAndSubtotal(cartItems: [MockProduct]) {
        let totalAmount = cartItems.reduce(0) { result, product in
            return result + (product.price * Double(product.quantity))
        }
        self.totalAmountLabel.text = "\(self.getPriceStringFormat(value:totalAmount))"
        self.subtotalLabel.text = "\(self.getPriceStringFormat(value:totalAmount))"
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToPaymentCheckoutVC(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "paymentCheckoutVC") as! PaymentCheckoutViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "paymentCheckoutVC") as! PaymentCheckoutViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension CheckoutViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "checkoutProductCell") as? CheckoutProductCell else {
            return UITableViewCell()
        }
        let product = self.cartItems[indexPath.row]
        cell.configure(with: product)
        return cell
    }
}
