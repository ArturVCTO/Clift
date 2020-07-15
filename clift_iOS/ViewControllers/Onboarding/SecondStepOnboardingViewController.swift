//
//  SecondStepOnboardingViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/8/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects

class SecondStepOnboardingViewController: UIViewController,UITextFieldDelegate {
    
    var rootParentVC: RootOnboardViewController!
    @IBOutlet weak var spouseTextField: HoshiTextField!
    @IBOutlet weak var spouseLastNameTextField: HoshiTextField!
    
    @IBOutlet weak var spouseEmailTextField: HoshiTextField!
    
    @IBOutlet weak var spouseCellPhoneTextField: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spouseTextField.delegate = self
        self.spouseLastNameTextField.delegate = self
        self.spouseEmailTextField.delegate = self
        self.spouseCellPhoneTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.initialSettings()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if spouseTextField.isEditing {
            return
        } else {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= (keyboardSize.height)/2
                }
            }
        }
    }

        @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.nextButtonValidator()
        self.updateCurrentPageSelector()
    }
    
    func initialSettings() {
        self.rootParentVC.previousButton.isEnabled = true
        self.rootParentVC.previousButton.alpha = 1.0
        self.rootParentVC.nextButton.isEnabled = false
        self.rootParentVC.nextButton.alpha = 0.5
    }
    
    func nextButtonValidator() {
        if (spouseTextField.text?.isEmpty == false && spouseLastNameTextField.text?.isEmpty == false && spouseEmailTextField.text?.isEmpty == false) {
            self.rootParentVC.nextButton.isEnabled = true
            self.rootParentVC.nextButton.alpha = 1.0
        } else {
            self.rootParentVC.nextButton.isEnabled = false
            self.rootParentVC.nextButton.alpha = 0.5
        }
    }
    
    func updateCurrentPageSelector() {
        self.rootParentVC.pageControlSelector.currentPage = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var bool = false
        
        if (spouseTextField == textField) {
            hideKeyBoard(textField: spouseTextField)
            bool = true
        }
        else if (spouseLastNameTextField == textField) {
            hideKeyBoard(textField: spouseLastNameTextField)
            bool = true
        }
        else if (spouseEmailTextField == textField) {
            hideKeyBoard(textField: spouseEmailTextField)
            bool = true
        }
        else if (spouseCellPhoneTextField == textField) {
            hideKeyBoard(textField: spouseCellPhoneTextField)
            bool = true
        }
        
        return bool
    }
    
    func hideKeyBoard(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var shouldAbortNextButton = false
        
        if (self.spouseTextField.text == "") {
            shouldAbortNextButton = true
        }
        
        
        if (self.spouseLastNameTextField.text == "") {
            shouldAbortNextButton = true
        }
        
        
        if (self.spouseEmailTextField.text == "" && !(self.spouseEmailTextField.text?.isValidEmail())!) {
            shouldAbortNextButton = true
        }
        
        if (shouldAbortNextButton) {
            return
        }
        
        self.rootParentVC.onboardingUser.spouse.name = self.spouseTextField.text!
        self.rootParentVC.onboardingUser.spouse.lastName = self.spouseLastNameTextField.text!
        self.rootParentVC.onboardingUser.spouse.email = self.spouseEmailTextField.text!
        self.rootParentVC.onboardingUser.spouse.cellPhoneNumber = self.spouseCellPhoneTextField.text!
        
        nextButtonValidator()
        
    }
}

