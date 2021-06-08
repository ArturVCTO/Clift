//
//  BankAccountFormViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/6/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import GSMessages
import DropDown

class BankAccountFormViewController: UIViewController {
    
    @IBOutlet weak var accountHolderNameTextField: HoshiTextField!
    @IBOutlet weak var selectBankButton: UIButton!
    @IBOutlet weak var bankAccountNumberTextField: HoshiTextField!
    var bankAccount = BankAccount()
    var bankDropDown = DropDown()
    
    override func viewWillLayoutSubviews() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadBanksFromJSON()
        self.bankAccountNumberTextField.delegate = self
        self.accountHolderNameTextField.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func associateAccountButtonTapped(_ sender: Any) {
        self.createBankAccount(bankAccount: self.bankAccount)
    }
    
    func loadBanksFromJSON() {
        if let path = Bundle.main.path(forResource: "clabe", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let banks = jsonResult["banks"] as? [AnyObject] {
                    self.loadBankDropDown(banks: banks)
                  }
              } catch {
                   self.showMessage(NSLocalizedString("No fue posible cargar los bancos.", comment: "Error"),type: .error)
              }
        }
    }
    
    func loadBankDropDown(banks: [AnyObject]) {
        var dataSourceDropDown = [String]()
               bankDropDown.anchorView = self.selectBankButton
               
               for bank in banks {
                   dataSourceDropDown.append("\(bank["marca"] as! String)")
               }
               bankDropDown.dataSource = dataSourceDropDown
               bankDropDown.bottomOffset = CGPoint(x: 0, y: selectBankButton.bounds.height)
               
               bankDropDown.selectionAction = { [weak self] (index, item) in
                   self!.selectBankButton.setTitle(item, for: .normal)
                self!.bankAccount.bank = banks[index]["marca"] as! String
               }
    }
    
    func createBankAccount(bankAccount: BankAccount) {
        sharedApiManager.createBankAccount(bankAccount: bankAccount) { (emptyObject, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.navigationController?.showMessage(NSLocalizedString("Cuenta de banco ha sido agregada.", comment: "Success"),type: .success)
                } else if (response.isClientError()) {
                    self.showMessage(NSLocalizedString("\(emptyObject!.errors.first ?? "Revise los campos.")", comment: "Client Error"), type: .error)
                } else if (response.isServerError()) {
                    self.showMessage(NSLocalizedString("Error de servidor", comment: "Server Error"), type: .error)
                }
            }
        }
    }
    
    @IBAction func bankButtonTapped(_ sender: Any) {
        self.bankDropDown.show()
    }
}
extension BankAccountFormViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.accountHolderNameTextField:
            self.bankAccount.owner = self.accountHolderNameTextField.text!
        case self.bankAccountNumberTextField:
            self.bankAccount.account = self.bankAccountNumberTextField.text!
        default:
            return
        }
    }
    
    func hideKeyboard(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard(textField: textField)
        
        return true
    }
}
