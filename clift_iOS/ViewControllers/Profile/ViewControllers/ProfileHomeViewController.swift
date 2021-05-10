//
//  ProfileHomeViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 06/05/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class ProfileHomeViewController: UIViewController {
    
    @IBOutlet weak var bannerImageViewButton: UIButton!
    @IBOutlet weak var profilePictureImageView: customImageView!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var profileAddressTextField: UITextField!
    @IBOutlet weak var profileBankAccountTextField: UITextField!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
    }
    
    func setNavBar() {
        let titleLabel = UILabel()
        titleLabel.text = "EDITAR MESA"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Mihan-Regular", size: 16.0)!
        titleLabel.addCharactersSpacing(5)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func profilePictureButtonPressed(_ sender: Any) {
        //
    }
    
    
    @IBAction func bannerButtonPressed(_ sender: Any) {
        //
    }
    
    @IBAction func dateButtonPressed(_ sender: Any) {
        // Calendar
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        // Save
    }
    
}
