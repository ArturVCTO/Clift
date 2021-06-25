//
//  CustomPaymentCardViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 17/06/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit
import Stripe

protocol CustomPaymentCardViewControllerDelegate {
    func CustomPaymentCardViewControllerDidCancel()
    func CustomPaymentCardViewControllerDidPay(billingDetails: STPPaymentMethodBillingDetails, methodCardParams: STPPaymentMethodCardParams)
}

class CustomPaymentCardViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var referenceCustomPaymentCardImageCell: CustomPaymentCardImageCell?
    var addressFieldsArray: [StripeBillingInformation] = [.name,.email,.cellphoneNumber,.address,.ZIP,.city,.state]
    var billingDetails = STPPaymentMethodBillingDetails()
    let address = STPPaymentMethodAddress()
    var methodCardParams = STPPaymentMethodCardParams()
    var delegate: CustomPaymentCardViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        registerCells()
        setNavBar()
        address.country = "MX"
    }
    
    private func setTableView() {
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    private func registerCells() {
        tableview.register(UINib(nibName: "CustomPaymentCardImageCell", bundle: nil), forCellReuseIdentifier: "CustomPaymentCardImageCell")
        tableview.register(UINib(nibName: "CustomPaymentCardFieldCell", bundle: nil), forCellReuseIdentifier: "CustomPaymentCardFieldCell")
        tableview.register(UINib(nibName: "CustomPaymentAddressCell", bundle: nil), forCellReuseIdentifier: "CustomPaymentAddressCell")
    }
    
    private func setNavBar() {
        
        let titleLabel = UILabel()
        titleLabel.text = "Pago"
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Mihan-Regular", size: 16.0)!
        titleLabel.addCharactersSpacing(5)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(didTapCancel(sender:)))
        let doneButton = UIBarButtonItem(title: "Pagar", style: .done, target: self, action: #selector(didTapDone(sender:)))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func didTapCancel(sender: AnyObject) {
        delegate?.CustomPaymentCardViewControllerDidCancel()
    }
    @objc func didTapDone(sender: AnyObject) {
        billingDetails.address = address
        delegate?.CustomPaymentCardViewControllerDidPay(billingDetails: billingDetails, methodCardParams: methodCardParams)
    }
}

// MARK: UITableViewDelegate And UITableViewDataSource
extension CustomPaymentCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 40
        case 1:
            return 40
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 38))
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
        
        let label = UILabel()
        label.textColor = .gray
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(label)
        view.addSubview(stackView)
        
        let constraints = [
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
        
        switch section {
        case 1:
            label.text = "Tarjeta"
            label.font = UIFont(name: "Mihan-Regular", size: 16.0)!
        case 2:
            label.text = "Dirección de facturación"
            label.font = UIFont(name: "Mihan-Regular", size: 16.0)!
        default:
            break
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return addressFieldsArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let cell = tableview.dequeueReusableCell(withIdentifier: "CustomPaymentCardImageCell", for: indexPath) as? CustomPaymentCardImageCell {
                referenceCustomPaymentCardImageCell = cell
                return cell
            }
        case 1:
            if let cell = tableview.dequeueReusableCell(withIdentifier: "CustomPaymentCardFieldCell", for: indexPath) as? CustomPaymentCardFieldCell {
                cell.delegate = self
                cell.cardField.font = UIFont(name: "Mihan-Regular", size: 15.0)!
                return cell
            }
        case 2:
            if let cell = tableview.dequeueReusableCell(withIdentifier: "CustomPaymentAddressCell", for: indexPath) as? CustomPaymentAddressCell {
                cell.delegate = self
                cell.configure(type: addressFieldsArray[indexPath.row])
                cell.addressInfoTextField.font = UIFont(name: "Mihan-Regular", size: 15.0)!
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

// MARK: CustomPaymentCardFieldCellDelegate
extension CustomPaymentCardViewController: CustomPaymentCardFieldCellDelegate {
    func didBeginEditingCVC() {
        referenceCustomPaymentCardImageCell?.animateCardImage(newCardPosition: .backCard)
    }
    
    func didEndEditingCVC() {
        referenceCustomPaymentCardImageCell?.animateCardImage(newCardPosition: .frontCard)
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        if textField.isValid {
            navigationItem.rightBarButtonItem?.isEnabled = true
            methodCardParams = textField.cardParams
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

// MARK: CustomPaymentAddressCellDelegate
extension CustomPaymentCardViewController: CustomPaymentAddressCellDelegate {
    func userTyping(type: StripeBillingInformation, value: String) {
        switch type {
        case .name:
            billingDetails.name = value
        case .email:
            billingDetails.email = value
        case .cellphoneNumber:
            billingDetails.phone = value
        case .address:
            address.line1 = value
        case .ZIP:
            address.postalCode = value
        case .city:
            address.city = value
        case .state:
            address.state = value
        default:
            break
        }
    }
}
