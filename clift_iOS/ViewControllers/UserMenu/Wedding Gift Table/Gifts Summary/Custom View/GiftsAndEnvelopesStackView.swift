//
//  GiftsAndEnvelopesStackView.swift
//  clift_iOS
//
//  Created by David Mar on 3/18/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit

protocol GiftsAndEvelopStackViewDelegate: AnyObject {
    func giftsSelected()
    func envelopeSelected()
}

class GiftsAndEnvelopesStackView: UIStackView {
    
    var giftsButtonSelected = true
    weak var delegate: GiftsAndEvelopStackViewDelegate?
    
    @IBOutlet weak var giftsButton: UIButton! {
        didSet {
            guard let giftsButton = giftsButton else { return }
            giftsButton.setTitle("REGALOS", for: .normal)
            giftsButton.layer.cornerRadius = 8
            selectButton(button: giftsButton)
        }
    }
    @IBOutlet weak var envelopesButton: UIButton! {
        didSet {
            guard let envelopesButton = envelopesButton else { return }
            envelopesButton.setTitle("SOBRES", for: .normal)
            envelopesButton.layer.cornerRadius = 8
            unselectButton(button: envelopesButton)
        }
    }
    
    private func unselectButton(button: UIButton) {
        button.backgroundColor = .white
        button.titleLabel?.addCharactersSpacing(2)
        button.setTitleColor(UIColor(red: 163/255, green: 199/255, blue: 235/255, alpha: 1), for: .normal)
        button.layer.borderColor = UIColor(red: 163/255, green: 199/255, blue: 235/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
    }
    
    private func selectButton(button: UIButton) {
        button.backgroundColor = UIColor(red: 163/255, green: 199/255, blue: 235/255, alpha: 1)
        button.titleLabel?.addCharactersSpacing(2)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor(red: 163/255, green: 199/255, blue: 235/255, alpha: 1).cgColor
    }
    
    @IBAction func giftsButtonPressed(_ sender: Any) {
        guard giftsButtonSelected == false else { return }
        delegate?.giftsSelected()
        selectButtons()
        giftsButtonSelected = true
    }
    
    @IBAction func envelopesButtonPressed(_ sender: Any) {
        guard giftsButtonSelected == true else { return }
        delegate?.envelopeSelected()
        selectButtons()
        giftsButtonSelected = false
    }
    
    private func selectButtons() {
        if giftsButtonSelected {
            unselectButton(button: giftsButton)
            selectButton(button: envelopesButton)
        } else {
            selectButton(button: giftsButton)
            unselectButton(button: envelopesButton)
        }
    }
    
}
