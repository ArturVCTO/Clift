//
//  EnvelopeInfoViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 16/01/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class EnvelopeInfoViewController: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var cellphoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var envelopeTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var acceptPaymentButton: UIButton!
    
    var currentEventPool: EventPool = EventPool()
    var currentEvent: Event = Event()
    var checkoutObject = CheckoutEnvelope()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        amountTextField.delegate = self
    }
    
    func setUI() {
        navigationItem.title = "CLIFT"
        envelopeTitleLabel.text = currentEventPool.description
        acceptPaymentButton.layer.cornerRadius = 10
    }
    
    func pay() {
        sharedApiManager.stripeCheckoutEnvelope(event: currentEvent, pool: currentEventPool, checkout: checkoutObject) { (stripe, result) in
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
        
        guard let messageText = messageTextField.text, !messageText.isEmpty else {
            self.showMessage(NSLocalizedString("No has llenado el mensaje", comment: ""),type: .error)
            return
        }
        
        checkoutObject.amount = Double(amountText)
        checkoutObject.userData?.name = nameText
        checkoutObject.userData?.lastName = lastNameText
        checkoutObject.userData?.email = emailText
        checkoutObject.userData?.cellPhoneNumber = cellphoneText
        checkoutObject.userData?.note = messageText
        pay()
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
