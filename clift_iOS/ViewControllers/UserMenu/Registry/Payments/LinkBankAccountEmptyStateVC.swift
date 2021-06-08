//
//  LinkBankAccountEmptyStateVC.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/6/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class LinkBankAccountEmptyStateVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    @IBAction func tapCancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "bankAccountFormVC") as! BankAccountFormViewController
            self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            self.navigationController?.pushViewController(vc, animated: true)
            
                     } else {
                       // Fallback on earlier versions
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "bankAccountFormVC") as! BankAccountFormViewController
            self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
