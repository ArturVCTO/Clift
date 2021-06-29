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

enum PaymentType: String {
    case userLogIn
    case userGuest
    case userGuestPurchaseForMeFlow
}

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var checkoutProductTableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var stripeCommissionLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    var cartItems: [CartItem] = []
    var totalAmount: Double?
    var subTotalAmount: Double?
    var paymentType: PaymentType = .userLogIn
    var currentEvent = Event()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUINavBar()
        registerCells()
        tableViewSetup()
        view.addSubview(checkoutProductTableView)
        checkoutProductTableView.delegate = self
        checkoutProductTableView.dataSource = self
        checkoutProductTableView.translatesAutoresizingMaskIntoConstraints = false
        checkoutProductTableView.reloadData()
        getCartItems()
    }
    
    private func setUINavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
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
                        if self.cartItems.count > 0 {
                            self.getEventAddress(eventId: cartItems?.first?.eventProduct?.eventId ?? "")
                        }
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
    
    func getEventAddress(eventId: String) {
        sharedApiManager.getEventAddress(eventId: eventId) { (eventAddress, result) in
            if let response = result {
                if (response.isSuccess()) {
                    if let eventAddress = eventAddress {
                        self.getTotalAmountAndSubtotal(cartItems: self.cartItems, eventId: eventAddress.addressState.id)
                    }
                } else {
                    self.showMessage("Error al obtener información del evento", type: .error)
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
    
    func getTotalAmountAndSubtotal(cartItems: [CartItem], eventId: String) {
        var newResult = Double()
        let productsAmount: Double = cartItems.reduce(0.0) { result, cartItem in
            if let quantity = cartItem.quantity, let productPrice = cartItem.product?.price {
                newResult = result + (Double(productPrice) * Double(quantity))
            }
            return newResult
        }
        
        let shippingAmount = calculateShipping(cartItems: cartItems, eventId: eventId)
        var stripeCommission = (productsAmount + shippingAmount) * 0.038 + 6
        stripeCommission = Double(round(100 * stripeCommission) / 100)
        let totalAmount = productsAmount + stripeCommission + shippingAmount
        self.subTotalAmount = productsAmount
        self.totalAmount = totalAmount
        subtotalLabel.text = "\(self.getPriceStringFormat(value: productsAmount)) MXN"
        shippingLabel.text = "\(self.getPriceStringFormat(value: shippingAmount)) MXN"
        stripeCommissionLabel.text = "\(self.getPriceStringFormat(value: stripeCommission)) MXN"
        totalAmountLabel.text = "\(self.getPriceStringFormat(value: totalAmount)) MXN"
        
    }
    
    func calculateShipping(cartItems: [CartItem], eventId: String) -> Double {
        
        let storeItems = Dictionary(grouping: cartItems, by: {$0.product?.shop.name})
        var shippingAmount = 0.0
        for (_, value) in storeItems {
            let isLocalShipping = eventId == value.first?.product?.shop.shopAddress.addressState.id
            var shopAmount = 0.0
            
            for item in value {
                let productCost = isLocalShipping ? Double(item.product?.shippingCost ?? "0.0") : Double(item.product?.shippingCostNational ?? "0.0")
                let shopCost = isLocalShipping ? Double(item.product?.shop.shippingCost ?? "0.0") : Double(item.product?.shop.shippingCostNational ?? "0.0")
                let greaterCost = (productCost! < shopCost! ? shopCost : productCost)!
                
                if greaterCost > shopAmount {
                    shopAmount = greaterCost
                }
            }
            shippingAmount += shopAmount
        }
        return shippingAmount
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
            
            switch paymentType {
            case .userLogIn, .userGuestPurchaseForMeFlow:
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "paymentTableVC") as! PaymentTableViewController
                vc.userType = paymentType
                vc.products = self.cartItems
                vc.totalAmount = self.totalAmount
                vc.subtotalAmount = self.subTotalAmount
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .userGuest:
                let vc = UIStoryboard.init(name: "Checkout", bundle: nil).instantiateViewController(identifier: "PaymentVC") as! PaymentViewController
                vc.products = self.cartItems
                vc.currentEvent = currentEvent
                vc.totalAmount = self.totalAmount
                vc.subtotalAmount = self.subTotalAmount
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            
            switch paymentType {
            case .userLogIn, .userGuestPurchaseForMeFlow:
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "paymentTableVC") as! PaymentTableViewController
                vc.userType = paymentType
                vc.products = self.cartItems
                vc.totalAmount = self.totalAmount
                vc.subtotalAmount = self.subTotalAmount
                self.navigationController?.pushViewController(vc, animated: true)
            
            case .userGuest:
                let vc = UIStoryboard.init(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as! PaymentViewController
                vc.products = self.cartItems
                vc.currentEvent = currentEvent
                vc.totalAmount = self.totalAmount
                vc.subtotalAmount = self.subTotalAmount
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
        cell.configure(with: product, userType: paymentType)
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
