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

enum ThankType {
    case SummaryProduct
    case Envelope
}

class ThankGuestViewController: UIViewController {
    @IBOutlet weak var giftImage: UIImageView!
    @IBOutlet weak var giftName: UILabel!
    @IBOutlet weak var giftShop: UILabel!
    @IBOutlet weak var giftPrice: UILabel!
    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var giftMessageTextField: HoshiTextField!
    var thankMessage = ThankMessage()
    var thankEnvelopeMessage = ThankEnvelopeMessage()
    var gift = EventProduct()
    var orderItem = OrderItem()
    var event: Event?
    var emailersDropDown = DropDown()
    var selectedFilter = 0
    var thankType: ThankType = .SummaryProduct
    var cashGiftItem = CashGiftItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        giftMessageTextField.delegate = self
        fillMessageInfo()
    }
    
    func fillMessageInfo() {
        if thankType == .SummaryProduct {
            getGiftInformation(gift: gift)
            giftButton.setTitle(orderItem.guestData.email, for: .normal)
            thankMessage.email.append(orderItem.guestData.email)
            thankMessage.name.append(orderItem.guestData.name)
        } else {
            getGiftInformation(gift: cashGiftItem)
            giftButton.setTitle(cashGiftItem.order.userData.email, for: .normal)
            thankEnvelopeMessage.email = cashGiftItem.order.userData.email
            thankEnvelopeMessage.name = cashGiftItem.order.userData.name
        }
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
    
    func getGiftInformation(gift: CashGiftItem) {

        giftImage.image = UIImage(named: "cashFund")
        self.giftName.text = "Sobre"
        self.giftShop.text = "\(gift.order.userData.name) \(gift.order.userData.lastName)"
        self.giftPrice.text = "\(getPriceStringFormat(value: Double(gift.amount) ?? 0.0))"
    }
    
    func sendThankMessage(thankMessage: ThankMessage, event: Event, orderItem: OrderItem) {
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
    
    func sendThankEnvelopeMessage(thankEnvelopeMessage: ThankEnvelopeMessage, event: Event, cashGiftItem: CashGiftItem) {
        sharedApiManager.sendThankEnvelopeMessage(thankEnvelopeMessage: thankEnvelopeMessage, event: event, cashGiftItem: cashGiftItem) { (emptyObject, result) in
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
        if thankType == .SummaryProduct {
            thankMessage.thankMessage = giftMessageTextField.text
            sendThankMessage(thankMessage: self.thankMessage, event: event!, orderItem: orderItem)
        } else {
            thankEnvelopeMessage.thankMessage = giftMessageTextField.text
            sendThankEnvelopeMessage(thankEnvelopeMessage: thankEnvelopeMessage, event: event!, cashGiftItem: cashGiftItem)
        }
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
