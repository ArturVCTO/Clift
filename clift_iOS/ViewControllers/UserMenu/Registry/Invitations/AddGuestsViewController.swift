//
//  AddGuestsViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 12/2/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import TextFieldEffects
import GSMessages

protocol updateNewGuestDelegate{
    func updateNewGuest()
}

class AddGuestsViewController: UIViewController{
    
    var delegate:updateNewGuestDelegate!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var guestNameTextField: HoshiTextField!
    @IBOutlet weak var guestEmailTextField: HoshiTextField!
    @IBOutlet weak var guestTelephoneTextField: HoshiTextField!
    var vc: GuestListViewController!
    var newGuest = EventGuest()
    var currentEvent = Event()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.guestNameTextField.delegate = self
        self.guestEmailTextField.delegate = self
        self.guestTelephoneTextField.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        NotificationCenter.default.addObserver(self,
               selector: #selector(receiveToggleAuthUINotification(_:)),
               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
               object: nil)

           statusText.text = "Initialized Swift app..."
           toggleAuthUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnClickOutside))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func toggleAuthUI() {
        if let _ = GIDSignIn.sharedInstance()?.currentUser?.authentication {
          // Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
            disconnectButton.isHidden = false
        } else {
          signInButton.isHidden = false
            signOutButton.isHidden = true
            disconnectButton.isHidden = true
          statusText.text = "Google Sign in\niOS Demo"
        }
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String: String] else { return }
                self.statusText.text = userInfo["statusText"]!
            }
        }
    }
    
    @IBAction func addGuestButtonTapped(_ sender: Any) {
        self.addGuest(event: self.currentEvent, guest: self.newGuest)
    }
    
    func addGuest(event: Event, guest: EventGuest) {
        sharedApiManager.addGuest(event: event, guest: guest) { (emptyObject, result) in
            if let response = result {
                if response.isSuccess() {
                    self.parent?.showMessage(NSLocalizedString("El invitado ha sido registrado", comment: "Add success"),type: .success)
                    self.delegate?.updateNewGuest()
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        }
    }
    
    @IBAction func hideKeyboardOnClickOutside(){
        view.endEditing(true)
    }
    
    
    
    
    @IBAction func didTapDisconnect(_ sender: Any) {
        GIDSignIn.sharedInstance()?.disconnect()
        
        statusText.text = "Disconnecting."
    }
    
    @IBAction func didTapSignOut(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        
        statusText.text = "Signed out."
        toggleAuthUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
        name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil)
    }
}
extension AddGuestsViewController: UITextFieldDelegate {
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == guestNameTextField {
          self.newGuest.name = self.guestNameTextField.text!
        }
        
        if textField == guestEmailTextField {
            self.newGuest.email = self.guestEmailTextField.text!
        }
        
      if textField == guestTelephoneTextField {
            self.newGuest.cellPhoneNumber = guestTelephoneTextField.text!
        }
      
    }
}
