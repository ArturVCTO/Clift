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

class AddCashFundViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cashFundImageView: UIImageView!
    @IBOutlet weak var goalTextField: HoshiTextField!
    
    @IBOutlet weak var markAsImportantSwitch: UISwitch!
    @IBOutlet weak var cashFundNameTextField: HoshiTextField!
    @IBOutlet weak var cashFundNoteTextField: HoshiTextField!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var totalMountTextField: HoshiTextField!
    @IBOutlet weak var hideFromGuestsSwitch: UISwitch!
    @IBOutlet weak var createButton: customButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var productsRegistryVC: ProductsRegistryViewController!
    var eventPool = EventPool()
    var goal = Double()
    var mount = Double()
    var currentEvent = Event()
    var yOrigin = CGFloat()
    var lastKeyboardSize = CGFloat()
    
    override func viewDidLoad() {
        goalTextField.delegate = self
        cashFundNameTextField.delegate = self
        cashFundNoteTextField.delegate = self
        totalMountTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnClickOutside))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        yOrigin =  self.view.frame.origin.y
        self.view.frame.origin.y = yOrigin
    }
    
   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(true)
       self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0)
   }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == self.yOrigin {
                self.view.frame.origin.y -= (keyboardSize.height)
                self.lastKeyboardSize = keyboardSize.height
            }
            
        }
    }
    
    @objc func keyboardDidShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("size",keyboardSize)
            if lastKeyboardSize > keyboardSize.height{
                       self.view.frame.origin.y += (lastKeyboardSize - keyboardSize.height)
                       self.lastKeyboardSize = keyboardSize.height
                   }else if  lastKeyboardSize < keyboardSize.height{
                       self.view.frame.origin.y -= (lastKeyboardSize - keyboardSize.height)
                       self.lastKeyboardSize = keyboardSize.height
                   }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != self.yOrigin {
            self.view.frame.origin.y = self.yOrigin
        }
    }
    
    @IBAction func hideKeyboardOnClickOutside(){
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //self.view.frame.origin.y = self.yOrigin
    }
    
    @IBAction func createMoneyPool(_ sender: Any) {
        if let goalToSet = goalTextField.text{
            self.goal = Double(goalToSet) ?? 0
        }
        
        if let amountToSet = totalMountTextField.text{
            self.mount = Double(amountToSet) ?? 0
        }
        
        if(self.cashFundNameTextField.text == "" || self.goalTextField.text == "" || self.totalMountTextField.text == ""){
            self.hideKeyboardOnClickOutside()
            self.showMessage(NSLocalizedString("Favor de llenar todos los campos obligatorios", comment: "Create Error"),type: .error)
            return
        }
        else if(self.goal <= 0){
            self.hideKeyboardOnClickOutside()
            self.showMessage(NSLocalizedString("Meta debe ser mayor a $0 MXN", comment: "Create Error"),type: .error)
            return
        }
        else if(self.mount <= 0 || self.mount >= self.goal){
            self.hideKeyboardOnClickOutside()
            self.showMessage(NSLocalizedString("Contribución mínima debe ser menor que Meta", comment: "Create Error"),type: .error)
            return
        }
        else{
            self.hideKeyboardOnClickOutside()
            
            self.eventPool.collectedAmount = "0"
            self.eventPool.description = self.cashFundNameTextField.text!
            self.eventPool.goal = String(self.goal)
            self.eventPool.isImportant = self.markAsImportantSwitch.isOn
            self.eventPool.isPriceVisible = !self.hideFromGuestsSwitch.isOn
            self.eventPool.note = self.cashFundNoteTextField.text!
            self.eventPool.suggestedAmount = String(self.mount)
            self.eventPool.image = self.cashFundImageView.image as! UIImage?
            var multipartFormData: [MultipartFormData] = self.createPoolData()
            
            if !(multipartFormData.isEmpty) {
                self.createButton.setTitle("Procesando", for: .normal)
                self.createButton.isEnabled = false
                self.cancelButton.isEnabled = false
                sharedApiManager.createEventPool(event: self.currentEvent, pool: multipartFormData) { (_, response) in
                if let result=response{
                    if result.isSuccess(){
                            self.productsRegistryVC.registrySegment.selectedSegmentIndex = 2
                            
                            self.productsRegistryVC.segmentedValueChanged(self.productsRegistryVC.registrySegment)
                        self.parent?.showMessage(NSLocalizedString("Sobre de dinero creado con éxito", comment: "Create Success"),type: .success)
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        print(result)
                        self.showMessage(NSLocalizedString("Error, intentelo más tarde", comment: "Create error"),type: .error)
                        self.createButton.setTitle("Crear Sobre de Dinero", for: .normal)
                        self.createButton.isEnabled = true
                        self.cancelButton.isEnabled = true
                    }
                }
            }
            }
        }
    }
    
    func createPoolData() -> [MultipartFormData] {
        var multipartFormData: [MultipartFormData] = []
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.eventPool.description.data(using: String.Encoding.utf8)!))), name: "event_pool[description]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.eventPool.goal.data(using: String.Encoding.utf8)!))), name: "event_pool[goal]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.eventPool.suggestedAmount.data(using: String.Encoding.utf8)!))), name: "event_pool[suggested_amount]"))
        
        var tempStr = ""
        if(self.eventPool.isPriceVisible){
            tempStr = "true"
        }else{
            tempStr = "false"
        }
        
        multipartFormData.append(MultipartFormData(provider: .data(((tempStr.data(using: String.Encoding.utf8)!))), name: "event_pool[is_price_visible]"))
        
        if(self.eventPool.isImportant){
            tempStr = "true"
        }else{
            tempStr = "false"
        }
        
        multipartFormData.append(MultipartFormData(provider: .data(((tempStr.data(using: String.Encoding.utf8)!))), name: "event_pool[is_important]"))
        
        if(self.eventPool.image != nil){
            multipartFormData.append(MultipartFormData(provider: .data((self.eventPool.image?.jpegData(compressionQuality: 1.0))!), name: "event_pool[image]", fileName: "image.jpeg", mimeType: "image/jpeg"))
        }
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.eventPool.note.data(using: String.Encoding.utf8)!))), name: "event_pool[note]"))
        
        tempStr = "1"
        
        multipartFormData.append(MultipartFormData(provider: .data(((tempStr.data(using: String.Encoding.utf8)!))), name: "event_pool[contributions]"))
        
        return multipartFormData
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func takePhotoAsCoverPhoto(_ sender: Any) {
        self.openCameraPickerForCashFund()
    }
    @IBAction func pickImageAsCoverPhoto(_ sender: Any) {
        self.openGallerPickerForCashFund()
    }
}

extension AddCashFundViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func openCameraPickerForCashFund() {
        view.endEditing(true)
        imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .overFullScreen
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker,animated: true, completion: nil)
    }
    
    func openGallerPickerForCashFund() {
        view.endEditing(true)
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
            self.view.frame.origin.y = self.yOrigin
            self.hideKeyboardOnClickOutside()
       }
}
