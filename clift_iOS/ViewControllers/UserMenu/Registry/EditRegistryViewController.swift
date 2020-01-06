//
//  EditRegistryViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/27/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import Moya
import GSMessages

class EditRegistryViewController: UIViewController {
    
    var eventId = ""
    var event = Event()
    
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    var eventImagePicker: UIImagePickerController!
    var coverImagePicker: UIImagePickerController!
    var giftsVC: GiftsViewController!
    var invitationsVC: InvitationsViewController!
    var paymentsVC: PaymentsViewController!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var eventNameTextField: HoshiTextField!
    @IBOutlet weak var eventImageView: customImageView!
    @IBOutlet weak var visibilitySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventNameTextField.delegate = self
        self.getEvent()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getEvent() {
        sharedApiManager.showEvent(id: eventId) { (event, result) in
            if let response = result {
                if response.isSuccess() {
                    print(event!.toJSON())
                    self.loadInitialEvent(event: event!)
                }
            }
        }
    }
    
    func loadInitialEvent(event: Event) {
        self.event.name = event.name
        self.event.date = event.date
        self.eventNameTextField.text = event.name
        self.eventDatePicker.setDate(event.date.stringToDate(), animated: false)
        if(event.visibility == 0) {
            self.visibilitySwitch.isOn = false
        } else {
            self.visibilitySwitch.isOn = true
        }
        
        if let eventImageURL = URL(string:"\(event.eventImageUrl)") {
            self.eventImageView.kf.setImage(with: eventImageURL)
        }
        
        if let coverImageURL = URL(string:"\(event.coverImageUrl)") {
            self.coverImageView.kf.setImage(with: coverImageURL)
        }
        
    }
    
    func updateEvent() {
        var multipartFormData: [MultipartFormData] = self.getEventMultipart()
        
        if !(multipartFormData.isEmpty) {
            sharedApiManager.updateEvent(id: eventId, event: multipartFormData) { (event, result) in
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
    
    @IBAction func eventImageButtonTapped(_ sender: Any) {
        let sheet = UIAlertController(title: "Subir foto de evento", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Cámara", style: .default, handler: { _ in
            self.openCameraPickerForEvent()
        })
        
        let galleryAction = UIAlertAction(title: "Galería de fotos", style: .default, handler: { _ in
          self.openGalleryPickerForEvent()
        })
        sheet.addAction(cameraAction)
        sheet.addAction(galleryAction)
        present(sheet,animated: true, completion: nil)
    }
    
    
    @IBAction func coverImageButtonTapped(_ sender: Any) {
        let sheet = UIAlertController(title: "Subir foto de portada", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Cámara", style: .default, handler: { _ in
            self.openCameraPickerForCover()
        })
        
        let galleryAction = UIAlertAction(title: "Galería de fotos", style: .default, handler: { _ in
            self.openGalleryPickerForCover()
        })
        
        sheet.addAction(cameraAction)
        sheet.addAction(galleryAction)
        present(sheet,animated: true, completion: nil)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        self.event.date = self.eventDatePicker.date.eventDateFormatter()
    }
    
    @IBAction func visibilitySwitchChanged(_ sender: Any) {
        if self.visibilitySwitch.isOn {
            self.event.visibility = 1
        } else {
            self.event.visibility = 0
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.updateEvent()
        self.paymentsVC.getEvents()
        self.invitationsVC.getEvents()
        
        self.giftsVC.getEvents()
    }
    
    
    
}

extension EditRegistryViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.eventNameTextField:
            self.event.name = self.eventNameTextField.text!
        default:
            break
        }
    }
    
    func hideKeyBoard() {
        eventNameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var bool = false
        if textField == eventNameTextField {
            hideKeyBoard()
            bool = true
        }
        return bool
    }
}

extension EditRegistryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCameraPickerForEvent() {
        eventImagePicker = UIImagePickerController()
        eventImagePicker.modalPresentationStyle = .overFullScreen
        
        eventImagePicker.delegate = self
        eventImagePicker.sourceType = .camera
        
        present(eventImagePicker,animated: true, completion: nil)
    }
    
    func openGalleryPickerForEvent() {
        eventImagePicker = UIImagePickerController()
        eventImagePicker.modalPresentationStyle = .overFullScreen
      
        eventImagePicker.delegate = self
        eventImagePicker.allowsEditing = true
        eventImagePicker.sourceType = .photoLibrary
        present(eventImagePicker,animated: true, completion: nil)
    }
    
    func openCameraPickerForCover() {
        coverImagePicker = UIImagePickerController()
        coverImagePicker.modalPresentationStyle = .overFullScreen
        coverImagePicker.delegate = self
        coverImagePicker.sourceType = .camera
        
        present(coverImagePicker,animated: true, completion: nil)
    }
    
    func openGalleryPickerForCover() {
        coverImagePicker = UIImagePickerController()
        coverImagePicker.modalPresentationStyle = .overFullScreen
        coverImagePicker.delegate = self 
        coverImagePicker.allowsEditing = true
        coverImagePicker.sourceType = .photoLibrary
        present(coverImagePicker,animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        switch picker {
        case coverImagePicker:
            coverImagePicker.dismiss(animated: true, completion: nil)
            self.event.coverImage = info[.originalImage] as! UIImage?
            self.coverImageView.image = info[.originalImage] as! UIImage?
        case eventImagePicker:
            eventImagePicker.dismiss(animated: true, completion: nil)
            self.event.eventImage = info[.originalImage] as! UIImage?
            self.eventImageView.image = info[.originalImage] as! UIImage?
        default:
            break
        }
    }
}
