//
//  AddressOnboardingViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 5/11/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import TextFieldEffects


class AddressOnboardingViewController: UIViewController {
    var rootParentVC: RootOnboardViewController!
    var stateDropDown = DropDown()
    var cityDropDown = DropDown()
    var selectedStateId = ""
    var selectedCityId = ""
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var streetAndNumberTextField: HoshiTextField!
    @IBOutlet weak var suburbTextField: HoshiTextField!
    @IBOutlet weak var zipCodeTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.streetAndNumberTextField.delegate = self
        self.suburbTextField.delegate = self
        self.zipCodeTextField.delegate = self
        self.countryButton.setTitle("México", for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.getStates()
    }
    
    func setupDropDownStyle() {
        let appearance = DropDown.appearance()
        appearance.cornerRadius = 4
        appearance.cellHeight = 40
    }
    
    func setupStatesDropDown(states: [AddressState]) {
        stateDropDown.anchorView = self.stateButton
        var stateNameArray = [String]()
        for state in states {
            stateNameArray.append(state.name!)
        }
        stateDropDown.dataSource = stateNameArray
        stateDropDown.bottomOffset = CGPoint(x: 0, y: stateButton.bounds.height)
        stateDropDown.selectionAction = { [weak self] (index, item) in
            self?.stateButton.setTitle(item, for: .normal)
            self?.selectedStateId = states[index].id
            self?.rootParentVC.onboardingUser.onboardingShippingAddress.addressStateId = states[index].id
            self?.getCities(stateId: states[index].id)
        }
    }
    
    func setupCitiesDropDown(cities: [AddressCity]) {
        cityDropDown.anchorView = self.cityButton
        var cityNameArray = [String]()
        for city in cities {
            cityNameArray.append(city.name!)
        }
        cityDropDown.dataSource = cityNameArray
        cityDropDown.bottomOffset = CGPoint(x: 0, y: stateButton.bounds.height)
        cityDropDown.selectionAction = { [weak self] (index, item) in
            self?.cityButton.setTitle(item, for: .normal)
            self?.rootParentVC.onboardingUser.onboardingShippingAddress.addressCityId = cities[index].id
            self?.selectedCityId = cities[index].id
        }
    }
    
    @IBAction func tapStateButton(_ sender: Any) {
        self.stateDropDown.show()
    }
    
    func getStates() {
        sharedApiManager.getStates() { (states, result) in
            if let response = result {
                if(response.isSuccess()) {
                    self.setupStatesDropDown(states: states!)
                }
            }
        }
    }
    
    func getCities(stateId: String) {
        sharedApiManager.getCities(stateId: stateId) { (cities, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.setupCitiesDropDown(cities: cities!)
                }
            }
        }
    }
    
    @IBAction func tapCityButton(_ sender: Any) {
        self.cityDropDown.show()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height)/2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}
extension AddressOnboardingViewController: UITextFieldDelegate {
    func hideKeyBoard(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var bool = false
        
        if (streetAndNumberTextField == textField) {
            hideKeyBoard(textField: streetAndNumberTextField)
            bool = true
        } else if (suburbTextField == textField) {
            hideKeyBoard(textField: suburbTextField)
            bool = true
        } else if (zipCodeTextField == textField) {
            hideKeyBoard(textField: zipCodeTextField)
            bool = true
        }
        
        return bool
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var shouldAbortNextButton = false
        
        if (self.streetAndNumberTextField.text == "") {
            shouldAbortNextButton = true
        }
        
        if (self.suburbTextField.text == "") {
            shouldAbortNextButton = true
        }
        
        if (self.zipCodeTextField.text == "") {
            shouldAbortNextButton = true
        }
        
        if (shouldAbortNextButton == true) {
            return
        }
        
        self.rootParentVC.onboardingUser.onboardingShippingAddress.streetAndNumber = self.streetAndNumberTextField.text!
        
        self.rootParentVC.onboardingUser.onboardingShippingAddress.suburb = self.suburbTextField.text!
        
        self.rootParentVC.onboardingUser.onboardingShippingAddress.zipCode = self.zipCodeTextField.text!
    }
    
    
}
