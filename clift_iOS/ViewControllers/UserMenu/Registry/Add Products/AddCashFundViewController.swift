//
//  AddCashFundViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/24/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import Moya
import GSMessages
import RealmSwift

class AddCashFundViewController: UIViewController {
    
    @IBOutlet weak var quantityTypeSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var cashFundImageView: UIImageView!
    @IBOutlet weak var hideTotalSwitch: UISwitch!
    @IBOutlet weak var markAsImportantSwitch: UISwitch!
    
    @IBOutlet weak var designLineView: UIView!
    @IBOutlet weak var designLineView2: UIView!
    @IBOutlet weak var hideFromGuestsView: UIView!
    @IBOutlet weak var fundCollaborationsLabel: UILabel!
    @IBOutlet weak var collaboratorsStepper: UIStepper!
    @IBOutlet weak var totalMountStackView: UIStackView!
    @IBOutlet weak var totalPoolAmountLabel: UILabel!
    
    @IBOutlet weak var cashFundNameTextField: HoshiTextField!
    @IBOutlet weak var cashFundNoteTextField: HoshiTextField!
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var totalMountTextField: HoshiTextField!
    @IBOutlet weak var mountTextField: HoshiTextField!
//    IBOutlet constraint for design purposes
    @IBOutlet weak var totalMountToNotesConstraintQT0: NSLayoutConstraint!
    var productsRegistryVC: ProductsRegistryViewController!
    var eventPool = EventPool()
    var mount = Double()
    var currentEvent = Event()
    @IBOutlet weak var detailsToMostImportantConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalMountToNoteConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInitialSwitchesValue()
        self.loadEvent()
        self.mountTextField.delegate = self
        self.totalMountTextField.delegate = self
        self.cashFundNameTextField.delegate = self
        self.cashFundNoteTextField.delegate = self
        self.loadCurrentQuantityType()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(true)
       self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0)
   }
    
    func loadEvent() {
       let realm = try! Realm()
       let realmEvents = realm.objects(Event.self)
       if let currentEvent = realmEvents.first {
           self.currentEvent = currentEvent
       }
    }
    
    func loadCurrentQuantityType() {
        if quantityTypeSegmentControl.selectedSegmentIndex == 0 {
                   self.mountTextField.isHidden = true
                   self.totalMountStackView.isHidden = true
                   self.designLineView.isHidden = true
                   self.designLineView2.isHidden = true
                   self.totalMountTextField.isHidden = false
                   self.fundCollaborationsLabel.isHidden = true
                   self.collaboratorsStepper.isHidden = true
                   self.hideFromGuestsView.isHidden = false

               } else {
                   self.mountTextField.isHidden = false
                   self.totalMountStackView.isHidden = false
                   self.designLineView.isHidden = false
                   self.designLineView2.isHidden = false
                   self.totalMountTextField.isHidden = true
                   self.fundCollaborationsLabel.isHidden = false
                   self.collaboratorsStepper.isHidden = false
                   self.hideFromGuestsView.isHidden = true

               }
    }
    
    var pickerHeightVisible: CGFloat!
    var mountToNote: CGFloat!
   
    func togglePickerViewVisibility(animated: Bool = true) {
        if detailsToMostImportantConstraint.constant != 0 {
            pickerHeightVisible = detailsToMostImportantConstraint.constant
            detailsToMostImportantConstraint.constant = 0
        } else {
            detailsToMostImportantConstraint.constant = pickerHeightVisible
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                  () -> Void in
                   self.view.layoutIfNeeded()
             }, completion: nil)
        } else {
             view.layoutIfNeeded()
        }
    }
    
    func toggleDetailsToMount(animated: Bool = true) {
        if detailsToMostImportantConstraint.constant != 8 {
            mountToNote = totalMountToNoteConstraint.constant
            totalMountToNoteConstraint.constant = 8
        } else {
            totalMountToNoteConstraint.constant = mountToNote
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                  () -> Void in
                   self.view.layoutIfNeeded()
             }, completion: nil)
        } else {
             view.layoutIfNeeded()
        }
    }
    
    @IBAction func quantityTypeSegmentChanged(_ sender: Any) {
        if quantityTypeSegmentControl.selectedSegmentIndex == 0 {
            self.mountTextField.isHidden = true
            self.totalMountStackView.isHidden = true
            self.designLineView.isHidden = true
            self.designLineView2.isHidden = true
            self.totalMountTextField.isHidden = false
            self.fundCollaborationsLabel.isHidden = true
            self.collaboratorsStepper.isHidden = true
            self.hideFromGuestsView.isHidden = false
            self.togglePickerViewVisibility()
//            self.toggleDetailsToMount()

        } else {
            self.mountTextField.isHidden = false
            self.totalMountStackView.isHidden = false
            self.designLineView.isHidden = false
            self.designLineView2.isHidden = false
            self.totalMountTextField.isHidden = true
            self.fundCollaborationsLabel.isHidden = false
            self.collaboratorsStepper.isHidden = false
            self.hideFromGuestsView.isHidden = true
            self.togglePickerViewVisibility()
//            self.toggleDetailsToMount()
        }
    }
    
    @IBAction func addImageToCashFund(_ sender: Any) {
        self.openCameraPickerForCashFund()
    }
    
    @IBAction func collaboratorStepperChanged(_ sender: UIStepper) {
        self.fundCollaborationsLabel.text = "Colaboraciones: \(Int(sender.value))"
        if (self.mountTextField.text != "") {
            self.totalPoolAmountLabel.text = "$\(Double(sender.value) * self.mount)"
        }
    }
    
    func hideKeyBoardForMountTextField() {
           mountTextField.resignFirstResponder()
    }
    
    func hideKeyBoardForTotalMountTextField() {
        totalMountTextField.resignFirstResponder()
    }
    
    func hideKeyBoardForCashFundNameTextField() {
        cashFundNameTextField.resignFirstResponder()
    }
    
    func hideKeyBoardForNoteTextField() {
        cashFundNoteTextField.resignFirstResponder()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func createCashFundButtonTapped(_ sender: Any) {
        self.createCashFund(event: self.currentEvent)
    }
    @IBAction func hideTotalFromGuests(_ sender: Any) {
        if self.hideTotalSwitch.isOn {
            self.eventPool.isPriceVisible = false
        } else {
            self.eventPool.isPriceVisible = true
        }
    }
    
    @IBAction func markAsImportant(_ sender: Any) {
        if self.markAsImportantSwitch.isOn {
            self.eventPool.isImportant = true
        } else {
            self.eventPool.isImportant = false
        }
    }
    
    func loadInitialSwitchesValue() {
        self.eventPool.isPriceVisible = true
        self.eventPool.isImportant = false
    }
    
    
    func createCashFund(event: Event) {
        var multipartFormData: [MultipartFormData] = self.getCashFundMultipart()
        
        sharedApiManager.createEventPool(event: event, pool: multipartFormData) { (emptyObjectWIthErrors, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.productsRegistryVC.getEventProducts(event: self.currentEvent, available: self.productsRegistryVC.availableSelected, gifted: self.productsRegistryVC.giftedSelected, filters: [:])
                    self.productsRegistryVC.eventProductsCollectionView.reloadData()
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.showMessage(NSLocalizedString("Fondo creado", comment: "Fondo Creado"), type: .success)
                } else if (response.isClientError()) {
                    self.showMessage(NSLocalizedString("\(emptyObjectWIthErrors!.errors.first!)", comment: "errors"), type: .error)
                } else {
                    self.showMessage(NSLocalizedString("Error de servidor, intente de nuevo más tarde", comment: "Error"), type: .error)
                }
            }
        }
    }
    
    func getCashFundMultipart() -> [MultipartFormData] {
        var multipartFormData: [MultipartFormData] = []
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.eventPool.name.description.data(using: String.Encoding.utf8)! ))),name: "event_pool[name]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.eventPool.note.description.data(using: String.Encoding.utf8)! ))),name: "event_pool[note]"))
        
        if quantityTypeSegmentControl.selectedSegmentIndex == 0 {
          multipartFormData.append(MultipartFormData(provider: .data(((self.eventPool.amount.description.data(using: String.Encoding.utf8)! ))),name: "event_pool[amount]"))
        } else {
            multipartFormData.append(MultipartFormData(provider: .data(((self.totalPoolAmountLabel.text!.description.data(using: String.Encoding.utf8)! ))),name: "event_pool[amount]"))
        }
        
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.eventPool.suggestedAmount.description.data(using: String.Encoding.utf8)! ))),name: "event_pool[suggested_amount]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.eventPool.isImportant.description.data(using: String.Encoding.utf8)! ))),name: "event_pool[is_important]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.eventPool.isPriceVisible.description.data(using: String.Encoding.utf8)! ))),name: "event_pool[is_price_visible]"))
        
        if (self.eventPool.image != nil) {
                  multipartFormData.append(MultipartFormData(provider: .data((self.eventPool.image?.jpegData(compressionQuality: 1.0))!), name: "event_pool[image]", fileName: "image.jpeg", mimeType: "image/jpeg"))
        }
        
        return multipartFormData
    }
}

extension AddCashFundViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var bool = false
        
        if textField == mountTextField {
            hideKeyBoardForMountTextField()
            bool = true
        } else if textField == totalMountTextField {
            hideKeyBoardForTotalMountTextField()
            bool = true
        } else if textField == cashFundNameTextField {
            hideKeyBoardForCashFundNameTextField()
            bool = true
        } else if textField == cashFundNoteTextField {
            hideKeyBoardForNoteTextField()
            bool = true
        }
        
        return bool
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mountTextField {
            self.mount = Double(self.mountTextField.text!)!
            self.eventPool.suggestedAmount = self.mountTextField.text!
        }
        
        if textField == totalMountTextField {
            self.eventPool.amount = Int(self.totalMountTextField.text!)!
        }
        
        if textField == cashFundNoteTextField {
            self.eventPool.note = cashFundNoteTextField.text!
        }
        if textField == cashFundNameTextField {
            self.eventPool.name = cashFundNameTextField.text!
        }
        
    }
}
extension AddCashFundViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func openCameraPickerForCashFund() {
        imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .overFullScreen
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker,animated: true, completion: nil)
    }
    
    func openGallerPickerForCashFund() {
        imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .overFullScreen
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imagePicker.dismiss(animated: true, completion: nil)
            self.eventPool.image = info[.originalImage] as! UIImage?
            self.cashFundImageView.image = info[.originalImage] as! UIImage?
       }
}
