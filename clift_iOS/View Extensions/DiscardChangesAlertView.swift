//
//  DiscardChangesAlertView.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/29/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class DiscardChangesAlertView: UIViewController {
    
    
    @IBOutlet weak var alertView: customView!
    var delegate: DiscardChangesViewDeleagate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateView()
    }
    
    @IBAction func dismissAlert(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alertView.alpha = 0.0
            self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    
    @IBAction func stayButtonTapped(_ sender: Any) {
        self.dismiss(animated:  true, completion: nil)
    }
    
    @IBAction func discardChangesButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.discardChangesButtonTapped()
    }
    
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
}
