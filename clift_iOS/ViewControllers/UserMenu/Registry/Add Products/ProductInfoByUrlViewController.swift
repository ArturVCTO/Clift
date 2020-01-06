//
//  ProductInfoByUrlViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/29/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import Kingfisher
import Moya
import RealmSwift
import GSMessages

class ProductInfoByUrlViewController: UIViewController {
    
    var productName = ""
    var productPrice = ""
    var productImageUrl = ""
    var productUrl = ""
    var currentEvent = Event()
    var externalProduct = ExternalProduct()
    var productsRegistryVC: ProductsRegistryViewController!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextField: HoshiTextField!
    @IBOutlet weak var productPriceTextField: HoshiTextField!
    @IBOutlet weak var productNoteTextField: HoshiTextField!
    @IBOutlet weak var redirectToUrlSwitch: UISwitch!
    @IBOutlet weak var collaborativeSwitch: UISwitch!
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var quantityProductLabel: UILabel!
    
    @IBOutlet weak var productUrlLabel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadEvent()
        self.productNameTextField.delegate = self
        self.productPriceTextField.delegate = self
        self.productNoteTextField.delegate = self
        self.navigationController!.navigationBar.barTintColor = UIColor.white
        self.loadProductByUrl()
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
    
    @IBAction func quantityValueChanged(_ sender: UIStepper) {
        self.quantityProductLabel.text = "Cantidad: \(Int(sender.value))"
        self.externalProduct.quantity = Int(sender.value)
    }
    
    func hideKeyBoardForProductNameTextField() {
        productNameTextField.resignFirstResponder()
    }
    
    func hideKeyBoardForProductPriceTextField() {
        productPriceTextField.resignFirstResponder()
    }
    
    func hideKeyBoardForProductNoteTextField() {
        productNoteTextField.resignFirstResponder()
    }
    
    @IBAction func goToUrl(_ sender: Any) {
        guard let url = URL(string: self.productUrl) else {
             return
         }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
    }
    
    
    func createManualProduct(event: Event) {
        var multipartFormData: [MultipartFormData] = self.getManualProductMultipart()
        
        sharedApiManager.createExternalProduct(event: event, externalProduct: multipartFormData) {(emptyObjectWithErrors,result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.productsRegistryVC.getEventProducts(event: self.currentEvent, available: self.productsRegistryVC.availableSelected, gifted: self.productsRegistryVC.giftedSelected, filters: [:])
                    self.productsRegistryVC.eventProductsCollectionView.reloadData()
                    
                    self.navigationController?.popToViewController(self.productsRegistryVC, animated: true)
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
    
    
    func loadProductByUrl() {
        self.productNameTextField.text = self.productName
        self.productPriceTextField.text = self.productPrice
        self.externalProduct.name = self.productName
        self.externalProduct.price = self.productPrice
        self.externalProduct.url = self.productUrl
        self.externalProduct.image = productImageView.image
        self.productUrlLabel.setTitle(self.productUrl, for: .normal)
        if let imageURL = URL(string:"\(productImageUrl)") {
            self.productImageView.kf.setImage(with: imageURL)
        }
    }
    @IBAction func addImageButtonTapped(_ sender: Any) {
        self.openCameraPickerForProduct()
    }
    
    @IBAction func redirectToUrlChanged(_ sender: Any) {
        if redirectToUrlSwitch.isOn {
            self.externalProduct.redirectToUrl = true
        } else {
            self.externalProduct.redirectToUrl = false
        }
    }
    
    
    @IBAction func makeCollaborativeChanged(_ sender: Any) {
        if collaborativeSwitch.isOn {
            self.externalProduct.isCollaborative = true
        } else {
            self.externalProduct.isCollaborative = false
        }
    }
    
    
    @IBAction func importantChanged(_ sender: Any) {
        if self.importantSwitch.isOn {
            self.externalProduct.isImportant = true
        } else {
            self.externalProduct.isImportant = false
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addProductButtonTapped(_ sender: Any) {
        self.createManualProduct(event: self.currentEvent)
    }
    
    
}
extension ProductInfoByUrlViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var bool = false
        
        if textField == productPriceTextField {
            hideKeyBoardForProductPriceTextField()
            bool = true
        } else if textField == productNameTextField {
            hideKeyBoardForProductNameTextField()
            bool = true
        } else if textField == productNoteTextField {
            hideKeyBoardForProductNoteTextField()
            bool = true
        }
        
        return bool
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == productPriceTextField {
            self.externalProduct.price = self.productPriceTextField.text!
        }
        
      if textField == productNoteTextField {
            self.externalProduct.note = productNoteTextField.text!
        }
      
        if textField == productNameTextField {
            self.externalProduct.name = productNameTextField.text!
        }
        
    }
}
extension ProductInfoByUrlViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func openCameraPickerForProduct() {
       imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .overFullScreen
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker,animated: true,completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.externalProduct.image = info[.originalImage] as! UIImage?
        self.productImageView.image = info[.originalImage] as! UIImage?
    }
}
