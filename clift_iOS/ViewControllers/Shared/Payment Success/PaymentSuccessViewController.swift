//
//  PaymentSuccessViewController.swift
//  clift_iOS
//
//  Created by Lydia Marion Gonzalez on 28/06/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class PaymentSuccessViewController: UIViewController {
    
    @IBOutlet weak var orderNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupView() {
        
    }
    
    @IBAction func goToMainMenuButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
