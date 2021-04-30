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
    var thankMessage = ThankMessage()
    var gift: EventProduct?
    var orderItem = OrderItem()
    var event: Event?
    var emailersDropDown = DropDown()
    var selectedFilter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        giftMessageTextField.delegate = self
        getGiftInformation(gift: gift!)
        giftButton.setTitle(orderItem.guestData.email, for: .normal)
        thankMessage.email.append(orderItem.guestData.email)
        thankMessage.name.append(orderItem.guestData.name)
    }
    
    func loadDropDownInfo(gifters: [String]) {
        var dataSourceDropdown = [String]()
        emailersDropDown.anchorView = self.giftButton
        
        for gifter in gifters {
            dataSourceDropdown.append(gifter)
        }
        emailersDropDown.dataSource = dataSourceDropdown
        emailersDropDown.bottomOffset = CGPoint(x: 0, y: giftButton.bounds.height)
        
        emailersDropDown.selectionAction = { [weak self] (index, item) in
            self!.giftButton.setTitle(item, for: .normal)
            //self?.thankMessage.email = gifters[index]
        }
    }
    
    func getPriceStringFormat(value: Double) -> String {
       let formatter = NumberFormatter()
       formatter.numberStyle = .currency
       
       return formatter.string(from: NSNumber(value: value))!
     }
    
    func getGiftInformation(gift: EventProduct) {
       if let imageURL = URL(string:"\(gift.product.imageUrl)") {
            self.giftImage.kf.setImage(with: imageURL)
        }
        self.giftName.text = gift.product.name
        self.giftShop.text = gift.product.shop.name
        self.giftPrice.text = "\(getPriceStringFormat(value: Double(gift.product.price)))"
        //self.loadDropDownInfo(gifters: [gift.thankYouUser!.email!])
    }
    
    func sendThankMessage(thankMessage: ThankMessage, event: Event,orderItem: OrderItem) {
        sharedApiManager.sendThankMessage(thankMessage: thankMessage, event: event, orderItem: orderItem) { (emptyObject, result) in
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
        thankMessage.thankMessage = giftMessageTextField.text
        self.sendThankMessage(thankMessage: self.thankMessage, event: (self.event)!, orderItem: orderItem)
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
        //self.thankMessage.thankMessage = giftMessageTextField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
       textField.resignFirstResponder()
       return true
    }
}
