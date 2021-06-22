//
//  EnvelopeInfoViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 16/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit
import Stripe

class EnvelopeInfoViewController: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var cellphoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var envelopeTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var acceptPaymentButton: UIButton!
    
    var currentEventPool: EventPool = EventPool()
    var currentEvent: Event = Event()
    var checkoutObject = CheckoutEnvelope()
    var firstMessage = true
    var stripeObject = StripeCheckout()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        amountTextField.delegate = self
        messageTextView.delegate = self
    }
    
    func setUI() {
        navigationItem.title = "CLIFT"
        envelopeTitleLabel.text = currentEventPool.description
        acceptPaymentButton.layer.cornerRadius = 10
        messageTextView.layer.cornerRadius = 10
        messageTextView.layer.borderWidth = 0.5
        messageTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func presentCardView() {
        let viewController = UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "CustomPaymentCardVC") as! CustomPaymentCardViewController
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func createPaymentIntent() {
        sharedApiManager.stripeCheckoutEnvelope(event: currentEvent, pool: currentEventPool, checkout: checkoutObject) { (stripe, result) in
            if let response = result {
                if response.isSuccess() {
                    self.presentCardView()
                    if let stripeObject = stripe {
                        self.stripeObject = stripeObject
                    }
                }
            }
        }
    }
    
    func confirmPaymentIntent(stripeObject: StripeCheckout, billingDetails: STPPaymentMethodBillingDetails?, cardInfo: STPPaymentMethodCardParams) {
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: stripeObject.clientSecret)
        
        let paymentMethodParams = STPPaymentMethodParams(card: cardInfo, billingDetails: billingDetails, metadata: nil)
        
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        STPPaymentHandler.shared().confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            switch (status) {
            case .failed:
                print("Payment failed")
                print(error?.localizedDescription ?? "")
                break
            case .canceled:
                print("Payment canceled")
                break
            case .succeeded:
                print("Payment succeeded")
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }
    
    func verifyUserData() {
        
        guard let amountText = amountTextField.text, !amountText.isEmpty else {
            self.showMessage(NSLocalizedString("No has llenado la cantidad", comment: ""),type: .error)
            return
        }
        
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
        
        checkoutObject.amount = Double(amountText)
        checkoutObject.userData.name = nameText
        checkoutObject.userData.lastName = lastNameText
        checkoutObject.userData.email = emailText
        checkoutObject.userData.cellPhoneNumber = cellphoneText
        checkoutObject.userData.note = messageText
        
        createPaymentIntent()
    }
    
    @IBAction func didTapAcceptButton(_ sender: UIButton) {
        verifyUserData()
    }
}

extension EnvelopeInfoViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        amountLabel.text = "$ \(amountTextField.text ?? "")"
    }
}

extension EnvelopeInfoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if firstMessage {
            messageTextView.text = ""
            messageTextView.textColor = UIColor.black
            firstMessage = false
        }
    }
}

extension EnvelopeInfoViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

extension EnvelopeInfoViewController: CustomPaymentCardViewControllerDelegate {
    func CustomPaymentCardViewControllerDidCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func CustomPaymentCardViewControllerDidPay(billingDetails: STPPaymentMethodBillingDetails, methodCardParams: STPPaymentMethodCardParams) {
        confirmPaymentIntent(stripeObject: stripeObject, billingDetails: billingDetails, cardInfo: methodCardParams)
        dismiss(animated: true, completion: nil)
    }
}
