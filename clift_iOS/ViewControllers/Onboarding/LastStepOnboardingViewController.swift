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
    @IBOutlet weak var cellPhoneTextField: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userEmailTextField.delegate = self
        self.userPasswordTextField.delegate = self
        self.cellPhoneTextField.delegate = self
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if (self.userEmailTextField.isEditing) {
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
        
        if (self.cellPhoneTextField.text == "") {
            shouldAbortNextButton = false
        }
        
    
        if (shouldAbortNextButton) {
            return
        }
        
        self.rootParentVC.onboardingUser.email = self.userEmailTextField.text!
        self.rootParentVC.onboardingUser.password = self.userPasswordTextField.text!
        self.rootParentVC.onboardingUser.cellPhoneNumber = self.cellPhoneTextField.text!
        self.rootParentVC.onboardingUser.onboardingShippingAddress.cellPhoneNumber = self.cellPhoneTextField.text!
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
