//
//  ProfileHomeViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 06/05/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class ProfileHomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bannerPictureImageView: customImageView!
    @IBOutlet weak var profilePictureImageView: customImageView!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var profileAddressTextField: UITextField!
    @IBOutlet weak var profileBankAccountTextField: UITextField!
    @IBOutlet weak var profileEventDateButton: customButton!
    var profileImagePicker: UIImagePickerController?
    var bannerImagePicker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileNameTextField.delegate = self
        profileAddressTextField.delegate = self
        profileBankAccountTextField.delegate = self
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
        showImagePickerControllerActionSheet(.profilePicture)
    }
    
    
    @IBAction func bannerButtonPressed(_ sender: Any) {
        showImagePickerControllerActionSheet(.banner)
    }
    
    @IBAction func dateButtonPressed(_ sender: Any) {
        presentDatePicker()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        // Save
    }
    
    @objc func presentDatePicker() {
        let datePickerView = DatePickerView()
        datePickerView.delegate = self
        datePickerView.modalPresentationStyle = .custom
        datePickerView.transitioningDelegate = self
        
        self.present(datePickerView, animated: true, completion: nil)
    }
    
}

extension ProfileHomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    enum PickerName {
        case banner
        case profilePicture
    }
    
    func showImagePickerControllerActionSheet(_ picker: PickerName) {
        let alert = UIAlertController(title: "Elige tu imagen", message: nil, preferredStyle: .actionSheet)
        var chooseFromCamera = UIAlertAction()
        var chooseFromGallery = UIAlertAction()
        
        switch picker {
        case .profilePicture:
            chooseFromCamera = UIAlertAction(title: "Cámara", style: .default, handler: { _ in self.showProfileImagePickerController(.camera)})
            chooseFromGallery = UIAlertAction(title: "Galería de fotos", style: .default, handler: { _ in self.showProfileImagePickerController(.photoLibrary) })
        case .banner:
            chooseFromCamera = UIAlertAction(title: "Cámara", style: .default, handler: { _ in self.showBannerImagePickerController(.camera)})
            chooseFromGallery = UIAlertAction(title: "Galería de fotos", style: .default, handler: { _ in self.showBannerImagePickerController(.photoLibrary) })
        }
        
        alert.addAction(chooseFromCamera)
        alert.addAction(chooseFromGallery)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showProfileImagePickerController(_ sourceType: UIImagePickerController.SourceType) {
        profileImagePicker = UIImagePickerController()
        profileImagePicker!.delegate = self
        profileImagePicker!.allowsEditing = true
        profileImagePicker!.sourceType = sourceType
        present(profileImagePicker!, animated: true, completion: nil)
    }
    
    func showBannerImagePickerController(_ sourceType: UIImagePickerController.SourceType) {
        bannerImagePicker = UIImagePickerController()
        bannerImagePicker!.delegate = self
        bannerImagePicker!.allowsEditing = true
        bannerImagePicker!.sourceType = sourceType
        present(bannerImagePicker!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if picker == profileImagePicker {
                profilePictureImageView.image = editedImage
                profileImagePicker = nil
                
            } else {
                bannerPictureImageView.image = editedImage
                bannerImagePicker = nil
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileHomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension ProfileHomeViewController: DatePickerViewDelegate {
    func returnSelectedDate(date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        profileEventDateButton.setTitle(formatter.string(from: date), for: .normal)
    }
}
