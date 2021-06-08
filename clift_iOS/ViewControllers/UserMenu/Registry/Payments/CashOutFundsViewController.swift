//
//  CashOutFundsViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/27/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import DropDown

class CashOutFundsViewController: UIViewController {
    @IBOutlet weak var cashOutAmountTextField: HoshiTextField!
    var bankDropDown = DropDown()
    var chosenBankAccount: BankAccount? = nil
    var bankAccounts: [BankAccount] = []
    @IBOutlet weak var bankAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cashOutAmountTextField.delegate = self
        self.getBankAccounts()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getBankAccounts() {
        sharedApiManager.getBankAccounts() { (bankAccounts, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.bankAccounts = bankAccounts!
                    self.loadDropDownOptions(bankAccounts: bankAccounts!)
                } else if (response.isClientError()) {
                    self.showMessage("\(bankAccounts?.first?.errors.first ?? "Hubo un error al cargar las cuentas asociadas. Intente de nuevo más tarde.")", type: .error)
                }
            }
        }
    }
    
    func loadDropDownOptions(bankAccounts: [BankAccount]) {
        var dataSourceDropDown = [String]()
        bankDropDown.anchorView = self.bankAccountButton
        
        for bankAccount in bankAccounts {
            dataSourceDropDown.append("\(bankAccount.account)")
        }
        bankDropDown.dataSource = dataSourceDropDown
        bankDropDown.bottomOffset = CGPoint(x: 0, y: bankAccountButton.bounds.height)
        
        bankDropDown.selectionAction = { [weak self] (index, item) in
            self!.bankAccountButton.setTitle(item, for: .normal)
            self!.chosenBankAccount = bankAccounts[index]
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        var cashAmountValidation = false
        var cashAmountOnlyDigits = false
        var bankAccountValidation = false
        
        if cashOutAmountTextField.text != "" {
            cashAmountValidation = true
        }
        
        if chosenBankAccount != nil {
            bankAccountValidation = true
        }
        
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: cashOutAmountTextField.text!)) {
            cashAmountOnlyDigits = true
        }
        
        if bankAccountValidation == true && cashAmountValidation == true && cashAmountOnlyDigits == true {
              if #available(iOS 13.0, *) {
                      let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "cashOutConfirmationVC") as! CashOutConfirmationViewController
                      self.navigationController?.pushViewController(vc, animated: true)
                                 
                               } else {
                                 // Fallback on earlier versions
                      let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cashOutConfirmationVC") as! CashOutConfirmationViewController
                      self.navigationController?.pushViewController(vc, animated: true)
                  }
        } else {
            if bankAccountValidation == false {
                self.showMessage("Banco no valido.", type: .error)
            } else if cashAmountValidation == false {
                self.showMessage("Monto a retirar no valido.", type: .error)
            } else if cashAmountOnlyDigits == false{
                self.showMessage("Solo digitos aceptados en la transacción.", type: .error)
            } else {
                self.showMessage("Hubo un error validando la transacción, intente de nuevo más tarde.", type: .error)
            }
        }
    }
    
    @IBAction func bankDropDownTapped(_ sender: Any) {
        self.bankDropDown.show()
    }
}
extension CashOutFundsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
