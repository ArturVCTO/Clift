//
//  AssociateStripeAccountViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 2/26/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import Stripe
import UIKit
import RealmSwift
import TextFieldEffects
import DropDown

struct UserStripeParams {
    let name: String
    let lastName: String
    let dateOfBirth: DateComponents
    let email: String
    let gender: String
    let maidenName: String
    let phone: String
    let idNumber: String
    let fileFrontId: String
    let fileBackId: String
}

struct AddressParams {
    let city: String
    let country: String
    let line1: String
    let line2: String
    let postalCode: String
    let state: String
    let town: String
}

class AssociateStripeAccountViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var lastNameTextField: HoshiTextField!
    @IBOutlet weak var maidenNameTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var cellphoneTextField: HoshiTextField!
    @IBOutlet weak var zipCodeTextField: HoshiTextField!
    @IBOutlet weak var districtTextField: HoshiTextField!
    @IBOutlet weak var streetAndNumberTextField: HoshiTextField!
    @IBOutlet weak var genderDropdownButton: UIButton!
    @IBOutlet weak var countryDropdownButton: UIButton!
    @IBOutlet weak var stateButtonDropdown: UIButton!
    @IBOutlet weak var cityButtonDropdown: UIButton!
    @IBOutlet weak var frontIdImageView: customImageView!
    @IBOutlet weak var backIdImageView: customImageView!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var personalIdTextField: HoshiTextField!
    var currentUser: User?
    var genderDropdown = DropDown()
    var countryDropdown = DropDown()
    var stateDropdown = DropDown()
    var cityDropdown = DropDown()
    var genders = ["Hombre","Mujer","Otro","Prefiero no decirlo"]
    var address = STPConnectAccountAddress()
    var accountParams: [String: Any] = [:]
    var identificationParams = STPConnectAccountVerificationDocument()
    var frontImagePicker: UIImagePickerController!
    var backImagePicker: UIImagePickerController!
    var stripeAccountId = ""

    //    Pending MR from BE
    var states = ["Nuevo León"]
    var cities = ["Monterrey","San Pedro Garza García"]
    var countries = ["MX"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getProfile()
        self.setupDropDownStyle()
        self.setupGenderDD()
        self.setupCityDD()
        self.setupStateDD()
        self.setupCountryDD()
        self.getAddresses()
    }
    
    func getProfile() {
        sharedApiManager.getProfile() { (user,result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.loadCurrentUserData(user: user!)
                }
            }
        }
    }
    
    func setupDropDownStyle() {
        let appearance = DropDown.appearance()
        appearance.cornerRadius = 4
        appearance.cellHeight = 40
    }
    
//    func getCompanyParams(individualConnect: UserStripeParams, addressConnect: AddressParams) {
//        let companyParams = STPConnectAccountIndividualParams()
//        let addressParams = STPConnectAccountAddress()
//        companyParams.firstName = individualConnect.name
//
//        addressParams.city = addressConnect.city
//        companyParams.address = addressParams
//    }
//
    func loadCurrentUserData(user: User) {
        self.nameTextField.text = user.name
        accountParams["first_name"] = user.name
        accountParams["last_name"] = user.lastName
        self.lastNameTextField.text = user.lastName
        self.emailTextField.text = user.email
        accountParams["email"] = user.email
        self.cellphoneTextField.text = user.cellPhoneNumber
        accountParams["phone"] = user.cellPhoneNumber
        self.stripeAccountId = user.stripeAccount
    }
    
    func getAddresses() {
        sharedApiManager.getAddresses() { (addresses, result) in
            if let response = result {
                if response.isSuccess() {
                    if !(addresses!.isEmpty) {
                        if let addresses = addresses {
                            for address in addresses {
                                if address.isDefault {
                                    self.loadAddressData(address: address)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func stripeSetupAddress() {
    }
    
    func getDefaultAddress() {
        
    }
    
    func loadAddressData(address: Address) {
        
    }
    
    @IBAction func countryButtonTapped(_ sender: Any) {
        self.countryDropdown.show()
    }
    
    func setupCountryDD() {
        var dataSourceDropDown = [String]()
        countryDropdown.anchorView = self.countryDropdownButton
        
        for country in countries {
            dataSourceDropDown.append("\(country)")
        }
        countryDropdown.dataSource = dataSourceDropDown
        countryDropdown.bottomOffset = CGPoint(x: 0, y: countryDropdownButton.bounds.height)
        
        countryDropdown.selectionAction = { [weak self] (index, item) in
            self!.countryDropdownButton.setTitle(item, for: .normal)
            self!.address.country = "\(item)"
        }
    }
    
    func setupStateDD() {
        var dataSourceDropDown = [String]()
              stateDropdown.anchorView = self.stateButtonDropdown
              
              for state in states {
                  dataSourceDropDown.append("\(state)")
              }
              stateDropdown.dataSource = dataSourceDropDown
              stateDropdown.bottomOffset = CGPoint(x: 0, y: stateButtonDropdown.bounds.height)
              
              stateDropdown.selectionAction = { [weak self] (index, item) in
                  self!.stateButtonDropdown.setTitle(item, for: .normal)
                self!.address.state = "\(item)"
              }
    }
    
    func setupCityDD() {
          var dataSourceDropDown = [String]()
                cityDropdown.anchorView = self.cityButtonDropdown
                
                for city in cities {
                    dataSourceDropDown.append("\(city)")
                }
                cityDropdown.dataSource = dataSourceDropDown
                cityDropdown.bottomOffset = CGPoint(x: 0, y: cityButtonDropdown.bounds.height)
                
                cityDropdown.selectionAction = { [weak self] (index, item) in
                    self!.cityButtonDropdown.setTitle(item, for: .normal)
                    self!.address.city = "\(item)"
                }
      }
    
    @IBAction func stateButtonTapped(_ sender: Any) {
        self.stateDropdown.show()
    }
    
    @IBAction func cityButtonTapped(_ sender: Any) {
        self.cityDropdown.show()
    }
    
    func setupGenderDD() {
        var dataSourceDropDown = [String]()
        genderDropdown.anchorView = self.genderDropdownButton
        
        for gender in genders {
            dataSourceDropDown.append("\(gender)")
        }
        genderDropdown.dataSource = dataSourceDropDown
        genderDropdown.bottomOffset = CGPoint(x: 0, y: genderDropdownButton.bounds.height)
        
        genderDropdown.selectionAction = { [weak self] (index, item) in
            self!.genderDropdownButton.setTitle(item, for: .normal)
            self?.accountParams["gender"] = "\(item)"
        }
    }
    
    @IBAction func genderDropdownTapped(_ sender: Any) {
        genderDropdown.show()
    }
    
    @IBAction func frontIdButtonTapped(_ sender: Any) {
        let sheet = UIAlertController(title: "Subir foto de identificación de frente", message: nil, preferredStyle: .actionSheet)
               let cameraAction = UIAlertAction(title: "Cámara", style: .default, handler: { _ in
                   self.openCameraPickerForFrontId()
               })
               
               let galleryAction = UIAlertAction(title: "Galería de fotos", style: .default, handler: { _ in
                   self.openGalleryPickerForFrontId()
               })
               let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
               sheet.addAction(cameraAction)
               sheet.addAction(galleryAction)
        sheet.addAction(cancelAction)
               present(sheet,animated: true, completion: nil)
    }
    
    @IBAction func backIdButtonTapped(_ sender: Any) {
        let sheet = UIAlertController(title: "Subir foto de identificación de atrás", message: nil, preferredStyle: .actionSheet)
                     let cameraAction = UIAlertAction(title: "Cámara", style: .default, handler: { _ in
                         self.openCameraPickerForBackId()
                     })
                     
                     let galleryAction = UIAlertAction(title: "Galería de fotos", style: .default, handler: { _ in
                         self.openGalleryPickerForBackId()
                     })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                     
                     sheet.addAction(cameraAction)
                     sheet.addAction(galleryAction)
        sheet.addAction(cancelAction)
                     present(sheet,animated: true, completion: nil)
    }
    
    
    @IBAction func completeAccountTapped(_ sender: Any) {
        let realm = try! Realm()
        let session = realm.objects(Session.self)
        MyStripeApiClient.sharedClient.completeAccount(accountId: self.stripeAccountId,accountParams: self.accountParams, token: session.first!.token) { (result) in
            switch result {
            case .success(let string):
                print("\(string)")
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension AssociateStripeAccountViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
          switch textField {
          case nameTextField:
            accountParams["name"] = self.nameTextField.text!
          case lastNameTextField:
            accountParams["last_name"] = self.lastNameTextField.text!
          case cellphoneTextField:
            accountParams["phone"] = self.cellphoneTextField.text!
          case emailTextField:
            accountParams["email"] = self.emailTextField.text!
          case streetAndNumberTextField:
            self.address.line1 = self.streetAndNumberTextField.text!
          case districtTextField:
            self.address.town = self.districtTextField.text!
          case zipCodeTextField:
            self.address.postalCode = self.zipCodeTextField.text!
          default:
              return
          }
      }
}
extension AssociateStripeAccountViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func openCameraPickerForFrontId() {
        frontImagePicker = UIImagePickerController()
        frontImagePicker.modalPresentationStyle = .overFullScreen
        frontImagePicker.delegate = self
        frontImagePicker.sourceType = .camera
        
        present(frontImagePicker, animated: true, completion: nil)
    }
    
    func openCameraPickerForBackId() {
        backImagePicker = UIImagePickerController()
        backImagePicker.modalPresentationStyle = .overFullScreen
        backImagePicker.delegate = self
        backImagePicker.sourceType = .camera
        
        present(backImagePicker, animated: true, completion: nil)
    }
    
    func openGalleryPickerForFrontId() {
        frontImagePicker = UIImagePickerController()
        frontImagePicker.modalPresentationStyle = .overFullScreen
        frontImagePicker.delegate = self
        frontImagePicker.allowsEditing = true

        frontImagePicker.sourceType = .photoLibrary
        
        present(frontImagePicker, animated: true, completion: nil)
    }
    
    func openGalleryPickerForBackId() {
        backImagePicker = UIImagePickerController()
        backImagePicker.modalPresentationStyle = .overFullScreen
        backImagePicker.delegate = self
        backImagePicker.allowsEditing = true

        backImagePicker.sourceType = .photoLibrary
        
        present(backImagePicker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        switch picker {
        case frontImagePicker:
            frontImagePicker.dismiss(animated: true, completion: nil)
            self.frontIdImageView.image = info[.originalImage] as! UIImage?
        case backImagePicker:
            backImagePicker.dismiss(animated: true, completion: nil)
            self.backIdImageView.image = info[.originalImage] as! UIImage?
        default:
            break
        }
    }
}
