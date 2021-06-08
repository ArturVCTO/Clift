//
//  InvitationEditFormTableViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/25/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import DropDown

class InvitationEditFormTableViewController: UITableViewController {
    
    var eventDayPickerIsHidden = true
    var ceremonyHourPickerIsHidden = true
    var receptionHourPickerIsHidden = true
    var typesOfDressCode = ["Semiformal", "Formal", "Etiqueta", "Guayabera/Playa"]
    var invitationVC: InvitationViewController!
    var invitationTemplate = InvitationTemplate()
    var hasNotEdited = false
    var eventInformation = Event()
    
    @IBOutlet weak var invitationImageViewBG: UIImageView!
    @IBOutlet weak var invitationView: UIView!
    @IBOutlet weak var eventDayLabelButton: UILabel!
    @IBOutlet weak var ceremonyHourLabelButton: UILabel!
    @IBOutlet weak var receptionHourLabelButton: UILabel!
    
    @IBOutlet weak var maximumCharacterLabel: UILabel!
    
    @IBOutlet var invitationFormTableView: UITableView!
    @IBOutlet weak var eventDayPicker: UIDatePicker!
    @IBOutlet weak var ceremonyHourPicker: UIDatePicker!
    @IBOutlet weak var receptionHourPicker: UIDatePicker!
    
    
//    Invitation WYSIWYG labels
    @IBOutlet weak var shortMessageWSIWYGLabel: UILabel!
    @IBOutlet weak var yourNameWSIWYGLabel: UILabel!
    @IBOutlet weak var yourCoupleWSIWYGLabel: UILabel!
    @IBOutlet weak var eventDateWSIWYGLabel: UILabel!
    @IBOutlet weak var ceremonyNameWYSIWYGLabel: UILabel!
    @IBOutlet weak var ceremonyAddressWYSIWYGLabel: UILabel!
    @IBOutlet weak var ceremonyHourWYSIWYGLabel: UILabel!
    @IBOutlet weak var dressCodeWYSIWYGLabel: UILabel!
    @IBOutlet weak var receptionNameWYSIWYGLabel: UILabel!
    @IBOutlet weak var receptionAddressWYSIWYGLabel: UILabel!
    @IBOutlet weak var receptionHourWYSIWYGLabel: UILabel!
    
    @IBOutlet weak var yourFatherLabel: UILabel!
    
    @IBOutlet weak var yourMotherLabel: UILabel!
    
    @IBOutlet weak var coupleFatherLabel: UILabel!
    
    @IBOutlet weak var coupleMotherLabel: UILabel!
    //    Text field
    @IBOutlet weak var shortMessageTextField: HoshiTextField!
    @IBOutlet weak var yourNameTextField: HoshiTextField!
    @IBOutlet weak var yourCoupleNameTextField: HoshiTextField!
    @IBOutlet weak var ceremonyPlaceNameTextField: HoshiTextField!
    @IBOutlet weak var ceremonyAddressTextField: HoshiTextField!
    @IBOutlet weak var receptionNameTextField: HoshiTextField!
    @IBOutlet weak var receptionAddressTextField: HoshiTextField!
    @IBOutlet weak var yourFatherTextField: HoshiTextField!
    @IBOutlet weak var yourMotherTextField: HoshiTextField!
    
    @IBOutlet weak var coupleFatherTextField: HoshiTextField!
    @IBOutlet weak var coupleMotherTextField: HoshiTextField!
    
    
    let dressCodeDropDown = DropDown()
    @IBOutlet weak var dressCodeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.invitationFormTableView.delegate = self
        self.invitationFormTableView.dataSource = self
        self.shortMessageTextField.delegate = self
        self.yourNameTextField.delegate = self
        self.yourCoupleNameTextField.delegate = self
        self.ceremonyAddressTextField.delegate = self
        self.ceremonyPlaceNameTextField.delegate = self
        self.receptionNameTextField.delegate = self
        self.receptionAddressTextField.delegate = self
        self.yourFatherTextField.delegate = self
        self.yourMotherTextField.delegate = self
        self.coupleMotherTextField.delegate = self
        self.coupleFatherTextField.delegate = self
        self.setupDropDownStyle()
        self.setupDressCodeDD(typesOfDressCode: typesOfDressCode)
        self.setupTemplateArrangement()
        self.setupEventInformation(event: self.eventInformation)
        self.yourNameWSIWYGLabel.adjustsFontSizeToFitWidth = true
        self.yourCoupleWSIWYGLabel.adjustsFontSizeToFitWidth = true
        self.shortMessageWSIWYGLabel.adjustsFontSizeToFitWidth = true
        self.yourFatherLabel.adjustsFontSizeToFitWidth = true
        self.yourMotherLabel.adjustsFontSizeToFitWidth = true
        self.coupleFatherLabel.adjustsFontSizeToFitWidth = true
        self.coupleMotherLabel.adjustsFontSizeToFitWidth = true
        self.ceremonyNameWYSIWYGLabel.adjustsFontSizeToFitWidth = true
        self.ceremonyAddressWYSIWYGLabel.adjustsFontSizeToFitWidth = true
        self.receptionNameWYSIWYGLabel.adjustsFontSizeToFitWidth = true
        self.receptionAddressWYSIWYGLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.shortMessageTextField.becomeFirstResponder()
    }
    
    func setupDropDownStyle() {
        let appearance = DropDown.appearance()
        appearance.cornerRadius = 4
        appearance.cellHeight = 40
    }
    
    func setupEventInformation(event: Event) {
        self.yourNameTextField.text = event.invitation.creatorName
        self.yourNameWSIWYGLabel.text = event.invitation.creatorName
        
        
        self.yourCoupleNameTextField.text = event.invitation.spouseName
        self.yourCoupleWSIWYGLabel.text = event.invitation.spouseName
        
        self.shortMessageTextField.text = event.invitation.message
        self.shortMessageWSIWYGLabel.text = event.invitation.message
        
        self.ceremonyAddressTextField.text = event.invitation.locationCeremonyUrl
        self.ceremonyAddressWYSIWYGLabel.text = event.invitation.locationCeremonyUrl
        
        self.ceremonyPlaceNameTextField.text = event.invitation.ceremonyPlace
        self.ceremonyNameWYSIWYGLabel.text = event.invitation.ceremonyPlace
        
        self.receptionNameTextField.text = event.invitation.receptionPlace
        self.receptionNameWYSIWYGLabel.text = event.invitation.receptionPlace
        
        self.receptionAddressTextField.text = event.invitation.locationReceptionUrl
        self.receptionAddressWYSIWYGLabel.text = event.invitation.locationReceptionUrl
        
        if event.invitation.hasInvitedRelatives {
            self.yourFatherTextField.isHidden = false
                       self.yourMotherTextField.isHidden = false
                       self.coupleMotherTextField.isHidden = false
                       self.coupleFatherTextField.isHidden = false
                       self.invitationFormTableView.performBatchUpdates(nil, completion: nil)
        } else {
            self.yourFatherTextField.isHidden = true
                       self.yourMotherTextField.isHidden = true
                       self.coupleMotherTextField.isHidden = true
                       self.coupleFatherTextField.isHidden = true
                       self.invitationFormTableView.performBatchUpdates(nil, completion: nil)
        }
        
        switch event.invitation.dressCode {
        case 0:
            self.dressCodeWYSIWYGLabel.text = "Vestimenta: Semiformal"
            self.dressCodeButton.setTitle("Vestimenta: Semiformal", for: .normal)
        case 1:
            self.dressCodeWYSIWYGLabel.text = "Vestimenta: Formal"
            self.dressCodeButton.setTitle("Vestimenta: Formal", for: .normal)
        case 2:
            self.dressCodeWYSIWYGLabel.text = "Vestimenta: Etiqueta"
            self.dressCodeButton.setTitle("Vestimenta: Etiqueta", for: .normal)
        case 3:
            self.dressCodeWYSIWYGLabel.text = "Vestimenta: Guayabera/Playa"
            self.dressCodeButton.setTitle("Vestimenta: Guayabera/Playa", for: .normal)
        default:
            self.dressCodeWYSIWYGLabel.text = "Vestimenta:"
            self.dressCodeButton.setTitle("Vestimenta:", for: .normal)
        }
    }
    
    func setupTemplateArrangement() {
        if invitationTemplate.templateArrangement == 1 {
            self.invitationImageViewBG.image = UIImage(named: "Clift_Invitaciones_Type_BG_1")
            self.shortMessageWSIWYGLabel.frame = CGRect(x: 67, y: 20, width: 176, height: 34)
            self.shortMessageWSIWYGLabel.textAlignment = .center
            self.yourNameWSIWYGLabel.frame = CGRect(x: 8, y: 96, width: 287, height: 23)
            self.yourNameWSIWYGLabel.textAlignment = .center
            self.yourNameWSIWYGLabel.textColor = UIColor(displayP3Red: 164/255, green: 118/255, blue: 77/255, alpha: 1.0)
            self.yourCoupleWSIWYGLabel.textColor = UIColor(displayP3Red: 164/255, green: 118/255, blue: 77/255, alpha: 1.0)
            self.yourCoupleWSIWYGLabel.frame = CGRect(x: 8, y: 125, width: 287, height: 23)
            self.yourCoupleWSIWYGLabel.textAlignment = .center
            self.yourFatherLabel.frame = CGRect(x: 8, y: 53, width: 138, height: 11)
            self.yourFatherLabel.textAlignment = .left
            self.yourMotherLabel.frame = CGRect(x: 8, y: 65, width: 138, height: 11)
            self.yourMotherLabel.textAlignment = .left
            self.coupleFatherLabel.frame = CGRect(x: 181, y: 53, width: 114, height: 11)
            self.coupleMotherLabel.frame = CGRect(x: 181, y: 65, width: 114, height: 11)
            self.dressCodeWYSIWYGLabel.frame = CGRect(x: 66,y:282,width: 170, height: 13)
            self.dressCodeWYSIWYGLabel.textAlignment = .center
            self.eventDateWSIWYGLabel.frame = CGRect(x: 58, y: 180, width: 187, height: 16)
            self.eventDateWSIWYGLabel.textAlignment = .center
            
            self.ceremonyNameWYSIWYGLabel.frame = CGRect(x: 8, y: 205, width: 138, height: 10)
            self.ceremonyNameWYSIWYGLabel.textAlignment = .center
            
            self.ceremonyAddressWYSIWYGLabel.frame = CGRect(x: 8, y: 218, width: 138, height: 22.5)
            self.ceremonyAddressWYSIWYGLabel.textAlignment = .center
            
            self.ceremonyHourWYSIWYGLabel.frame = CGRect(x: 24, y: 241, width: 106, height: 10)
            self.ceremonyHourWYSIWYGLabel.textAlignment = .center
            
            self.receptionNameWYSIWYGLabel.frame = CGRect(x: 157, y: 205, width: 138, height: 10)
            self.receptionNameWYSIWYGLabel.textAlignment = .center
            
            self.receptionAddressWYSIWYGLabel.frame = CGRect(x: 157, y: 218, width: 138, height: 22.5)
            self.receptionAddressWYSIWYGLabel.textAlignment = .center
            
            self.receptionHourWYSIWYGLabel.frame = CGRect(x: 173, y: 241, width: 106, height: 9)
            self.receptionHourWYSIWYGLabel.textAlignment = .center
        }else if invitationTemplate.templateArrangement == 2 {
            self.invitationImageViewBG.image = UIImage(named: "Clift_Invitaciones_Type_BG_4")
            self.shortMessageWSIWYGLabel.frame = CGRect(x: 16, y: 132, width: 175, height: 33)
            self.shortMessageWSIWYGLabel.textAlignment = .left
            self.yourNameWSIWYGLabel.frame = CGRect(x: 16, y: 74, width: 287, height: 19)
            self.yourNameWSIWYGLabel.textAlignment = .left
            self.yourCoupleWSIWYGLabel.frame = CGRect(x: 16, y: 101, width: 287, height: 19)
            self.yourCoupleWSIWYGLabel.textAlignment = .left
            self.yourFatherLabel.frame = CGRect(x: 16, y: 177, width: 138, height: 11)
            self.yourFatherLabel.textAlignment = .left
              self.yourMotherLabel.frame = CGRect(x: 16, y: 189, width: 138, height: 11)
              self.yourMotherLabel.textAlignment = .left
              self.coupleFatherLabel.frame = CGRect(x: 189, y: 177, width: 114, height: 11)
              self.coupleMotherLabel.frame = CGRect(x: 189, y: 189, width: 114, height: 11)
              self.dressCodeWYSIWYGLabel.frame = CGRect(x: 66,y:315,width: 170, height: 13)
              self.dressCodeWYSIWYGLabel.textAlignment = .center
              self.eventDateWSIWYGLabel.frame = CGRect(x: 16, y: 207, width: 187, height: 16)
              self.eventDateWSIWYGLabel.textAlignment = .left
              
              self.ceremonyNameWYSIWYGLabel.frame = CGRect(x: 16, y: 231, width: 138, height: 10)
              self.ceremonyNameWYSIWYGLabel.textAlignment = .left
              
              self.ceremonyAddressWYSIWYGLabel.frame = CGRect(x: 16, y: 244, width: 138, height: 22.5)
              self.ceremonyAddressWYSIWYGLabel.textAlignment = .left
              
              self.ceremonyHourWYSIWYGLabel.frame = CGRect(x: 16, y: 267, width: 127, height: 10)
              self.ceremonyHourWYSIWYGLabel.textAlignment = .left
              
              self.receptionNameWYSIWYGLabel.frame = CGRect(x: 165, y: 231, width: 138, height: 10)
              self.receptionNameWYSIWYGLabel.textAlignment = .left
              
              self.receptionAddressWYSIWYGLabel.frame = CGRect(x: 165, y: 244, width: 138, height: 22.5)
              self.receptionAddressWYSIWYGLabel.textAlignment = .left
              
              self.receptionHourWYSIWYGLabel.frame = CGRect(x: 165, y: 267, width: 122, height: 9)
              self.receptionHourWYSIWYGLabel.textAlignment = .left
        }
    }
    
    func setupDressCodeDD(typesOfDressCode: [String]) {
        var dataSourceDropDown = [String]()
        dressCodeDropDown.anchorView = self.dressCodeButton
        
        for type in typesOfDressCode {
            dataSourceDropDown.append(type)
        }
        
        dressCodeDropDown.dataSource = dataSourceDropDown
        dressCodeDropDown.bottomOffset = CGPoint(x:0, y: self.dressCodeButton.bounds.height)
        
        dressCodeDropDown.selectionAction = { [weak self] (index, item) in
            self!.dressCodeButton.setTitle(item, for: .normal)
            self!.dressCodeWYSIWYGLabel.text = "\(item)"
        }
    }
    
    @IBAction func eventDayButtonTapped(_ sender: Any) {
        if self.eventDayPickerIsHidden == true {
            self.eventDayPickerIsHidden = false
            self.eventDayPicker.isHidden = false
            self.invitationFormTableView.performBatchUpdates(nil, completion: nil)
        } else {
            self.eventDayPickerIsHidden = true
            self.eventDayPicker.isHidden = true
            self.invitationFormTableView.performBatchUpdates(nil, completion: nil)
        }
        
    }
    
    @IBAction func ceremonyHourPicker(_ sender: Any) {
        if self.ceremonyHourPickerIsHidden == true {
            self.ceremonyHourPickerIsHidden = false
            self.ceremonyHourPicker.isHidden = false
            self.invitationFormTableView.performBatchUpdates(nil, completion: nil)
        } else {
            self.ceremonyHourPickerIsHidden = true
            self.ceremonyHourPicker.isHidden = true
            self.invitationFormTableView.performBatchUpdates(nil, completion: nil)
        }
    }
    
    @IBAction func receptionHourPicker(_ sender: Any) {
        if self.receptionHourPickerIsHidden == true {
            self.receptionHourPickerIsHidden = false
            self.receptionHourPicker.isHidden = false
            self.invitationFormTableView.performBatchUpdates(nil, completion: nil)
        } else {
            self.receptionHourPickerIsHidden = true
            self.receptionHourPicker.isHidden = true
            self.invitationFormTableView.performBatchUpdates(nil, completion: nil)
        }
    }
    
    
    @IBAction func hasInvitedRelativesSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.yourFatherTextField.isHidden = false
            self.yourMotherTextField.isHidden = false
            self.coupleMotherTextField.isHidden = false
            self.coupleFatherTextField.isHidden = false
            self.invitationFormTableView.performBatchUpdates(nil, completion: nil)
        } else {
            self.yourFatherTextField.isHidden = true
            self.yourMotherTextField.isHidden = true
            self.coupleMotherTextField.isHidden = true
            self.coupleFatherTextField.isHidden = true
            self.invitationFormTableView.performBatchUpdates(nil, completion: nil)
        }
    }
    
    
    @IBAction func eventDayPickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale
        var formattedDate: String = ""
        dateFormatter.dateFormat = "dd MMMM yyyy"
        formattedDate = dateFormatter.string(from: self.eventDayPicker.date)
        self.eventDateWSIWYGLabel.text = formattedDate
        self.eventDayLabelButton.text = formattedDate
    }
    
    
    @IBAction func ceremonyHourPickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale
        var formattedDate: String = ""
        dateFormatter.dateFormat = "HH:mm"
        formattedDate = dateFormatter.string(from: self.ceremonyHourPicker.date)
        self.ceremonyHourWYSIWYGLabel.text = formattedDate
        self.ceremonyHourLabelButton.text = formattedDate
       
    }
    
    
    
    @IBAction func receptionHourPickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale
        var formattedDate: String = ""
        dateFormatter.dateFormat = "HH:mm"
        formattedDate = dateFormatter.string(from: self.receptionHourPicker.date)
        self.receptionHourWYSIWYGLabel.text = formattedDate
        self.receptionHourLabelButton.text = formattedDate
       
    }
    
    @IBAction func dressCodeButtonTapped(_ sender: Any) {
        self.dressCodeDropDown.show()
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension InvitationEditFormTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == yourNameTextField {
            yourNameWSIWYGLabel.text = yourNameTextField.text!
            self.invitationVC.invitation.creatorName = yourNameTextField.text!
        } else if textField == shortMessageTextField {
            shortMessageWSIWYGLabel.text = shortMessageTextField.text!
            self.maximumCharacterLabel.text = "\(120 - shortMessageTextField.text!.count) caracteres máximo"
            self.invitationVC.invitation.message = shortMessageTextField.text!
        } else if textField == yourCoupleNameTextField {
            yourCoupleWSIWYGLabel.text = yourCoupleNameTextField.text!
            self.invitationVC.invitation.spouseName = yourCoupleNameTextField.text!
        
        } else if textField == ceremonyAddressTextField {
            ceremonyAddressWYSIWYGLabel.text = ceremonyAddressTextField.text!
            self.invitationVC.invitation.locationCeremonyUrl = ceremonyAddressTextField.text!
        } else if textField == ceremonyPlaceNameTextField {
            ceremonyNameWYSIWYGLabel.text = ceremonyPlaceNameTextField.text!
            self.invitationVC.invitation.ceremonyPlace = ceremonyPlaceNameTextField.text!
        } else if textField == receptionNameTextField {
            receptionNameWYSIWYGLabel.text = receptionNameTextField.text!
            self.invitationVC.invitation.receptionPlace = receptionNameTextField.text!
        } else if textField == receptionAddressTextField {
            receptionAddressWYSIWYGLabel.text = receptionAddressTextField.text!
            self.invitationVC.invitation.locationReceptionUrl = receptionAddressTextField.text!
        } else if textField == yourFatherTextField {
            yourFatherLabel.text = yourFatherTextField.text!
            self.invitationVC.invitation.relativeOne = yourFatherTextField.text!
        } else if textField == yourMotherTextField {
            yourMotherLabel.text = yourMotherTextField.text!
            self.invitationVC.invitation.relativeTwo = yourMotherTextField.text!
        } else if textField == coupleFatherTextField {
            coupleFatherLabel.text = coupleFatherTextField.text!
            self.invitationVC.invitation.relativeThree = coupleFatherTextField.text!
        }else if textField == coupleMotherTextField {
            coupleMotherLabel.text = coupleMotherTextField.text!
            self.invitationVC.invitation.relativeFour = coupleMotherTextField.text!
        }
        return true
    }
    
    func hideKeyboard(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard(textField: textField)
        
        return true
    }
}

