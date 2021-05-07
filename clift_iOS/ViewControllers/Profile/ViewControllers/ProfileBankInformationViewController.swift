//
//  ProfileBankInformationViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 06/05/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class ProfileBankInformationViewController: UIViewController {

    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var bankNameTextField: UITextField!
    @IBOutlet var accountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
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
    
    @IBAction func editButtonPressed(_ sender: customButton) {
        print("edit")
    }
}
