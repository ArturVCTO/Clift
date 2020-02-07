//
//  PaymentConfirmationViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/23/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class PaymentConfirmationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
