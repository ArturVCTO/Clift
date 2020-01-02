//
//  EditProfileViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/22/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import Moya
import TextFieldEffects

class EditProfileViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: IsaoTextField!
    @IBOutlet weak var lastNameTextField: IsaoTextField!
    @IBOutlet weak var cellphoneTextField: IsaoTextField!
    var profile = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.cellphoneTextField.delegate = self
        self.getProfile()
    }
    
    func getProfile() {
        sharedApiManager.getProfile() { (profile, result) in
            if let response = result {
                if response.isSuccess() {
                    self.loadInitialProfile(profile: profile!)
                }
            }
        }
    }
    
    
    func loadInitialProfile(profile: User) {
        self.firstNameTextField.text = profile.name
        self.profile.name = profile.name
        self.lastNameTextField.text = profile.lastName
        self.profile.lastName = profile.lastName
        self.cellphoneTextField.text = profile.cellPhoneNumber
        self.profile.cellPhoneNumber = profile.cellPhoneNumber
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateProfile() {
        var multipartFormData: [MultipartFormData] = self.getProfileMultipart()
        
        if !(multipartFormData.isEmpty) {
            sharedApiManager.updateProfile(profile: multipartFormData) { (emptyObjectWithErrors, result) in
                if let response = result {
                    if (response.isSuccess()) {
                        print("Updated!")
                    }
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.firstNameTextField:
            self.profile.name = self.firstNameTextField.text!
        case self.lastNameTextField:
            self.profile.lastName = self.lastNameTextField.text!
        case self.cellphoneTextField:
            self.profile.cellPhoneNumber = self.cellphoneTextField.text!
        default:
            break
        }
    }
    
    func getProfileMultipart() -> [MultipartFormData] {
        var multipartFormData: [MultipartFormData] = []
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.profile.name.description.data(using: String.Encoding.utf8)! ))),name: "profile[name]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.profile.lastName.description.data(using: String.Encoding.utf8)! ))),name: "profile[last_name]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.profile.cellPhoneNumber.description.data(using: String.Encoding.utf8)! ))),name: "profile[cell_phone_number]"))
        
        if (self.profile.image != nil) {
            multipartFormData.append(MultipartFormData(provider: .data((self.profile.image?.jpegData(compressionQuality: 1.0))!), name: "profile[image]", fileName: "image.jpeg", mimeType: "image/jpeg"))
        }
        
        return multipartFormData
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.updateProfile()
    }
    
}
