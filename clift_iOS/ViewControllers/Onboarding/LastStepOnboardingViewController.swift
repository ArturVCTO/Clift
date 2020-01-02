//
//  FifthStepOnboardingViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/9/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects

class LastStepOnboardingViewController: UIViewController,UITextFieldDelegate {
    
    var rootParentVC: RootOnboardViewController!
    @IBOutlet weak var userEmailTextField: HoshiTextField!
    @IBOutlet weak var userPasswordTextField: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userEmailTextField.delegate = self
        self.userPasswordTextField.delegate = self
        print(self.rootParentVC.onboardingUser.toJSON())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.userEmailTextField.delegate = self
        self.userPasswordTextField.delegate = self
        self.updateCurrentPageSelector()
        self.startButtonAppears()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.startButtonDisappears()
    }
    
    func updateCurrentPageSelector() {
        self.rootParentVC.pageControlSelector.currentPage = 5
    }
    
    func startButtonAppears() {
        self.rootParentVC.nextButton.isHidden = true
        self.rootParentVC.startButton.isHidden = false
    }
    
    func startButtonDisappears() {
        self.rootParentVC.nextButton.isHidden = false
        self.rootParentVC.startButton.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var shouldAbortNextButton = false
        
        if (self.userEmailTextField.text == "" && (!self.userEmailTextField.text!.isValidEmail())) {
            shouldAbortNextButton = false
        }
        
        
        if (self.userPasswordTextField.text == "") {
            shouldAbortNextButton = false
        }
        
    
        if (shouldAbortNextButton) {
            return
        }
        
        self.rootParentVC.onboardingUser.email = self.userEmailTextField.text!
        self.rootParentVC.onboardingUser.password = self.userPasswordTextField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var bool = false
        
        if (textField == self.userEmailTextField) {
            hideKeyBoard(textField: userEmailTextField)
            bool = true
        } else if (textField == self.userPasswordTextField) {
            hideKeyBoard(textField: userPasswordTextField)
            bool = true
        }
        
        return bool
    }
    
    func hideKeyBoard(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
    
}
