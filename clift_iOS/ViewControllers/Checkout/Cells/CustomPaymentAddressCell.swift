//
//  CustomPaymentAddressCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 18/06/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

enum StripeBillingInformation: String {
    case name = "Nombre"
    case email = "Correo electrónico"
    case cellphoneNumber = "Celular"
    case address = "Dirección"
    case ZIP = "Código postal"
    case city = "Ciudad"
    case state = "Estado"
    case none = "None"
}

protocol CustomPaymentAddressCellDelegate {
    func userTyping(type: StripeBillingInformation, value: String)
}

class CustomPaymentAddressCell: UITableViewCell {

    @IBOutlet weak var addressInfoTextField: UITextField!
    
    var currentCellType: StripeBillingInformation?
    var delegate: CustomPaymentAddressCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addressInfoTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
    }
    
    func configure(type: StripeBillingInformation) {
        currentCellType = type
        addressInfoTextField.placeholder = type.rawValue
    }
    
    @objc func textDidChange(sender: AnyObject) {
        delegate?.userTyping(type: currentCellType ?? .none, value: addressInfoTextField.text ?? "")
    }
}
