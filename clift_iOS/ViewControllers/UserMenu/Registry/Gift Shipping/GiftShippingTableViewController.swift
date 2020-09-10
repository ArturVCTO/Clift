//
//  GiftShippingTableViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/28/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import DropDown

class GiftShippingTableViewController: UITableViewController {
    var address: Address?
    @IBOutlet weak var cellphoneNumberTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var streetAndNumberTextField: HoshiTextField!
    @IBOutlet weak var districtTextField: HoshiTextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var countryButtonDropdown: UIButton!
    @IBOutlet weak var stateButtonDropdown: UIButton!
    @IBOutlet weak var cityButtonDropdown: UIButton!
    var yOrigin = CGFloat()
    var currentEvent = Event()
    var requestshippingEventProducts: [EventProduct] = []
    var eventProductIds: [String] = []
    
    override func viewDidAppear(_ animated: Bool) {
                self.yOrigin =  self.view.frame.origin.y
    }
    
    override func viewDidLoad() {
        self.loadAddress()
        self.getEventProductIds(eventProducts: requestshippingEventProducts)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnClickOutside))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func hideKeyboardOnClickOutside(){
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == self.yOrigin {
                self.view.frame.origin.y -= (keyboardSize.height)
            }
            
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != self.yOrigin {
            self.view.frame.origin.y = self.yOrigin
        }
    }
    
    func getEventProductIds(eventProducts: [EventProduct]) {
        for eventProduct in eventProducts {
            self.eventProductIds.append(eventProduct.id)
        }
    }
    
    func loadAddress() {
        if address != nil {
            self.cellphoneNumberTextField.text = self.address?.cellPhoneNumber
            self.emailTextField.text = self.address?.email
            self.lastNameTextField.text = self.address?.lastName
            self.nameTextField.text = self.address?.firstName
            self.streetAndNumberTextField.text = self.address?.streetAndNumber
            self.districtTextField.text = self.address?.suburb
            self.zipcodeTextField.text = self.address?.zipCode
            
            self.cityButtonDropdown.setTitle(self.address?.city.name, for: .normal)
            self.stateButtonDropdown.setTitle(self.address?.state.name, for: .normal)
            self.countryButtonDropdown.setTitle(self.address?.country.name, for: .normal)
        }
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Solicitud de envio.", message: "¿Desea continuar?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Sí", comment: "Default action"), style: .default, handler: { _ in
            self.sendShippingRequest()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func segueToGiftShippingConfirmation() {
         if #available(iOS 13.0, *) {
              let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "giftShippingConfirmationVC") as! GiftShippingConfirmationViewController
              self.navigationController?.pushViewController(vc, animated: true)
          } else {
            // Fallback on earlier versions
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "giftShippingConfirmationVC") as! GiftShippingConfirmationViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func sendShippingRequest() {
        sharedApiManager.requestGifts(event: self.currentEvent, ids: self.eventProductIds) { (emptyObject, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.segueToGiftShippingConfirmation()
                } else if (response.isClientError()) {
                    self.showMessage("\(emptyObject?.errors.first)", type: .error)
                } else {
                    self.showMessage("Error de servidor, intente de nuevo más tarde.", type: .error)
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
