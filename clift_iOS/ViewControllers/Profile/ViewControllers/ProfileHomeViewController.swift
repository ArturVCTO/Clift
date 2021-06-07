//
//  ProfileHomeViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 06/05/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit
import Moya
import RealmSwift

class ProfileHomeViewController: UIViewController {
    
    @IBOutlet weak var bannerPictureImageView: customImageView!
    @IBOutlet weak var profilePictureImageView: customImageView!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var profileAddressTextField: UITextField!
    @IBOutlet weak var profileBankAccountButton: UIButton!
    @IBOutlet weak var profileBankAccountTextField: UITextField!
    @IBOutlet weak var profileEventDateButton: customButton!
    var profileImagePicker: UIImagePickerController?
    var bannerImagePicker: UIImagePickerController?
    var event = Event()
    var currentBankAccount = BankAccount()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileNameTextField.delegate = self
        setNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getEventProfileBank()
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
        
        let closeSesion = UIBarButtonItem(title: "Cerrar sesión", style: .plain, target: self, action: #selector(logoutButtonTapped(sender:)))
        navigationItem.rightBarButtonItems = [closeSesion]
    }
    
    @objc func logoutButtonTapped(sender: AnyObject) {
        sharedApiManager.deleteLogoutSession() { (emptyObjectWithErrors, result) in
            if let response = result {
                if(response.isSuccess()) {
                    let realm = try! Realm()
                    try! realm.write {
                        realm.deleteAll()
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.showCreateSessionFlow()
                    }
                } else {
                    self.showMessage(NSLocalizedString("unknownError", comment: "unknownError"), type: .error)
                }
            }
        }
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
        updateEvent()
    }
    @IBAction func bankAccountPressed(_ sender: UIButton) {
        if hasStripeAccount() {
            let bankAccountVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileBankInformationVC") as! ProfileBankInformationViewController
            bankAccountVC.currentBankAccount = currentBankAccount
            bankAccountVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(bankAccountVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Stripe", message: "Esta cuenta no está asociada a una cuenta de Stripe.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    @objc func presentDatePicker() {
        let datePickerVC = DatePickerViewController()
        datePickerVC.delegate = self
        datePickerVC.modalPresentationStyle = .custom
        datePickerVC.transitioningDelegate = self
        
        self.present(datePickerVC, animated: true, completion: nil)
        datePickerVC.datePicker.date = event.date.fullStringToDate()
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
                event.eventImage = editedImage
                profileImagePicker = nil
                
            } else {
                bannerPictureImageView.image = editedImage
                event.coverImage = editedImage
                bannerImagePicker = nil
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Extension REST APIs
extension ProfileHomeViewController {
    
    func getEventProfileBank() {
        sharedApiManager.getEvents() { (events, result) in
            if let response = result {
                if (response.isSuccess()) {
                    if let currentEvent = events?.first {
                        sharedApiManager.showEvent(id: currentEvent.id) {(event, result) in
                            if let response = result {
                                if (response.isSuccess()) {
                                    guard let event = event else {
                                        return
                                    }
                                    self.event = event
                                    if let eventImageURL = URL(string:"\(event.eventImageUrl)") {
                                        self.profilePictureImageView.kf.setImage(with: eventImageURL)
                                    }
                                    
                                    if let coverImageURL = URL(string:"\(event.coverImageUrl)") {
                                        self.bannerPictureImageView.kf.setImage(with: coverImageURL)
                                    }
                                }
                            }
                        }

                        self.profileNameTextField.text = currentEvent.name
                        self.profileEventDateButton.setTitle(currentEvent.date, for: .normal)
                        self.getProfile()
                    }
                }
            } else {
                self.getProfile()
            }
        }
    }
    
    func getProfile() {
        sharedApiManager.getProfile() { (profile, result) in
            if let response = result {
                if response.isSuccess() {
                    self.profileAddressTextField.text = profile?.onboardingShippingAddress.streetAndNumber
                    self.getBankAccounts()
                }
            } else {
                self.getBankAccounts()
            }
        }
    }
    
    func getBankAccounts() {
        sharedApiManager.getBankAccounts() { (bankAccounts, result) in
            if let response = result {
                if (response.isSuccess()) {
                    if let bankAccount = bankAccounts?.first {
                        self.currentBankAccount = bankAccount
                        self.profileBankAccountButton.setTitle(self.hideAccountNumber(accountNumber: bankAccount.account), for: .normal)
                    } else {
                        self.profileBankAccountButton.setTitle("No hay cuenta asociada", for: .normal)
                    }
                } else if (response.isClientError()) {
                    self.showMessage("Hubo un error al cargar las cuentas asociadas. Intente de nuevo más tarde.", type: .error)
                }
            }
        }
    }
    
    private func hideAccountNumber(accountNumber: String) -> String {
        var accountHidden = ""
        for _ in 1...accountNumber.count - 4 {
            accountHidden += "*"
        }
        accountHidden += accountNumber.suffix(4)
        return accountHidden
    }
    
    func updateEvent() {
        var multipartFormData: [MultipartFormData] = self.getEventMultipart()
        
        if !(multipartFormData.isEmpty) {
            sharedApiManager.updateEvent(id: event.id, event: multipartFormData) { (event, result) in
                if let response = result {
                    if (response.isSuccess()) {
                        self.showMessage(NSLocalizedString("Evento actualizado", comment: "Update success"),type: .success)
                    } else if (response.isClientError()) {
                        self.showMessage(NSLocalizedString("\(event!.errors.first!)", comment: "Update Error"),type: .error)
                    } else  {
                        self.showMessage(NSLocalizedString("Error, intente de nuevo más tarde", comment: "Update Error"),type: .error)
                    }
                }
            }
        }
    }
    
    func getEventMultipart() -> [MultipartFormData] {
        var multipartFormData: [MultipartFormData] = []
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.event.name.description.data(using: String.Encoding.utf8)! ))),name: "event[name]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.event.date.description.data(using: String.Encoding.utf8)! ))),name: "event[date]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.event.visibility.description.data(using: String.Encoding.utf8)! ))),name: "event[visibility]"))
        
        if (self.event.eventImage != nil) {
            multipartFormData.append(MultipartFormData(provider: .data((self.event.eventImage?.jpegData(compressionQuality: 1.0))!), name: "event[event_image]", fileName: "image.jpeg", mimeType: "image/jpeg"))
        }
        
        if (self.event.coverImage != nil) {
            multipartFormData.append(MultipartFormData(provider: .data((self.event.coverImage?.jpegData(compressionQuality: 1.0))!), name: "event[cover_image]", fileName: "image.jpeg", mimeType: "image/jpeg"))
        }
        
        return multipartFormData
    }
    
    func hasStripeAccount() -> Bool {
        var canShowAccounts = false
        
        sharedApiManager.verifyEventPool(event: event) { (profile, result) in
            if let response = result {
                if response.isSuccess() {
                    canShowAccounts = true
                } else {
                    canShowAccounts = false
                }
            }
        }
        return canShowAccounts
    }
}

// MARK: Extension UITextFieldDelegate
extension ProfileHomeViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        event.name = textField.text ?? ""
    }
}

extension ProfileHomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension ProfileHomeViewController: DatePickerViewControllerDelegate {
    func returnSelectedDate(date: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "yyyy-MM-dd"
        profileEventDateButton.setTitle(formatter.string(from: date), for: .normal)
        event.date = formatter.string(from: date)
    }
}
