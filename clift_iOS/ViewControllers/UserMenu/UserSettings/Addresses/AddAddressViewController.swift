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
    var addressesTableVC: AddressesTableViewController!
    var cityDropDown = DropDown()
    var stateDropDown = DropDown()
    var countryDropDown = DropDown()
    var address: Address? = Address()
    var cities: [AddressCity] = []
    var states: [AddressState] = []
    var country: [AddressCountry] = []
    var yOrigin = CGFloat()
    
    
    override func viewDidAppear(_ animated: Bool) {
        yOrigin =  self.view.frame.origin.y
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDropDownStyle()
        self.setupDropDowns()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnClickOutside))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if(!(firstNameTextField.isEditing || lastNameTextField.isEditing || cellphoneTextField.isEditing || emailTextField.isEditing)){
            
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                
                if self.view.frame.origin.y == self.yOrigin {
                    self.view.frame.origin.y -= (keyboardSize.height * 0.75)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != self.yOrigin {
            self.view.frame.origin.y = self.yOrigin
        }
    }
    
    @IBAction func hideKeyboardOnClickOutside(){
        view.endEditing(true)
    }
    
    func addAddress(address: Address) {
        hideKeyboardOnClickOutside()
         
        self.address?.firstName = self.firstNameTextField.text!
        self.address?.lastName = self.lastNameTextField.text!
        self.address?.cellPhoneNumber = self.cellphoneTextField.text!
        self.address?.email = self.emailTextField.text!
        self.address?.streetAndNumber = self.addressTextField.text!
        self.address?.suburb = self.districtTextField.text!
        self.address?.zipCode = self.zipcodeTextField.text!
        
        sharedApiManager.addAddress(address: address) { (createdAddress, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.addressesTableVC.getAddresses()
                    self.parent?.showMessage("Nueva dirección registrada", type: .success)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showMessage("\(createdAddress!.errors.first ?? "Error en forma")", type: .error)
                }
            }
        }
    }
    
    func setupDropDownStyle() {
      let appearance = DropDown.appearance()
      appearance.cornerRadius = 4
      appearance.cellHeight = 40
    }
    
    func setupDropDowns() {
        setupCityDropDown()
        setupStateDropDown()
        setupCountryDropDown()
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
        sharedApiManager.getStates(){(states, result) in
            if let response = result {
                if (response.isSuccess()) {
                    var statesNames:[String] = []
                    self.states = states ?? []
                    for state in states!{
                        statesNames.append(state.name!)
                    }
                    self.stateDropDown.dataSource = statesNames
                }
            }
        }
        
        stateDropDown.anchorView = self.stateButton
        //stateDropDown.dataSource = ["Nuevo León"]
        stateDropDown.bottomOffset = CGPoint(x: 0, y: stateButton.bounds.height)
    
        stateDropDown.selectionAction = { [weak self] (index, item) in
            self?.stateButton.setTitle(item, for: .normal)
            self?.address?.state = self?.states[index] as! AddressState
            self?.setupCityDropDown() 
            print(self?.address?.state)
        }
    }
    
    func setupCityDropDown() {
//      JC:  Pending to see client initial data for cities
        
        sharedApiManager.getCities(stateId: (self.address?.state.id)!){(cities, result) in
            if let response = result {
                if (response.isSuccess()) {
                    var cityNames:[String] = []
                    self.cities = cities ?? []
                    for city in cities!{
                        cityNames.append(city.name!)
                    }
                    self.cityDropDown.dataSource = cityNames
                }
            }
        }
        cityDropDown.anchorView = self.cityButton
        //cityDropDown.dataSource = ["Monterrey"]
        cityDropDown.bottomOffset = CGPoint(x: 0, y: cityButton.bounds.height)
        cityDropDown.selectionAction = { [weak self] (index, item) in
            self?.cityButton.setTitle(item, for: .normal)
            self?.address?.city = self?.cities[index] as! AddressCity
        }
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
