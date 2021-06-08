//
//  ProfileBankInformationViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 06/05/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit
import DropDown

class ProfileBankInformationViewController: UIViewController {

    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet weak var bankNameView: UIView!
    @IBOutlet weak var bankNameButton: UIButton!
    @IBOutlet var accountTextField: UITextField!
    
    var currentBankAccount = BankAccount()
    var bankDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
        setView()
        loadBanksFromJSON()
    }
    
    func setNavBar() {
        
        let titleLabel = UILabel()
        titleLabel.text = "TU CUENTA BANCARIA"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Mihan-Regular", size: 16.0)!
        titleLabel.addCharactersSpacing(5)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setView() {
        if currentBankAccount.id != "" {
            userNameTextField.text = currentBankAccount.owner
            bankNameButton.setTitle(currentBankAccount.bankName, for: .normal)
            accountTextField.text = hideAccountNumber(accountNumber: currentBankAccount.account)
        }
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
        bankDropDown.anchorView = bankNameButton
               
        for bank in banks {
            dataSourceDropDown.append("\(bank["marca"] as! String)")
        }
        
        bankDropDown.dataSource = dataSourceDropDown
        bankDropDown.bottomOffset = CGPoint(x: 0, y: bankNameButton.bounds.height)
               
        bankDropDown.selectionAction = { [weak self] (index, item) in
            self!.bankNameButton.setTitle(item, for: .normal)
            self!.currentBankAccount.bankName = banks[index]["marca"] as! String
            self!.currentBankAccount.bank = banks[index]["clabe"] as! String
        }
    }

    @IBAction func changeBankPressed(_ sender: UIButton) {
        bankDropDown.show()
    }
    @IBAction func editButtonPressed(_ sender: customButton) {
        currentBankAccount.owner = userNameTextField.text?.uppercased() ?? ""
        currentBankAccount.account = accountTextField.text ?? ""
        //If id is empty from previous VC is because there are not accounts associated with the profile
        if currentBankAccount.id == "" {
            createBankAccount(bankAccount: currentBankAccount)
        } else {
            updateBankAccount(bankAccount: currentBankAccount)
        }
    }
}

// MARK: Helpers Functions
extension ProfileBankInformationViewController {
    
    private func hideAccountNumber(accountNumber: String) -> String {
        var accountHidden = ""
        for _ in 1...accountNumber.count - 4 {
            accountHidden += "*"
        }
        accountHidden += accountNumber.suffix(4)
        return accountHidden
    }
}

// MARK: Extension REST APIs
extension ProfileBankInformationViewController {
    
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
    
    func updateBankAccount(bankAccount: BankAccount) {
        sharedApiManager.updateBankAccount(bankAccount: bankAccount) { (emptyObject, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.navigationController?.showMessage(NSLocalizedString("Cuenta de banco ha sido actualizada", comment: "Success"),type: .success)
                } else if (response.isClientError()) {
                    self.showMessage(NSLocalizedString("\(emptyObject!.errors.first ?? "Revise los campos.")", comment: "Client Error"), type: .error)
                } else if (response.isServerError()) {
                    self.showMessage(NSLocalizedString("Error de servidor", comment: "Server Error"), type: .error)
                }
            }
        }
    }
}
