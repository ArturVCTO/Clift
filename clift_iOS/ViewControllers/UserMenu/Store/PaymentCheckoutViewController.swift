//
//  PaymenyCheckoutViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/21/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import Stripe

class PaymentCheckoutViewController: UIViewController {
    let addCardViewController = STPAddCardViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addCardButtonTapped(_ sender: Any) {
        addCardViewController.delegate = self
        self.navigationController?.pushViewController(addCardViewController, animated: true)
    }
}
extension PaymentCheckoutViewController: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
      navigationController?.popViewController(animated: true)
    }

    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
    }
}
