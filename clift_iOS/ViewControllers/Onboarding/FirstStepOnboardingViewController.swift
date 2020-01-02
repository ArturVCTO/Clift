//
//  FirstStepOnboarding.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/8/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import UITextField_Shake

class FirstStepOnboardingViewController: UIViewController,UITextFieldDelegate {
    
    var rootParentVC: RootOnboardViewController!
    
    @IBOutlet weak var nameTextField: IsaoTextField!
    @IBOutlet weak var lastNameTextField: IsaoTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.initialSettings()
        self.updateCurrentPageSelector()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateCurrentPageSelector()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.rootParentVC.nextButton.isEnabled = false
        self.rootParentVC.nextButton.alpha = 0.5
        self.rootParentVC.previousButton.isEnabled = true
    }
    
    func initialSettings() {
        self.rootParentVC.nextButton.isEnabled = false
        self.rootParentVC.nextButton.alpha = 0.5
        self.rootParentVC.previousButton.isEnabled = false
        self.rootParentVC.previousButton.alpha = 0.5
    }
    
    
    func updateCurrentPageSelector() {
        self.rootParentVC.pageControlSelector.currentPage = 0
    }
    
    func hideKeyBoard(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var bool = false
        
        if (nameTextField == textField) {
            hideKeyBoard(textField: nameTextField)
            bool = true
        } else if (lastNameTextField == textField) {
            hideKeyBoard(textField: lastNameTextField)
            bool = true
        }
        
        return bool
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var shouldAbortNextButton = false
        
        if (self.nameTextField.text == "") {
            shouldAbortNextButton = true
        }
        
        if (self.lastNameTextField.text == "") {
            shouldAbortNextButton = true
        }
        
        if (shouldAbortNextButton) {
            return
        }
        
        self.rootParentVC.onboardingUser.name = self.nameTextField.text!
        self.rootParentVC.onboardingUser.lastName = self.lastNameTextField.text!
        
        self.rootParentVC.nextButton.isEnabled = true
        self.rootParentVC.nextButton.alpha = 1.0
        print(self.rootParentVC.onboardingUser)
    }
}
