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

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var checkoutProductTableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var stripeCommissionLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    var cartItems: [CartItem] = []
    var totalAmount: Int?
    var subTotalAmount: Int?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        self.tableViewSetup()
        self.view.addSubview(checkoutProductTableView)
        self.checkoutProductTableView.delegate = self
        self.checkoutProductTableView.dataSource = self
        self.checkoutProductTableView.translatesAutoresizingMaskIntoConstraints = false
        self.checkoutProductTableView.reloadData()
        self.getCartItems()
    }
    
    private func registerCells() {
        checkoutProductTableView.register(UINib(nibName: "CheckoutProductCell", bundle: nil), forCellReuseIdentifier: "checkoutProductCell")
    }
    
    func getCartItems(fromDelete: Bool = false) {
        sharedApiManager.getCartItems() { (cartItems, result) in
            if let response = result {
                if (response.isSuccess()) {
                    if let optCartItems = cartItems {
                        self.cartItems = optCartItems
                        self.getTotalAmountAndSubtotal(cartItems: optCartItems)
                        self.checkoutProductTableView.reloadData()
                        if fromDelete {
                            self.checkIfProductsExistsInCart()
                        }
                    }
                } else if (response.isClientError()) {
                    self.showMessage("Hubo un error cargando el carrito de compras.", type: .error)
                } else {
                    self.showMessage("Hubo un error cargando el carrito de compras.", type: .error)
                }
            }
        }
    }
    
    func deleteCartItem(cartItem: CartItem) {
        sharedApiManager.deleteItemFromCart(cartItem: cartItem) { (emptyObject, result) in
            if let response = result {
                if response.isSuccess() {
                    self.showMessage("Producto borrado del carrito.", type: .error)
                    self.getCartItems(fromDelete: true)
                    self.checkoutProductTableView.reloadData()
                }
            }
        }
    }
    
    func getPriceStringFormat(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
              
        return formatter.string(from: NSNumber(value: value))!
    }
    
    func tableViewSetup() {
        self.checkoutProductTableView.separatorStyle = .singleLine
    }
    
    func getTotalAmountAndSubtotal(cartItems: [CartItem]) {
        var newResult = Int()
        let totalAmount = cartItems.reduce(0) { result, cartItem in
            if let quantity = cartItem.quantity, let productPrice = cartItem.product?.price {
                newResult = result + (productPrice * quantity)
            }
            return newResult
        }
        self.totalAmountLabel.text = "\(self.getPriceStringFormat(value: Double(totalAmount))) MXN"
        self.subtotalLabel.text = "\(self.getPriceStringFormat(value: Double(totalAmount))) MXN"
        self.totalAmount = totalAmount
        self.subTotalAmount = totalAmount
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkIfProductsExistsInCart() {
        if cartItems.isEmpty {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func goToPaymentCheckoutVC(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "paymentTableVC") as! PaymentTableViewController
            vc.products = self.cartItems
            vc.totalAmount = self.totalAmount
            vc.subtotalAmount = self.subTotalAmount

            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "paymentTableVC") as! PaymentTableViewController
            vc.products = self.cartItems
            vc.totalAmount = self.totalAmount
            vc.subtotalAmount = self.subTotalAmount
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
        cell.vc = self
        cell.configure(with: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
         let deleteTitle = NSLocalizedString("Borrar", comment: "Delete action")
         
         let deleteAction = UITableViewRowAction(style: .destructive,
           title: deleteTitle) { (action, indexPath) in
            self.deleteCartItem(cartItem: self.cartItems[indexPath.row])
         }
         
         return [deleteAction]
     }
}
