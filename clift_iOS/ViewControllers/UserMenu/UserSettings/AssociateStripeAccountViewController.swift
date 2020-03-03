//
//  AssociateStripeAccountViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 2/26/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import Stripe
import UIKit
import TextFieldEffects
import DropDown

struct UserStripeParams {
    let name: String
    let lastName: String
    let dateOfBirth: DateComponents
    let email: String
    let gender: String
    let maidenName: String
    let phone: String
    let idNumber: String
    let fileFrontId: String
    let fileBackId: String
}

struct AddressParams {
    let city: String
    let country: String
    let line1: String
    let line2: String
    let postalCode: String
    let state: String
    let town: String
}

class AssociateStripeAccountViewController: UITableViewController {
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var maidenNameTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var cellphoneTextField: HoshiTextField!
    @IBOutlet weak var genderDropdownButton: UIButton!
    var currentUser: User?
    var genderDropdown = DropDown()
    var genders = ["Hombre","Mujer","Otro","Prefiero no decirlo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getProfile()
        self.setupDropDownStyle()
        self.setupGenderDD()
        self.getAddresses()
    }
    
    func getProfile() {
        sharedApiManager.getProfile() { (user,result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.loadCurrentUserData(user: user!)
                }
            }
        }
    }
    
    func setupDropDownStyle() {
        let appearance = DropDown.appearance()
        appearance.cornerRadius = 4
        appearance.cellHeight = 40
    }
    
    func getCompanyParams(individualConnect: UserStripeParams, addressConnect: AddressParams) {
        let companyParams = STPConnectAccountIndividualParams()
        let addressParams = STPConnectAccountAddress()
        companyParams.firstName = individualConnect.name
        
        addressParams.city = addressConnect.city
        companyParams.address = addressParams
    }
    
    func loadCurrentUserData(user: User) {
        self.nameTextField.text = user.name
        self.lastNameTextField.text = user.lastName
        self.emailTextField.text = user.email
        self.cellphoneTextField.text = user.cellPhoneNumber
    }
    
    func getAddresses() {
        sharedApiManager.getAddresses() { (addresses, result) in
            if let response = result {
                if response.isSuccess() {
                    if !(addresses!.isEmpty) {
                        if let addresses = addresses {
                            for address in addresses {
                                if address.isDefault {
                                    self.loadAddressData(address: address)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getDefaultAddress() {
        
    }
    
    func loadAddressData(address: Address) {
        
    }
    
    func setupGenderDD() {
        var dataSourceDropDown = [String]()
        genderDropdown.anchorView = self.genderDropdownButton
        
        for gender in genders {
            dataSourceDropDown.append("\(gender)")
        }
        genderDropdown.dataSource = dataSourceDropDown
        genderDropdown.bottomOffset = CGPoint(x: 0, y: genderDropdownButton.bounds.height)
        
        genderDropdown.selectionAction = { [weak self] (index, item) in
            self!.genderDropdownButton.setTitle(item, for: .normal)
        }
    }
    
    @IBAction func genderDropdownTapped(_ sender: Any) {
        genderDropdown.show()
    }
}
