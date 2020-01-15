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
import GSMessages

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
        self.cellphoneTextField.delegate = self
        self.emailTextField.delegate = self
        self.addressTextField.delegate = self
        self.districtTextField.delegate = self
        self.zipcodeTextField.delegate = self
    }
    
    func addAddress(address: Address) {
        sharedApiManager.addAddress(address: address) { (createdAddress, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showMessage("\(createdAddress!.errors.first ?? "Error en forma")", type: .error)
                }
            }
        }
    }
    
    func setupCountryDropDown() {
        countryDropDown.anchorView = self.countryButton
        countryDropDown.dataSource = ["Mexico"]
        countryDropDown.bottomOffset = CGPoint(x: 0, y: countryButton.bounds.height)
    }
    
    func setupStateDropDown() {
        stateDropDown.anchorView = self.stateButton
        stateDropDown.dataSource = ["Nuevo León"]
        stateDropDown.bottomOffset = CGPoint(x: 0, y: stateButton.bounds.height)
    }
    
    func setupCityDropDown() {
        cityDropDown.anchorView = self.cityButton
        cityDropDown.dataSource = ["Monterrey"]
        cityDropDown.bottomOffset = CGPoint(x: 0, y: cityButton.bounds.height)
    }
    
   
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let address = self.address else { return }
        self.addAddress(address: address)
    }
    
    @IBAction func countryButtonTapped(_ sender: Any) {
        self.countryDropDown.show()
    }
    
    @IBAction func stateButtonTapped(_ sender: Any) {
        self.stateDropDown.show()
    }
    
    @IBAction func cityButtonTapped(_ sender: Any) {
        self.cityDropDown.show()
    }
}
extension AddAddressViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            self.address?.firstName = self.firstNameTextField.text!
        case lastNameTextField:
            self.address?.lastName = self.lastNameTextField.text!
        case cellphoneTextField:
            self.address?.cellPhoneNumber = self.cellphoneTextField.text!
        case emailTextField:
            self.address?.email = self.emailTextField.text!
        case addressTextField:
            self.address?.streetAndNumber = self.addressTextField.text!
        case districtTextField:
            self.address?.suburb = self.addressTextField.text!
        case zipcodeTextField:
            self.address?.zipCode = self.zipcodeTextField.text!
        default:
            return
        }
    }
}
