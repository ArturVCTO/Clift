//
//  RecoverPasswordViewController.swift
//  clift_iOS
//
//  Created by Juan Pablo Ramos on 05/11/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit
import TextFieldEffects

class RecoverPasswordViewController: UIViewController {
	
	@IBOutlet var emailTextField: HoshiTextField! {
		didSet {
			emailTextField.delegate = self
		}
	}
	@IBOutlet var errorLabel: UILabel! {
		didSet {
			errorLabel.isHidden = true
		}
	}
	@IBOutlet var sendButton: customButton!
	@IBOutlet var returnButton: UIButton!
	
	private enum ErrorLabelErrors: String {
		case backend = "Ocurrió algún error. Porfavor inténtalo de nuevo."
		case email = "Por favor ingresa un email válido"
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setDesignChanges()
		let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnClickOutside))
		view.addGestureRecognizer(tap)
	}
	
	private func setDesignChanges() {
		let buttonImage = returnButton.imageView?.image
		returnButton.imageView?.image = buttonImage?.maskWith(color: UIColor(named: "PrimaryBlue"))
	}
	
	private func setError(type error: ErrorLabelErrors?) {
		guard let error = error else {
			errorLabel.isHidden = true
			emailTextField.borderActiveColor = UIColor(named: "TextfieldGreen")
			return
		}
		errorLabel.isHidden = false
		errorLabel.text = error.rawValue
		emailTextField.borderActiveColor = UIColor(named: "TextfieldYellow")
	}
	
	@objc func hideKeyboardOnClickOutside(){
		view.endEditing(true)
	}
	
	// MARK: - IBActions
	@IBAction func sendButtonPressed(_ sender: Any) {
		guard emailTextField.text!.isValidEmail() else {
			setError(type: .email)
			return
		}
		
		sharedApiManager.recoverPassword(email: emailTextField.text!) { (emptyObjectWithErrors, response) in
			guard let result = response, !result.isError() else {
				return self.setError(type: .backend)
			}
			self.setError(type: .none)
			let passwordEmailSentVC = UIStoryboard(name: "Session", bundle: nil).instantiateViewController(withIdentifier: "passwordEmailSentVC") as! PasswordEmailSentViewController
			passwordEmailSentVC.email = self.emailTextField.text!
			self.present(passwordEmailSentVC, animated: true, completion: nil)
		}
	}
	
	@IBAction func returnButtonPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - UITextFieldDelegate
extension RecoverPasswordViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		var bool = false
		if textField == emailTextField {
			emailTextField.resignFirstResponder()
			bool = true
		}
		return bool
	}
}
