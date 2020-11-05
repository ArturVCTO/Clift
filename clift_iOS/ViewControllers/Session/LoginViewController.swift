//
//  LoginViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/16/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import UIKit
import TextFieldEffects
import RealmSwift
import GSMessages

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailSignInTextField: HoshiTextField!
    @IBOutlet weak var passwordSignInTextField: HoshiTextField!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		emailSignInTextField.delegate = self
		passwordSignInTextField.delegate = self
		let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnClickOutside))
		view.addGestureRecognizer(tap)
	}
    
    func postLoginSession() {
        sharedApiManager.login(email: emailSignInTextField.text!, password: passwordSignInTextField.text!) { (session, result) in
            if let response = result {
                if response.isSuccess() {
                    if (session != nil && session?.token != "") {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.add(session!)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.userHasSuccesfullySignedIn()
                        }
                    }
                } else if (response.isClientError() && session != nil && !(session?.errors.isEmpty)!) {
                    self.showMessage(NSLocalizedString("\(session!.errors.first!)", comment: "Login Error"),type: .error)
                }
            }
        }
    }
    
    func hideKeyBoardForEmail() {
        emailSignInTextField.resignFirstResponder()
    }
    
    @IBAction func hideKeyboardOnClickOutside(){
        view.endEditing(true)
    }
    
    func hidePasswordKeyBoard() {
        passwordSignInTextField.resignFirstResponder()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        postLoginSession()
    }
    
    @IBAction func backToMainMenu(_ sender: Any) {
		let onboardingEventTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onboardingEventTypeVC") as! OnboardingEventTypeViewController
		present(onboardingEventTypeVC, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		var bool = false
		if textField == emailSignInTextField {
			hideKeyBoardForEmail()
			bool = true
		} else if textField == passwordSignInTextField {
			hidePasswordKeyBoard()
			bool = true
		}
		
		return bool
	}
}
