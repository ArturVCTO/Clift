//
//  FifthStepOnboardingViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/20/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects

class FifthStepOnboardingViewController: UIViewController, UITextFieldDelegate {
    
    var rootParentVC: RootOnboardViewController!
    @IBOutlet weak var eventNameTextField: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventNameTextField.delegate = self
        self.updateCurrentPageSelector()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.eventNameTextField.delegate = self
        self.updateCurrentPageSelector()
        self.nextButtonValidator()
        print(self.rootParentVC.onboardingUser.toJSON())
    }
    
    func updateCurrentPageSelector() {
        self.rootParentVC.pageControlSelector.currentPage = 4
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var shouldAbortNextButton = false
        
        if (self.eventNameTextField.text == "") {
            shouldAbortNextButton = true
        }
        
        if (shouldAbortNextButton == true) {
            return
        }
        
        self.rootParentVC.onboardingUser.event.name = self.eventNameTextField.text!
        self.rootParentVC.nextButton.isEnabled = true
    }
    
    func hideKeyBoard() {
        self.eventNameTextField.resignFirstResponder()
    }
    
    func nextButtonValidator() {
        if (eventNameTextField.text?.isEmpty == false) {
            self.rootParentVC.nextButton.isEnabled = true
            self.rootParentVC.nextButton.alpha = 1.0
        } else {
            self.rootParentVC.nextButton.isEnabled = false
            self.rootParentVC.nextButton.alpha = 0.5
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyBoard()
        nextButtonValidator()
        
        return true
    }
}


