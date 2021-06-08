//
//  PasswordEmailSentViewController.swift
//  clift_iOS
//
//  Created by Juan Pablo Ramos on 05/11/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

class PasswordEmailSentViewController: UIViewController {
	
	@IBOutlet weak var loginButton: customButton!
	@IBOutlet weak var resendEmailButton: customButton!
	
	var email: String?
	private var canResend = true
	
	private enum ResendButtonState: String {
		case resend = "Reenviar solicitud"
		case resent = " Se reenvió tu solicitud."
		case error = "Hubo un error. Intenta más tarde."
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setResendButton(for: .resend)
	}
	
	private func setResendButton(for state: ResendButtonState) {
		resendEmailButton.setTitle(state.rawValue, for: .normal)
		
		switch state {
		case .resend:
			resendEmailButton.backgroundColor = .clear
			resendEmailButton.setImage(nil, for: .normal)
			resendEmailButton.setTitleColor(UIColor(named: "PrimaryBlue"), for: .normal)
			
		case .resent:
			resendEmailButton.backgroundColor = UIColor(named: "SuccessGreen")
			resendEmailButton.setImage(UIImage(named: "addedcheckmark"), for: .normal)
			resendEmailButton.setTitleColor(.white, for: .normal)
			resendEmailButton.tintColor = .white
			
		case .error:
			resendEmailButton.backgroundColor = UIColor(named: "TextfieldYellow")
			resendEmailButton.setImage(nil, for: .normal)
			resendEmailButton.setTitleColor(.white, for: .normal)
		}
	}
	
	// MARK: - IBActions
	@IBAction func loginButtonPressed(_ sender: Any) {
		view.window!.rootViewController?.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func resendEmailButtonPressed(_ sender: Any) {
		if canResend {
			canResend = false
			resendEmailButton.isUserInteractionEnabled = false
			guard let email = email else {
				setResendButton(for: .error)
				return
			}
			
			sharedApiManager.recoverPassword(email: email) { (_, response) in
				guard let result = response, !result.isError() else {
					self.setResendButton(for: .error)
					return
				}
				self.setResendButton(for: .resent)
			}
		}
	}
}
