//
//  CustomPaymentCardFieldCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 18/06/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit
import Stripe

protocol CustomPaymentCardFieldCellDelegate {
    func didBeginEditingCVC()
    func didEndEditingCVC()
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField)
}

class CustomPaymentCardFieldCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    
    let cardField = STPPaymentCardTextField()
    var delegate: CustomPaymentCardFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardField.postalCodeEntryEnabled = false
        stackView.addArrangedSubview(cardField)
        cardField.delegate = self
    }
}

// MARK: STPPaymentCardTextFieldDelegate
extension CustomPaymentCardFieldCell: STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        delegate?.didBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        delegate?.didEndEditingCVC()
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        delegate?.paymentCardTextFieldDidChange(textField: textField)
    }
}
