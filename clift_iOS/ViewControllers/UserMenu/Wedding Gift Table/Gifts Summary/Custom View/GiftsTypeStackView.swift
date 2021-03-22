//
//  GiftsTypeStackView.swift
//  clift_iOS
//
//  Created by David Mar on 3/18/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit

protocol GiftsTypeStackViewProtocol: AnyObject {
    func allSelected()
    func requestedSelected()
    func creditSelected()
    func collaborativeSelected()
}

class GiftsTypeStackView: UIStackView {
    
    @IBOutlet weak var allButton: UIButton! {
        didSet {
            selectedButton = allButton
            setButton(button: allButton, text: "TODOS")
        }
    }
    @IBOutlet weak var requestedButton: UIButton! {
        didSet {
            setButton(button: requestedButton, text: "SOLICITADOS")
        }
    }
    @IBOutlet weak var creditButton: UIButton! {
        didSet {
            setButton(button: creditButton, text: "CREDITO")
        }
    }
    @IBOutlet weak var collaborativeButton: UIButton! {
        didSet {
            setButton(button: collaborativeButton, text: "COLABORATIVO")
        }
    }
    weak var delegate: GiftsTypeStackViewProtocol!
    
    private weak var selectedButton: UIButton! {
        didSet {
            unselectAllButtons()
            selectButton(button: selectedButton)
        }
    }
    
    private func unselectAllButtons() {
        unselectButton(button: allButton)
        unselectButton(button: requestedButton)
        unselectButton(button: creditButton)
        unselectButton(button: collaborativeButton)
    }
    
    private func setButton(button: UIButton, text: String) {
        button.setTitle(text.uppercased(), for: .normal)
    }
    
    private func selectButton(button: UIButton) {
        button.titleLabel?.underline()
    }
    
    private func unselectButton(button: UIButton?) {
        button?.titleLabel?.deleteUnderline()
    }
    
    @IBAction func allButtonPressed(_ sender: Any) {
        guard selectedButton != allButton else { return }
        selectAllButton()
        delegate?.allSelected()
    }
    
    func selectAllButton() {
        selectedButton = allButton
    }
    
    @IBAction func requestedButtonPressed(_ sender: Any) {
        guard selectedButton != requestedButton else { return }
        selectedButton = requestedButton
        delegate?.requestedSelected()
    }
    
    @IBAction func creditButtonPressed(_ sender: Any) {
        guard selectedButton != creditButton else { return }
        selectedButton = creditButton
        delegate?.creditSelected()
    }
    
    @IBAction func collaborativeButtonPressed(_ sender: Any) {
        guard selectedButton != collaborativeButton else { return }
        selectedButton = collaborativeButton
        delegate?.collaborativeSelected()
    }
    
}
