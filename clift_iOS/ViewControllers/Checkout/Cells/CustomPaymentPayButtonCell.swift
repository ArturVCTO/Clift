//
//  CustomPaymentPayButtonCell.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 26/06/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

protocol CustomPaymentPayButtonCellDelegate {
    func didTapPayButton()
}

class CustomPaymentPayButtonCell: UITableViewCell {

    var delegate: CustomPaymentPayButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(delegate: CustomPaymentPayButtonCellDelegate) {
        self.delegate = delegate
    }
    
    @IBAction func didTapPayButton(_ sender: UIButton) {
        delegate?.didTapPayButton()
    }
}
