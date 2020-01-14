//
//  AddAddressViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/10/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import DropDown

class AddAddressViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var cellphoneTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var addressTextField: HoshiTextField!
    @IBOutlet weak var districtTextField: HoshiTextField!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var zipcodeTextField: UITextField!
    var cityDropDown = DropDown()
    var stateDropDown = DropDown()
    var countryDropDown = DropDown()
    var address: Address? = Address()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.addressTextField.delegate = self
        self.districtTextField.delegate = self
        self.zipcodeTextField.delegate = self
    }
    
    func addAddress(address: Address) {
        sharedApiManager.addAddress(address: address) { (address, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let address = self.address else { return }
        self.addAddress(address: address)
    }
}
extension AddAddressViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case textField == firstNameTextField:
            self.address?.firstName = self.firstNameTextField.text!
        case textField == lastNameTextField:
            self.address?.lastName = self.lastNameTextField.text!
        case textField == cellphoneTextField:
            self.address?.cellPhoneNumber = self.cellphoneTextField.text!
        case textField == emailTextField:
            self.address?.email = self.emailTextField.text!
        case textField == addressTextField:
            self.address?.streetAndNumber = self.addressTextField.text!
        case textField == districtTextField:
            self.address?.suburb = self.addressTextField.text!
        case textField == zipcodeTextField:
            self.address?.zipCode = self.zipcodeTextField.text!
        }
    }
}
