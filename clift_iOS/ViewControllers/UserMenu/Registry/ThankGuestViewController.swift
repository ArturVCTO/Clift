//
//  ThankGuestViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/24/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import DropDown

class ThankGuestViewController: UIViewController {
    @IBOutlet weak var giftImage: UIImageView!
    @IBOutlet weak var giftName: UILabel!
    @IBOutlet weak var giftShop: UILabel!
    @IBOutlet weak var giftPrice: UILabel!
    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var giftMessageTextField: HoshiTextField!
    var thankMessage: ThankMessage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getGiftInformation() {
        
    }
    
    @IBAction func sendMessageTapped(_ sender: Any) {
        self.showMessage("Mensaje enviado con éxito", type: .success)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ThankGuestViewController: UITextFieldDelegate {
    
}
