//
//  ShippingTableViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/23/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import DropDown

class ShippingTableViewController: UITableViewController {
    var hasAddressSet = false
    var paymentTableVC: PaymentTableViewController!
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var cellphoneTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var streetAndNumberTextField: HoshiTextField!
    @IBOutlet weak var districtTextField: HoshiTextField!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var zipCodeTextField: UITextField!
    var cityDropDown = DropDown()
    var stateDropDown = DropDown()
    var countryDropDown = DropDown()
    var address: Address? = Address()
    var cities: [AddressCity] = []
    var states: [AddressState] = []
    var country: [AddressCountry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.cellphoneTextField.delegate = self
        self.emailTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.streetAndNumberTextField.delegate = self
        self.districtTextField.delegate = self
        self.zipCodeTextField.delegate = self
        self.setupDropDowns()
    }
    
    func addAddress(address: Address) {
           sharedApiManager.addAddress(address: address) { (createdAddress, result) in
               if let response = result {
                   if (response.isSuccess()) {
                    self.paymentTableVC.hasAddressSet = true
                       self.navigationController?.popViewController(animated: true)
                   } else {
                       self.showMessage("\(createdAddress!.errors.first ?? "Error en forma")", type: .error)
                   }
               }
           }
       }
    
    func setupDropDowns() {
        self.setupCountryDropDown()
        self.setupStateDropDown()
        self.setupCityDropDown()
    }
    
    func setupCountryDropDown() {
    //      JC:  Pending to see client initial data for countries
            countryDropDown.anchorView = self.countryButton
            countryDropDown.dataSource = ["Mexico"]
            countryDropDown.bottomOffset = CGPoint(x: 0, y: countryButton.bounds.height)
            let mexico = AddressCountry()
            mexico.name = "Mexico"
            mexico.code = "1"
            countryDropDown.selectionAction = { [weak self] (index, item) in
                self?.countryButton.setTitle(item, for: .normal)
                self?.address?.country = mexico
            }
        }
        
        func setupStateDropDown() {
    //      JC:  Pending to see client initial data for states
            stateDropDown.anchorView = self.stateButton
            stateDropDown.dataSource = ["Nuevo León"]
            stateDropDown.bottomOffset = CGPoint(x: 0, y: stateButton.bounds.height)
            let nuevoLeon = AddressState()
            nuevoLeon.name = "Nuevo León"
            nuevoLeon.code = "1"
            stateDropDown.selectionAction = { [weak self] (index, item) in
                self?.stateButton.setTitle(item, for: .normal)
                self?.address?.state = nuevoLeon
            }
        }
        
        func setupCityDropDown() {
    //      JC:  Pending to see client initial data for cities
            cityDropDown.anchorView = self.cityButton
            cityDropDown.dataSource = ["Monterrey"]
            cityDropDown.bottomOffset = CGPoint(x: 0, y: cityButton.bounds.height)
            let monterrey = AddressCity()
            monterrey.name = "Monterrey"
            monterrey.code = "1"
            cityDropDown.selectionAction = { [weak self] (index, item) in
                self?.cityButton.setTitle(item, for: .normal)
                self?.address?.city = monterrey
            }
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
    
    @IBAction func useAddressButtonTapped(_ sender: Any) {
        if let address = self.address {
            self.addAddress(address: address)
        }
    }
}
extension ShippingTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            self.address?.firstName = self.nameTextField.text!
        case lastNameTextField:
            self.address?.lastName = self.lastNameTextField.text!
        case cellphoneTextField:
            self.address?.cellPhoneNumber = self.cellphoneTextField.text!
        case emailTextField:
            self.address?.email = self.emailTextField.text!
        case streetAndNumberTextField:
            self.address?.streetAndNumber = self.streetAndNumberTextField.text!
        case districtTextField:
            self.address?.suburb = self.districtTextField.text!
        case zipCodeTextField:
            self.address?.zipCode = self.zipCodeTextField.text!
        default:
            return
        }
    }
}
