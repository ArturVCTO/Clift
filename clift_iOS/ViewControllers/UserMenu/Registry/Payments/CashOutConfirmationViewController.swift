//
//  CashOutConfirmationViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/27/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class CashOutConfirmationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func acceptButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
