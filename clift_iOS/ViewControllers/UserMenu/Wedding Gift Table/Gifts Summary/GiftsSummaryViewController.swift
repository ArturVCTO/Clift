//
//  GiftsSummaryViewController.swift
//  clift_iOS
//
//  Created by David Mar on 3/16/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit

class GiftsSummaryViewController: UIViewController {
    
    enum GiftType {
        case envelope
        case product
    }
    
    var eventRegistries = [GiftSummaryItem]()
    var collaborativeEventsProduct = [EventProduct]()
    var cashGiftItems = [CashGiftItem]()
    var type = GiftType.product
    var isColaborativeSelected = false
    var endpointParams: [String: Any] = ["collaborative": false]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet var giftCounter: UILabel!
    
    class func make(event: Event) -> GiftsSummaryViewController {
        let vc = UIStoryboard.init(name: "GiftsSummary", bundle: nil).instantiateViewController(withIdentifier: "GiftsSummaryViewController") as! GiftsSummaryViewController
        vc.event = event
        return vc
    }
    
    var event: Event!
    
    @IBOutlet weak var giftsTypeStackView: GiftsTypeStackView! {
        didSet {
            giftsTypeStackView?.delegate = self
        }
    }
    
    @IBOutlet weak var giftsAndEnvelopesStackView: GiftsAndEnvelopesStackView! {
        didSet {
            giftsAndEnvelopesStackView.delegate = self
        }
    }
    
    @IBOutlet weak var giftSummarySearchBar: UISearchBar!
    
    @IBOutlet var dismissKeyboardTapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        giftsAndEnvelopesStackView.delegate = self
        setup()
        getEventProducts()
        getEnvelopes()
        setTapGesture()
    }
    
    func setup() {
        registerCells()
        tableView.estimatedRowHeight = 205
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        giftSummarySearchBar.delegate = self
    }
    
    func setNavBar() {
        
        let titleLabel = UILabel()
        titleLabel.text = "Resumen de regalos".uppercased()
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Mihan-Regular", size: 16.0)!
        titleLabel.addCharactersSpacing(5)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel

        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "UserSummaryProductCollectionViewCell", bundle: nil), forCellReuseIdentifier: "UserSummaryProductCollectionViewCell")
        tableView.register(UINib(nibName: "FirstColaborativeSummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "FirstColaborativeSummaryTableViewCell")
        tableView.register(UINib(nibName: "ColaborativeSummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "ColaborativeSummaryTableViewCell")
    }
    
    func setTapGesture() {
        dismissKeyboardTapGesture.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardVisible(sender:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(sender:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func keyboardVisible(sender: AnyObject) {
        dismissKeyboardTapGesture.isEnabled = true
    }

    @objc func keyboardHidden(sender: AnyObject) {
        dismissKeyboardTapGesture.isEnabled = false
    }
    
    @IBAction func didTapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
        giftSummarySearchBar.endEditing(true)
    }
    
    func getEventProducts() {
        
        self.presentLoader()
        
        sharedApiManager.getSummaryAllEvents(event: event, params: endpointParams) { (items, response) in
            guard let items = items else { return }
            self.eventRegistries = items
            DispatchQueue.main.async {
                self.dismissLoader()
                self.giftCounter.text = self.eventRegistries.count == 1 ? "1 regalo" : "\(self.eventRegistries.count) regalos"
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.collectionViewHeight.constant = CGFloat(self.tableView.contentSize.height)
            }
        }
    }
    
    func getEventProductsCollaborative() {
        
        self.presentLoader()
        
        sharedApiManager.getGiftThanksSummary(event: event, hasBeenThanked: false, hasBeenPaid: false, filters: ["collaborative":true]) { (items, response) in
            guard let items = items else { return }
            self.collaborativeEventsProduct = items
            
            //This for cicle drops all the orderItems that have status as pending
            for eventProduct in self.collaborativeEventsProduct {
                if let orderItem = eventProduct.orderItems {
                    eventProduct.orderItems = orderItem.filter { $0.status != "pending" }
                }
            }
            
            DispatchQueue.main.async {
                self.dismissLoader()
                self.giftCounter.text = self.collaborativeEventsProduct.count == 1 ? "1 regalo" : "\(self.collaborativeEventsProduct.count) regalos"
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.collectionViewHeight.constant = CGFloat(self.tableView.contentSize.height)
            }
        }
    }
    
    func getEnvelopes(params: [String: Any] = [:]) {
        
        self.presentLoader()
        
        sharedApiManager.getOrderItems(event: event, params: params) { (cashItems, response) in
            guard let cashItems = cashItems else { return }
            self.cashGiftItems = cashItems
            DispatchQueue.main.async {
                self.dismissLoader()
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.collectionViewHeight.constant = CGFloat(self.tableView.contentSize.height)
            }
        }
    }
    
}

extension GiftsSummaryViewController: GiftsAndEvelopStackViewDelegate {
    
    func giftsSelected() {
        type = .product
        allSelected()
        giftsTypeStackView.isHidden = false
        giftSummarySearchBar.isHidden = false
        giftsTypeStackView.selectAllButton()
    }
    
    func envelopeSelected() {
        giftsTypeStackView.isHidden = true
        giftSummarySearchBar.isHidden = true
        self.giftCounter.text = self.cashGiftItems.count == 1 ? "1 sobre" : "\(self.cashGiftItems.count) sobres"
        type = .envelope
        tableView.reloadData()
    }
}

extension GiftsSummaryViewController: GiftsTypeStackViewProtocol {
    
    func allSelected() {
        endpointParams["collaborative"] = false
        endpointParams["status"] = ""
        endpointParams["guest"] = ""
        isColaborativeSelected = false
        getEventProducts()
    }
    
    func requestedSelected() {
        endpointParams["status"] = "requested"
        endpointParams["collaborative"] = false
        endpointParams["guest"] = ""
        isColaborativeSelected = false
        getEventProducts()
    }
    
    func creditSelected() {
        endpointParams["status"] = "declined"
        endpointParams["collaborative"] = false
        endpointParams["guest"] = ""
        isColaborativeSelected = false
        getEventProducts()
    }
    
    func collaborativeSelected() {
        isColaborativeSelected = true
        getEventProductsCollaborative()
    }
}

extension GiftsSummaryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.type {
        case .envelope:
            return 1
        case .product:
            if isColaborativeSelected {
                return collaborativeEventsProduct.count
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.type {
        case .envelope:
            return cashGiftItems.count
        case .product:
            if isColaborativeSelected {
                if let numberOfCollaborators = collaborativeEventsProduct[section].orderItems {
                    return numberOfCollaborators.count
                } else {
                    return 1
                }
            } else {
                return eventRegistries.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isColaborativeSelected {
            if indexPath.row == 0 {
                if let firstColaborativeSummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FirstColaborativeSummaryTableViewCell", for: indexPath) as? FirstColaborativeSummaryTableViewCell {
                    firstColaborativeSummaryTableViewCell.selectionStyle = .none
                    firstColaborativeSummaryTableViewCell.configure(eventProduct: collaborativeEventsProduct[indexPath.section])
                    return firstColaborativeSummaryTableViewCell
                }
            } else {
                if let colaborativeSummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ColaborativeSummaryTableViewCell", for: indexPath) as? ColaborativeSummaryTableViewCell {
                    colaborativeSummaryTableViewCell.selectionStyle = .none
                    colaborativeSummaryTableViewCell.configure(eventProduct: collaborativeEventsProduct[indexPath.section], numberOfPerson: indexPath.row)
                    return colaborativeSummaryTableViewCell
                }
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserSummaryProductCollectionViewCell", for: indexPath) as? UserSummaryProductCollectionViewCell {
                
                cell.selectionStyle = .none
                
                if self.type == .envelope {
                    cell.cellType = .EventPool
                    cell.configure(cashGiftItem: cashGiftItems[indexPath.row])
                } else {
                    if eventRegistries[indexPath.row].eventProduct.wishableType == "ExternalProduct" {
                        cell.cellType = .EventExternalProduct
                        cell.configure(summaryItem: eventRegistries[indexPath.row])
                    } else {
                        cell.cellType = .EventProduct
                        cell.configure(summaryItem: eventRegistries[indexPath.row])
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isColaborativeSelected {
            tableView.separatorStyle = .none
            let footerView = UIView()
            let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: footerView.frame.height, width: tableView.frame.width - tableView.separatorInset.right - tableView.separatorInset.left, height: 1))
            separatorView.backgroundColor = UIColor.gray
            footerView.addSubview(separatorView)
            return footerView
        } else {
            tableView.separatorStyle = .singleLine
            return UIView()
        }
    }
}

extension GiftsSummaryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case .product:
            if isColaborativeSelected {
                if indexPath.row == 0 {
                    presentActionSheet(eventProduct: collaborativeEventsProduct[indexPath.section])
                } else {
                    if let orderItem = collaborativeEventsProduct[indexPath.section].orderItems?[indexPath.row] {
                        presentThanksMessageActionSheet(orderItem: orderItem, eventProduct: collaborativeEventsProduct[indexPath.section])
                    }
                }
            } else {
                presentActionSheet(summaryItem: eventRegistries[indexPath.row])
            }
        case .envelope:
            presentEnvelopeActionSheet(cashGiftItem: cashGiftItems[indexPath.row])
        }
    }
}

extension GiftsSummaryViewController {
    
    func presentActionSheet(summaryItem: GiftSummaryItem? = nil, eventProduct: EventProduct? = nil) {
        
        var giftStatusHelperOptions = GiftStatusHelperOptions()
        
        //Variables that will be used in the options
        var currentEventProduct = EventProduct()
        var currentOrderItem = OrderItem()
        
        if let summaryItem = summaryItem {
            giftStatusHelperOptions = GiftStatusHelper.shared.manageSimpleGift(giftSummaryItem: summaryItem)
            currentEventProduct = summaryItem.eventProduct
            if let orderItem = currentEventProduct.orderItems?.first {
                currentOrderItem = orderItem
            }
        } else if let eventProduct = eventProduct {
            giftStatusHelperOptions = GiftStatusHelper.shared.manageCollaborativeGift(eventProduct: eventProduct, orderItem: currentOrderItem)
            currentEventProduct = eventProduct
            if let orderItem = currentEventProduct.orderItems?.first {
                currentOrderItem = orderItem
            }
        }
        
        //UIAlertActions Declared
        let optionsSheet = UIAlertController(title: "Opciones", message: nil, preferredStyle: .actionSheet)
        optionsSheet.view.tintColor = UIColor(named: "PrimaryBlue")
        
        let convertToCredit = UIAlertAction(title: "CONVERTIR A CRÉDITO",
                                            style: .default,
                                            handler: { (action) in self.presentConvertToCredit(product: currentEventProduct)
        })
        
        let requestProduct = UIAlertAction(title: "SOLICITAR PRODUCTO",
                                           style: .default,
                                           handler: { (action) in self.presentRequestProduct(product: currentEventProduct)
        })
        
        let sendMessage = UIAlertAction(title: "ENVIAR MENSAJE DE AGRADECIMIENTO",
                                        style: .default,
                                        handler: { (action) in self.presentSendMessage(orderItem: currentOrderItem, eventProduct: currentEventProduct)
                                        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        //Add Options To OptionSheet
        if giftStatusHelperOptions.credit == .grayIcon {
            optionsSheet.addAction(convertToCredit)
        }
        
        if giftStatusHelperOptions.deliver == .grayIcon {
            optionsSheet.addAction(requestProduct)
        }
        
        optionsSheet.addAction(sendMessage)
        optionsSheet.addAction(cancelAction)
        
        present(optionsSheet, animated: true, completion: nil)
        
    }
    
    func presentThanksMessageActionSheet(orderItem: OrderItem, eventProduct: EventProduct) {
        
        let optionsSheet = UIAlertController(title: "Opciones", message: nil, preferredStyle: .actionSheet)
        optionsSheet.view.tintColor = UIColor(named: "PrimaryBlue")
        
        let sendMessage = UIAlertAction(title: "ENVIAR MENSAJE DE AGRADECIMIENTO", style: .default, handler: {(action) in self.presentSendMessage(orderItem: orderItem, eventProduct: eventProduct)})
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        optionsSheet.addAction(sendMessage)
        optionsSheet.addAction(cancelAction)
        
        present(optionsSheet, animated: true, completion: nil)
    }
    
    func presentEnvelopeActionSheet(cashGiftItem: CashGiftItem) {
        
        let optionsSheet = UIAlertController(title: "Opciones", message: nil, preferredStyle: .actionSheet)
        optionsSheet.view.tintColor = UIColor(named: "PrimaryBlue")
        
        let sendMessage = UIAlertAction(title: "ENVIAR MENSAJE DE AGRADECIMIENTO", style: .default, handler: {(action) in self.presentSendMessageEnvelope(cashGiftItem: cashGiftItem)})
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        optionsSheet.addAction(sendMessage)
        optionsSheet.addAction(cancelAction)
        
        present(optionsSheet, animated: true, completion: nil)
    }
    
    func presentConvertToCredit(product: EventProduct) {
        requestCredit(eventProduct: product)
    }
    
    func presentRequestProduct(product: EventProduct) {
        requestShipping(product: product)
    }
    
    func presentSendMessage(orderItem: OrderItem, eventProduct: EventProduct) {
        sendThanksMessage(orderItem: orderItem, eventProduct: eventProduct)
    }
    
    func presentSendMessageEnvelope(cashGiftItem: CashGiftItem) {
        sendThanksMessageEnvelope(cashGiftItem: cashGiftItem)
    }
}

// MARK: Extension UISearchBarDelegate
extension GiftsSummaryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        if let query = searchBar.text {
            endpointParams["guest"] = query
            getEventProducts()
        }
        searchBar.text = ""
    }
}

extension GiftsSummaryViewController {
    func requestShipping(product: EventProduct) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "initialGiftShippingVC") as! InitialGiftShippingViewController
        vc.eventProducts = [product]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendThanksMessage(orderItem: OrderItem, eventProduct: EventProduct) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "thankGuestVC") as! ThankGuestViewController
        vc.event = self.event
        vc.thankType = .SummaryProduct
        vc.orderItem = orderItem
        vc.gift = eventProduct
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendThanksMessageEnvelope(cashGiftItem: CashGiftItem) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "thankGuestVC") as! ThankGuestViewController
        vc.event = self.event
        vc.thankType = .Envelope
        vc.cashGiftItem = cashGiftItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func requestCredit(eventProduct: EventProduct) {
        let convertCreditVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "convertCreditVC") as!
        ConvertToCreditViewController
        
        convertCreditVC.eventProduct = eventProduct
        convertCreditVC.event = event
        
        self.parent?.addChild(convertCreditVC)
        convertCreditVC.view.frame = self.view.frame
        self.parent?.view.addSubview(convertCreditVC.view)
        convertCreditVC.didMove(toParent: self)
    }
}

////MARK:- Extension ProductCellDelegate
//extension GiftsSummaryViewController: UserSummaryProductCollectionViewCellDelegate {
//
//    func didTapStarProduct(eventProduct: EventProduct) {
//        updateEventProductToImportant(eventProduct: eventProduct, importantBool: !eventProduct.isImportant)
//    }
//
//    func didTapStarPool(eventPool: EventPool) {
//        updateEventPoolToImportant(event: currentEvent, oldEventPool: eventPool, importantBool: !eventPool.isImportant)
//    }
//
//    func didTapMoreOptions(cellType: ProductCellType, eventPool: EventPool, eventProduct: EventProduct) {
//
//        let sheet = UIAlertController(title: "Acciones", message: nil, preferredStyle: .actionSheet)
//
//        var setAsImportant: UIAlertAction
//        if cellType == .EventPool {
//            if (eventPool.isImportant){
//                setAsImportant = UIAlertAction(title: "Desmarcar como importante", style: .default, handler: {(action) in self.importantActionButtonPressedPool(eventPool: eventPool)})
//            } else {
//                setAsImportant = UIAlertAction(title: "Marcar como importante", style: .default, handler: {(action) in self.importantActionButtonPressedPool(eventPool: eventPool)})
//            }
//        } else {
//            if (eventProduct.isImportant){
//                setAsImportant = UIAlertAction(title: "Desmarcar como importante", style: .default, handler: {(action) in self.importantActionButtonPressedProduct(eventProduct: eventProduct)})
//            } else {
//                setAsImportant = UIAlertAction(title: "Marcar como importante", style: .default, handler: {(action) in self.importantActionButtonPressedProduct(eventProduct: eventProduct)})
//            }
//        }
//
//        //SOLO PARA REGALOS
//        var makeCollaborativeGift: UIAlertAction
//        var makeIndividualGift: UIAlertAction
//        var removeFromRegistry: UIAlertAction
//        var seeMoreInfoProduct: UIAlertAction
//        if cellType == .EventProduct || cellType == .EventExternalProduct { //Productos
//
//            if (!eventProduct.isCollaborative && eventProduct.gifted_quantity == 0  && eventProduct.product.price>=2000){
//                //CONVERTIR A REGALO GRUPAL
//                makeCollaborativeGift = UIAlertAction(title: "Convertir a regalo colaborativo", style: .default, handler: {(action) in self.collaborativeActionButtonPressed(eventProduct: eventProduct)})
//                makeCollaborativeGift.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
//                makeCollaborativeGift.setValue(UIImage(named: "addmanualcolab"), forKey: "image")
//                sheet.addAction(makeCollaborativeGift)
//            }
//
//            if (eventProduct.isCollaborative && eventProduct.gifted_quantity == 0){
//                makeIndividualGift = UIAlertAction(title: "Convertir a regalo individual", style: .default, handler: {(action) in self.individualActionButtonPressed(eventProduct: eventProduct)})
//                makeIndividualGift.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
//                makeIndividualGift.setValue(UIImage(named: "infoprofileic"), forKey: "image")
//                sheet.addAction(makeIndividualGift)
//            }
//
//            //VER INFORMACION DE PRODUCTO
//            seeMoreInfoProduct = UIAlertAction(title: "Ver información de producto", style: .default, handler: {(action) in self.addMoreInfoProductView(eventProduct: eventProduct)})
//            seeMoreInfoProduct.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
//            seeMoreInfoProduct.setValue(UIImage(named: "icsearch"), forKey: "image")
//            sheet.addAction(seeMoreInfoProduct)
//
//            if (eventProduct.gifted_quantity == 0){
//                removeFromRegistry = UIAlertAction(title: "Quitar producto de mesa", style: .destructive,handler: {(action) in self.removeProductButtonPressed(eventProduct: eventProduct)})
//                removeFromRegistry.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
//                removeFromRegistry.setValue(UIImage(named: "icremove"), forKey: "image")
//                sheet.addAction(removeFromRegistry)
//            }
//        } else if(Float(eventPool.collectedAmount) == 0) { //Pools
//            removeFromRegistry = UIAlertAction(title: "Quitar sobre de mesa", style: .destructive,handler: {(action) in self.removePoolButtonPressed(eventPool: eventPool)})
//            removeFromRegistry.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
//            removeFromRegistry.setValue(UIImage(named: "icremove"), forKey: "image")
//            sheet.addAction(removeFromRegistry)
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
//
//        setAsImportant.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
//        setAsImportant.setValue(UIImage(named: "addmanualfav"), forKey: "image")
//
//        cancelAction.setValue(UIColor.init(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0), forKey: "titleTextColor")
//        cancelAction.setValue(UIImage(named: "icnotassisting"), forKey: "image")
//
//        sheet.addAction(setAsImportant)
//        sheet.addAction(cancelAction)
//
//        present(sheet, animated: true, completion: nil)
//    }
//}
