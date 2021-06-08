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
import GSMessages

class EditProfileViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var profileImageView: customImageView!
    @IBOutlet weak var firstNameTextField: IsaoTextField!
    @IBOutlet weak var lastNameTextField: IsaoTextField!
    @IBOutlet weak var cellphoneTextField: IsaoTextField!
    var profile = User()
    var profileImagePicker: UIImagePickerController!
    
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
    
    func hideKeyBoard(textfield: UITextField) {
        textfield.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var bool = false
        
        switch textField {
        case firstNameTextField:
            hideKeyBoard(textfield: firstNameTextField)
            bool = true
        case lastNameTextField:
            hideKeyBoard(textfield: lastNameTextField)
            bool = true
        case cellphoneTextField:
            hideKeyBoard(textfield: cellphoneTextField)
            bool = true
        default:
            break
        }
        
        return bool
    }
    
    func loadInitialProfile(profile: User) {
        self.firstNameTextField.text = profile.name
        self.profile.name = profile.name
        self.lastNameTextField.text = profile.lastName
        self.profile.lastName = profile.lastName
        self.cellphoneTextField.text = profile.cellPhoneNumber
        self.profile.cellPhoneNumber = profile.cellPhoneNumber
        if let imageURL = URL(string:"\(profile.imageUrl)") {
            self.profileImageView.kf.setImage(with: imageURL)
        }
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
                        self.showMessage(NSLocalizedString("Perfil actualizado", comment: "Update success"),type: .success)
                    } else if (response.isClientError()) {
                        self.showMessage(NSLocalizedString("\(emptyObjectWithErrors!.errors.first!)", comment: "Update Error"),type: .error)
                    } else  {
                        self.showMessage(NSLocalizedString("Error, intente de nuevo más tarde", comment: "Update Error"),type: .error)
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
    
    @IBAction func profileImageButtonTapped(_ sender: Any) {
        let sheet = UIAlertController(title: "Subir foto de perfil de usuario", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Cámara", style: .default, handler: { _ in
            self.openCameraPickerForProfile()
        })
        
        let galleryAction = UIAlertAction(title: "Galería de fotos", style: .default, handler: { _ in
            self.openGalleryPickerForProfile()
        })
        
        sheet.addAction(cameraAction)
        sheet.addAction(galleryAction)
        present(sheet,animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.updateProfile()
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func openCameraPickerForProfile() {
        profileImagePicker = UIImagePickerController()
        profileImagePicker.modalPresentationStyle = .overFullScreen
        profileImagePicker.delegate = self
        profileImagePicker.sourceType = .camera
        
        present(profileImagePicker,animated: true,completion: nil)
    }
    
    func openGalleryPickerForProfile() {
        profileImagePicker = UIImagePickerController()
        profileImagePicker.modalPresentationStyle = .overFullScreen
        profileImagePicker.delegate = self
        profileImagePicker.allowsEditing = true
        profileImagePicker.sourceType = .photoLibrary
        present(profileImagePicker,animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImagePicker.dismiss(animated: true, completion: nil)
        self.profile.image = info[.originalImage] as! UIImage?
        self.profileImageView.image = info[.originalImage] as! UIImage?
    }
}
