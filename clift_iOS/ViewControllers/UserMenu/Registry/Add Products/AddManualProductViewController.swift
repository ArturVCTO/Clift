//
//  AddManualProductViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/24/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import RealmSwift
import Moya
import GSMessages

class AddManualProductViewController: UIViewController {
    
    @IBOutlet weak var storeNameTextField: HoshiTextField!
    
    @IBOutlet weak var productNameTextField: HoshiTextField!
    
    @IBOutlet weak var productPriceTextField: HoshiTextField!
    
    @IBOutlet weak var productNoteTextField: HoshiTextField!
    @IBOutlet weak var collaborativeProductSwitch: UISwitch!
    var productsRegistryVC: ProductsRegistryViewController!
    @IBOutlet weak var quantityProductLabel: UILabel!
    @IBOutlet weak var importantProductSwitch: UISwitch!
    @IBOutlet weak var manualProductImageView: UIImageView!
    var currentEvent = Event()
    var externalProduct = ExternalProduct()
    var imagePicker: UIImagePickerController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInitialBooleans()
        self.loadEvent()
        self.productLoader()
        self.storeNameTextField.delegate = self
        self.productNoteTextField.delegate = self
        self.productNameTextField.delegate = self
        self.productPriceTextField.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0)
    }
    
    func productLoader() {
        self.productNoteTextField.text = externalProduct.note
        self.productNameTextField.text = externalProduct.name
        self.productPriceTextField.text = "\(externalProduct.price)"
    }
    
    func loadEvent() {
         let realm = try! Realm()
         let realmEvents = realm.objects(Event.self)
         if let currentEvent = realmEvents.first {
             self.currentEvent = currentEvent
         }
      }
    
    func createManualProduct(event: Event) {
        var multipartFormData: [MultipartFormData] = self.getManualProductMultipart()
        
        sharedApiManager.createExternalProduct(event: event, externalProduct: multipartFormData) {(emptyObjectWithErrors,result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.productsRegistryVC.getEventProducts(event: self.currentEvent, available: self.productsRegistryVC.availableSelected, gifted: self.productsRegistryVC.giftedSelected, filters: [:])
                    self.productsRegistryVC.eventProductsCollectionView.reloadData()
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.showMessage(NSLocalizedString("Producto creado", comment: ""), type: .success)
                } else if (response.isClientError()) {
                    self.showMessage(NSLocalizedString("\(emptyObjectWithErrors!.errors.first!)", comment: ""), type: .error)
                } else {
                    self.showMessage(NSLocalizedString("Error de servidor, intente de nuevo más tarde", comment: ""), type: .error)
                }
            }
        }
    }
    
    func getManualProductMultipart() -> [MultipartFormData] {
        var multipartFormData: [MultipartFormData] = []
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.externalProduct.name.description.data(using: String.Encoding.utf8)! ))),name: "external_product[name]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.externalProduct.shopName.description.data(using: String.Encoding.utf8)! ))),name: "external_product[shop_name]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.externalProduct.price.description.data(using: String.Encoding.utf8)! ))),name: "external_product[price]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.externalProduct.quantity.description.data(using: String.Encoding.utf8)! ))),name: "external_product[quantity]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.externalProduct.isImportant.description.data(using: String.Encoding.utf8)! ))),name: "external_product[is_important]"))
        
        multipartFormData.append(MultipartFormData(provider: .data(((self.externalProduct.isCollaborative.description.data(using: String.Encoding.utf8)! ))),name: "external_product[is_collaborative]"))
        
        multipartFormData.append(MultipartFormData(provider: .data((("ExternalProduct".description.data(using: String.Encoding.utf8)! ))),name: "external_product[wishable_type]"))
        
        if (self.externalProduct.image != nil) {
                  multipartFormData.append(MultipartFormData(provider: .data((self.externalProduct.image?.jpegData(compressionQuality: 1.0))!), name: "external_product[image]", fileName: "image.jpeg", mimeType: "image/jpeg"))
        }
        
        return multipartFormData
    }
    
    func hideKeyBoardForStoreNameTextField() {
        storeNameTextField.resignFirstResponder()
     }
     
     func hideKeyBoardForProductPriceTextField() {
         productPriceTextField.resignFirstResponder()
     }
     
     func hideKeyBoardForProductNameTextField() {
         productNameTextField.resignFirstResponder()
     }
     
     func hideKeyBoardForNoteTextField() {
         productNoteTextField.resignFirstResponder()
     }
    
    @IBAction func quantityProducStepperChanged(_ sender: UIStepper) {
        self.quantityProductLabel.text = "Cantidad: \(Int(sender.value))"
        self.externalProduct.quantity = Int(sender.value)
    }
    
    
    @IBAction func createManualProductButtonTapped(_ sender: Any) {
        self.createManualProduct(event: self.currentEvent)
    }
    
    @IBAction func collaborativeSwitchChanged(_ sender: UISwitch) {
        if collaborativeProductSwitch.isOn {
            self.externalProduct.isCollaborative = true
        } else {
            self.externalProduct.isCollaborative = false
        }
    }
    
    @IBAction func importantSwitchChanged(_ sender: Any) {
        if importantProductSwitch.isOn {
            self.externalProduct.isImportant = true
        } else {
            self.externalProduct.isImportant = false
        }
    }
    
    func loadInitialBooleans() {
        self.externalProduct.isImportant = false
        self.externalProduct.isCollaborative = false
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        self.openCameraPickerForManualProduct()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension AddManualProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          var bool = false
          
          if textField == storeNameTextField {
              hideKeyBoardForStoreNameTextField()
              bool = true
          } else if textField == productPriceTextField {
              hideKeyBoardForProductPriceTextField()
              bool = true
          } else if textField == productNameTextField {
              hideKeyBoardForProductNameTextField()
              bool = true
          } else if textField == productNoteTextField {
              hideKeyBoardForNoteTextField()
              bool = true
          }
          
          return bool
      }
      
      func textFieldDidEndEditing(_ textField: UITextField) {
          if textField == storeNameTextField {
            self.externalProduct.shopName = self.storeNameTextField.text!
          }
          
          if textField == productPriceTextField {
            self.externalProduct.price = Int(self.productPriceTextField.text!)!
          }
          
        if textField == productNoteTextField {
              self.externalProduct.note = productNoteTextField.text!
          }
        
          if textField == productNameTextField {
              self.externalProduct.name = productNameTextField.text!
          }
          
      }
}

extension AddManualProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCameraPickerForManualProduct() {
        imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .overFullScreen
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker,animated: true,completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.externalProduct.image = info[.originalImage] as! UIImage?
        self.manualProductImageView.image = info[.originalImage] as! UIImage?
    }
    
}
