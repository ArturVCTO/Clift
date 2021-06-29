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
    
    static func makeCustomPaymentCardViewController(subtotalAmount: Double?, totalAmount: Double, delegate: CustomPaymentCardViewControllerDelegate) -> CustomPaymentCardViewController {
        let viewController = UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "CustomPaymentCardVC") as! CustomPaymentCardViewController
        
        viewController.subtotalAmount = subtotalAmount
        viewController.totalAmount = totalAmount
        viewController.delegate = delegate
        return viewController
    }

    @IBOutlet weak var tableview: UITableView!
    
    var subtotalAmount: Double?
    var totalAmount = 0.0
    var referenceCustomPaymentCardImageCell: CustomPaymentCardImageCell?
    var addressFieldsArray: [StripeBillingInformation] = [.name,.email,.cellphoneNumber,.address,.ZIP,.city,.state]
    var billingDetails = STPPaymentMethodBillingDetails()
    let address = STPPaymentMethodAddress()
    var methodCardParams = STPPaymentMethodCardParams()
    var delegate: CustomPaymentCardViewControllerDelegate?
    var payButtonEnable = false

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
        tableview.register(UINib(nibName: "CustomPaymentAmountPreviewCell", bundle: nil), forCellReuseIdentifier: "CustomPaymentAmountPreviewCell")
        tableview.register(UINib(nibName: "CustomPaymentPayButtonCell", bundle: nil), forCellReuseIdentifier: "CustomPaymentPayButtonCell")
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

        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func didTapCancel(sender: AnyObject) {
        delegate?.CustomPaymentCardViewControllerDidCancel()
    }
}

// MARK: UITableViewDelegate And UITableViewDataSource
extension CustomPaymentCardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
            label.font = UIFont(name: "Mihan-Regular", size: 16.0)
        case 2:
            label.text = "Dirección de facturación"
            label.font = UIFont(name: "Mihan-Regular", size: 16.0)
        case 3:
            label.text = "Importe"
            label.font = UIFont(name: "Mihan-Regular", size: 16.0)
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
        case 3:
            return 1
        case 4:
            return 1
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
        case 3:
            if let cell = tableview.dequeueReusableCell(withIdentifier: "CustomPaymentAmountPreviewCell", for: indexPath) as? CustomPaymentAmountPreviewCell {
                cell.configure(subtotalAmount: subtotalAmount, totalAmount: totalAmount)
                return cell
            }
        case 4:
            if let cell = tableview.dequeueReusableCell(withIdentifier: "CustomPaymentPayButtonCell", for: indexPath) as? CustomPaymentPayButtonCell {
                cell.configure(delegate: self)
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
            payButtonEnable = true
            methodCardParams = textField.cardParams
        } else {
            payButtonEnable = false
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

// MARK: CustomPaymentPayButtonCellDelegate
extension CustomPaymentCardViewController: CustomPaymentPayButtonCellDelegate {
    func didTapPayButton() {
        if payButtonEnable {
            billingDetails.address = address
            delegate?.CustomPaymentCardViewControllerDidPay(billingDetails: billingDetails, methodCardParams: methodCardParams)
        } else {
            self.showMessage(NSLocalizedString("Falta información para procesar el pago.", comment: ""),type: .error)
        }
    }
}
