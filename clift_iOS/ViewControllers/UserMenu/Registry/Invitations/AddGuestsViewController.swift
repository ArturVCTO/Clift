//
//  AddGuestsViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 12/2/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import GSMessages

protocol updateNewGuestDelegate{
    func updateNewGuest()
}

class AddGuestsViewController: UIViewController{
    
    var delegate:updateNewGuestDelegate!
    
    @IBOutlet weak var guestNameTextField: HoshiTextField!
    @IBOutlet weak var guestEmailTextField: HoshiTextField!
    @IBOutlet weak var guestTelephoneTextField: HoshiTextField!
    @IBOutlet weak var guestHasPlusOneSwitch: UISwitch!
    @IBOutlet weak var guestPlusOneNameTextField: HoshiTextField!
    @IBOutlet weak var guestAdressTextField: HoshiTextField!
    private var currentTextField: UITextField!
    var vc: GuestListViewController!
    var newGuest = EventGuest()
    var currentEvent = Event()
    var yViewOrigin : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.guestNameTextField.delegate = self
        self.guestEmailTextField.delegate = self
        self.guestTelephoneTextField.delegate = self
        self.guestPlusOneNameTextField.delegate = self
        self.guestAdressTextField.delegate = self
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnClickOutside))
        view.addGestureRecognizer(tap)
        self.guestPlusOneNameTextField.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        yViewOrigin = self.view.frame.origin.y
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
       
    @IBAction func addGuestButtonTapped(_ sender: Any) {
        if let currentTextField = currentTextField{
            currentTextField.resignFirstResponder()
        }
        if  newGuest.name == "" || newGuest.email == "" || newGuest.cellPhoneNumber == "" || (newGuest.has_plus_one && newGuest.companion_name == "") || newGuest.address == ""{
            
            self.showMessage(NSLocalizedString("Favor de llenar todos los campos", comment: "Guest Registry Error"),type: .error)
            return
        }
        if(!guestEmailTextField.text!.isValidEmail()){
            self.showMessage(NSLocalizedString("Correo electrónico inválido", comment: "Invalid Guest Email"),type: .error)
            return
        }
        if(!guestTelephoneTextField.text!.isValidPhone()){
            self.showMessage(NSLocalizedString("Número telefónico inválido", comment: "Invalid Guest Phone"),type: .error)
            return
        }
        self.addGuest(event: self.currentEvent, guest: self.newGuest)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if (self.guestNameTextField.isEditing || self.guestEmailTextField.isEditing || self.guestTelephoneTextField.isEditing) {
            return
        } else {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == self.yViewOrigin {
                    self.view.frame.origin.y -= (keyboardSize.height)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != self.yViewOrigin {
            self.view.frame.origin.y = self.yViewOrigin
        }
    }
    
    @IBAction func plusOneSwitchOnChange(_ sender: UISwitch) {
        if sender.isOn
        {
            self.guestPlusOneNameTextField.isHidden = false
            self.newGuest.has_plus_one = true
        }
        else{
            self.guestPlusOneNameTextField.isHidden = true
            self.newGuest.has_plus_one = false
            self.newGuest.companion_name = ""
        }
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
    
    
}
extension AddGuestsViewController: UITextFieldDelegate {
   
    func textfieldShouldReturn(textField: UITextField)->Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == guestNameTextField {
          self.newGuest.name = self.guestNameTextField.text!
            self.newGuest.isConfirmed = "invitation_not_sent"
        }
        if textField == guestEmailTextField {
            self.newGuest.email = self.guestEmailTextField.text!
        }
        if textField == guestTelephoneTextField {
            self.newGuest.cellPhoneNumber = self.guestTelephoneTextField.text!
        }
        if textField == guestPlusOneNameTextField {
            self.newGuest.companion_name = self.guestPlusOneNameTextField.text!
        }
        if textField == guestAdressTextField {
            self.newGuest.address = self.guestAdressTextField.text!
        }
    }
}
