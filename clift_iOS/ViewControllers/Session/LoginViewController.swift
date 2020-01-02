//
//  LoginViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/16/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import RealmSwift
import GSMessages

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailSignInTextField: HoshiTextField!
    @IBOutlet weak var passwordSignInTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailSignInTextField.delegate = self
        self.passwordSignInTextField.delegate = self
    }
    
    func postLoginSession() {
        sharedApiManager.login(email: self.emailSignInTextField.text!, password: self.passwordSignInTextField.text!) { (session, result) in
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
    
    func hidePasswordKeyBoard() {
        passwordSignInTextField.resignFirstResponder()
    }
    
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
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.postLoginSession()
    }
    
    
    @IBAction func backToMainMenu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
