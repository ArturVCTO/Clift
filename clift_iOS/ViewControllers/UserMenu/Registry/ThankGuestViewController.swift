//
//  ThankGuestViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/24/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import DropDown

class ThankGuestViewController: UIViewController {
    @IBOutlet weak var giftImage: UIImageView!
    @IBOutlet weak var giftName: UILabel!
    @IBOutlet weak var giftShop: UILabel!
    @IBOutlet weak var giftPrice: UILabel!
    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var giftMessageTextField: HoshiTextField!
    var thankMessage: ThankMessage? = nil
    var gift: EventProduct?
    var emailersDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.giftMessageTextField.delegate = self
        self.getGiftInformation(gift: self.gift!)
    }
    
    func loadDropDownInfo(string: [String]) {
        var dataSourceDropdown = [String]()
        emailersDropDown.anchorView = self.giftButton
        
        for string in string {
            dataSourceDropdown.append(string)
        }
        emailersDropDown.dataSource = dataSourceDropdown
        emailersDropDown.bottomOffset = CGPoint(x: 0, y: giftButton.bounds.height)
        
        emailersDropDown.selectionAction = { [weak self] (index, item) in
            self!.giftButton.setTitle(item, for: .normal)
            self?.thankMessage?.email = string[index]
        }
    }
    
    func getGiftInformation(gift: EventProduct) {
//        self.giftImage.image = gift.image
//        self.giftName.text = gift.giftName
//        self.giftShop.text = gift.shop
//        self.giftPrice.text = "\(gift.giftPrice)"
//        self.loadDropDownInfo(string: gift.giftersEmail)
    }
    
    func sendThankMessage(thankMessage: ThankMessage, event: Event,eventProduct: EventProduct) {
        sharedApiManager.sendThankMessage(thankMessage: thankMessage, event: event, eventProduct: eventProduct) { (emptyObject, result) in
            if let response = result {
                if response.isSuccess() {
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController!.showMessage("Mensaje enviado con éxito", type: .success)
                } else if response.isClientError() {
                    self.showMessage("Hubo un error enviando el correo.", type: .error)
                } else {
                    self.showMessage("Hubo un error enviando el correo.", type: .error)
                }
            }
        }
    }
    
    @IBAction func sendMessageTapped(_ sender: Any) {
        
    }
    
    @IBAction func giftersEmailButtonTapped(_ sender: Any) {
        self.emailersDropDown.show()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ThankGuestViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.thankMessage?.thankMessage = giftMessageTextField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
       return true
    }
}
