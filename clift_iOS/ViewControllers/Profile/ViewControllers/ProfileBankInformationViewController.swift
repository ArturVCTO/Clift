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
    @IBOutlet weak var bankNameButton: UIButton!
    @IBOutlet var accountTextField: UITextField!
    
    var currentBankAccount = BankAccount()
    var bankDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
        loadDropDownInfo(banks: ["uno","dos","tres"])
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
    
    func loadDropDownInfo(banks: [String]) {
        var dataSourceDropdown = [String]()
        bankDropDown.anchorView = bankNameButton
        
        for bank in banks {
            dataSourceDropdown.append(bank)
        }
        bankDropDown.dataSource = dataSourceDropdown
        bankDropDown.bottomOffset = CGPoint(x: 0, y: bankNameButton.bounds.height)
        
        bankDropDown.selectionAction = { [weak self] (index, item) in
            self!.bankNameButton.setTitle(item, for: .normal)
            //self?.thankMessage.email = gifters[index]
        }
    }
    
    @IBAction func changeBankPressed(_ sender: UIButton) {
        bankDropDown.show()
    }
    @IBAction func editButtonPressed(_ sender: customButton) {
        print("change")
    }
}
