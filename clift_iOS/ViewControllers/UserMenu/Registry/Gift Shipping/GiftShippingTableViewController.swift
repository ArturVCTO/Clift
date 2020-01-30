//
//  GiftShippingTableViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/28/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import DropDown

class GiftShippingTableViewController: UITableViewController {
    var address: Address?
    @IBOutlet weak var cellphoneNumberTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var streetAndNumberTextField: HoshiTextField!
    @IBOutlet weak var districtTextField: HoshiTextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var countryButtonDropdown: UIButton!
    @IBOutlet weak var stateButtonDropdown: UIButton!
    @IBOutlet weak var cityButtonDropdown: UIButton!
    
    override func viewDidLoad() {
        self.loadAddress()
    }
    
    func loadAddress() {
        if address != nil {
            self.cellphoneNumberTextField.text = self.address?.cellPhoneNumber
            self.emailTextField.text = self.address?.email
            self.lastNameTextField.text = self.address?.lastName
            self.nameTextField.text = self.address?.firstName
            self.streetAndNumberTextField.text = self.address?.streetAndNumber
            self.districtTextField.text = self.address?.suburb
            self.zipcodeTextField.text = self.address?.zipCode
            
            self.cityButtonDropdown.setTitle(self.address?.city.name, for: .normal)
            self.stateButtonDropdown.setTitle(self.address?.state.name, for: .normal)
            self.countryButtonDropdown.setTitle(self.address?.country.name, for: .normal)
        }
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Solicitud de envio.", message: "¿Desea continuar?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Sí", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
//        if #available(iOS 13.0, *) {
//              let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "giftShippingConfirmationVC") as! GiftShippingConfirmationViewController
//              self.navigationController?.pushViewController(vc, animated: true)
//          } else {
//            // Fallback on earlier versions
//            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "giftShippingConfirmationVC") as! GiftShippingConfirmationViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
