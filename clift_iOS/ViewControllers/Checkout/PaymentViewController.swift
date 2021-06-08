//
//  PaymentViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 26/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var cellphoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    //@IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var acceptPaymentButton: UIButton!
    
    var products: [CartItem] = []
    var totalAmount: Int?
    var subtotalAmount: Int?
    var checkoutObject = CheckoutGuest()
    var userData = CheckoutUserDataGuest()
    var currentEvent = Event()
    var firstMessage = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadTotalAndSubtotal()
        startCheckout()
        messageTextView.delegate = self
    }
    
    func setUI() {
        navigationItem.title = "CLIFT"
        acceptPaymentButton.layer.cornerRadius = 10
        messageTextView.layer.cornerRadius = 10
        messageTextView.layer.borderWidth = 0.5
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
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
    }
    
    func pay() {
        sharedApiManager.stripeCheckoutGuest(event: self.currentEvent , checkout: self.checkoutObject) { (stripe, result) in
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
    
    @IBAction func didTapAcceptButton(_ sender: UIButton) {
        
        guard let nameText = nameTextField.text, !nameText.isEmpty else {
            self.showMessage(NSLocalizedString("No has llenado el nombre", comment: ""),type: .error)
            return
        }
        
        guard let lastNameText = lastNameTextField.text, !lastNameText.isEmpty else {
            self.showMessage(NSLocalizedString("No has llenado el apellido", comment: ""),type: .error)
            return
        }
        
        guard let cellphoneText = cellphoneTextField.text, !cellphoneText.isEmpty else {
            self.showMessage(NSLocalizedString("No has llenado el número celular", comment: ""),type: .error)
            return
        }
        
        guard let emailText = emailTextField.text, !emailText.isEmpty else {
            self.showMessage(NSLocalizedString("No has llenado el correo", comment: ""),type: .error)
            return
        }
        
        guard let messageText = messageTextView.text, !messageText.isEmpty else {
            self.showMessage(NSLocalizedString("No has llenado el mensaje", comment: ""),type: .error)
            return
        }
        
        checkoutObject.userDataGuest.name = nameText
        checkoutObject.userDataGuest.lastName = lastNameText
        checkoutObject.userDataGuest.email = emailText
        checkoutObject.userDataGuest.cellPhoneNumber = cellphoneText
        checkoutObject.userDataGuest.note = messageText
        
        pay()
    }
}

extension PaymentViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if firstMessage {
            messageTextView.text = ""
            messageTextView.textColor = UIColor.black
            firstMessage = false
        }
    }
}
