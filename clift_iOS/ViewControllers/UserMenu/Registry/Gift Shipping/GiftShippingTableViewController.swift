//
//  GiftShippingTableViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/28/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class GiftShippingTableViewController: UITableViewController {
    
    override func viewDidLoad() {
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
              let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "giftShippingConfirmationVC") as! GiftShippingConfirmationViewController
              self.navigationController?.pushViewController(vc, animated: true)
          } else {
            // Fallback on earlier versions
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "giftShippingConfirmationVC") as! GiftShippingConfirmationViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
