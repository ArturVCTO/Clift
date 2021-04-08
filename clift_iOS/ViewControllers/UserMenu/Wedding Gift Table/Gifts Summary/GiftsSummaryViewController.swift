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
        case envelop
        case product
    }
    
    var eventRegistries = [GiftSummaryItem]()
    
    var eventPools = [EventPool]()
    
    var type = GiftType.product
    var isColaborativeSelected = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    
    class func make(event: Event) -> GiftsSummaryViewController {
        let vc = UIStoryboard.init(name: "GiftsSummary", bundle: nil).instantiateViewController(withIdentifier: "GiftsSummaryViewController") as! GiftsSummaryViewController
        vc.event = event
        return vc
    }
    
    var event: Event!
    //var params: [String: Any] = ["collaborative": false]
    
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
        setTapGesture()
    }
    
    func setup() {
        registerCells()
        tableView.estimatedRowHeight = 205
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
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
    
    func getEventProducts(params: [String: Any] = [:]) {
        
        self.presentLoader()
        print("el id es \(event.id)")
        
        sharedApiManager.getSummaryAllEvents(event: event, params: params) { (items, response) in
            guard let items = items else { return }
            self.eventRegistries = items
            DispatchQueue.main.async {
                self.dismissLoader()
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                self.collectionViewHeight.constant = CGFloat(self.tableView.contentSize.height)
            }
        }
        
//        sharedApiManager.getEventProducts(event: currentEvent, available: "", gifted: "", filters: filtersDic) { (eventProducts, result) in
//            if let response = result {
//                if (response.isSuccess()) {
//                    self.eventRegistries = eventProducts!
//
//                    guard let json = try? JSONSerialization.jsonObject(with: response.data,
//                                                                       options: []) as? [String: Any],
//                          let meta = json["meta"] as? [String: Any],
//                          let pagination = Pagination(JSON: meta) else {
//                        return
//                    }
//                    self.actualPage = pagination.currentPage
//                    self.numberOfPages = pagination.totalPages
//                    self.paginationLabel.text = "Mostrando del \(pagination.from) al \(pagination.to) de \(pagination.totalCount)"
//                    self.reloadCollectionView()
//                }
//            }
//            self.setPaginationMenu()
//            self.setButtonValues()
//            self.addOrDeleteMenuButtonsDependingOnNumberOfPages()
//            self.lastButtonPressed = nil
//            self.dismissLoader()
//            if self.eventPools.isEmpty && self.eventRegistries.isEmpty {
//                self.displayEmptyState()
//            } else {
//                self.displayGiftTable()
//            }
//        }
    }
    
}

extension GiftsSummaryViewController: GiftsAndEvelopStackViewDelegate {
    
    func giftsSelected() {
        type = .product
        allSelected()
        giftsTypeStackView.isHidden = false
        giftsTypeStackView.selectAllButton()
        getEventProducts()
    }
    
    func envelopeSelected() {
        giftsTypeStackView.isHidden = true
        type = .envelop
        tableView.reloadData()
    }
}

extension GiftsSummaryViewController: GiftsTypeStackViewProtocol {
    
    func allSelected() {
        let newParams = ["collaborative": false]
        isColaborativeSelected = false
        getEventProducts(params: newParams)
    }
    
    func requestedSelected() {
        let newParams = ["status": "requested"]
        isColaborativeSelected = false
        getEventProducts(params: newParams)
    }
    
    func creditSelected() {
        let newParams = ["status": "declined"]
        isColaborativeSelected = false
        getEventProducts(params: newParams)
    }
    
    func collaborativeSelected() {
        let newParams = ["collaborative": true]
        isColaborativeSelected = true
        getEventProducts(params: newParams)
    }
}

extension GiftsSummaryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.type {
        case .envelop:
            return 1
        case .product:
            if isColaborativeSelected {
                return eventRegistries.count
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.type {
        case .envelop:
            return eventPools.count
        case .product:
            if isColaborativeSelected {
                if let numberOfCollaborators = eventRegistries[section].eventProduct.guestData {
                    return numberOfCollaborators.count
                } else {
                    return 0
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
                    return firstColaborativeSummaryTableViewCell
                }
            } else {
                if let colaborativeSummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ColaborativeSummaryTableViewCell", for: indexPath) as? ColaborativeSummaryTableViewCell {
                    return colaborativeSummaryTableViewCell
                }
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserSummaryProductCollectionViewCell", for: indexPath) as? UserSummaryProductCollectionViewCell {
                
                if self.type == .envelop {
                    cell.cellType = .EventPool
                    cell.configure(pool: eventPools[indexPath.row])
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
    
}

// MARK: Extension Collection View Delegate and Data Source
extension GiftsSummaryViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.type {
        case .envelop:
            return eventPools.count
        case .product:
            return eventRegistries.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row >= eventPools.count {
//            let productDetailsVC = UIStoryboard(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsViewController
//            productDetailsVC.currentEventProduct = eventRegistries[indexPath.row - eventPools.count]
//            productDetailsVC.currentEvent = currentEvent
//            productDetailsVC.showAddProductToCart = false
//            productDetailsVC.productDetailType = eventRegistries[indexPath.row - eventPools.count].wishableType == "ExternalProduct" ? .EventExternalProduct : .EventProduct
//            productDetailsVC.modalPresentationStyle = .fullScreen
//            self.navigationController?.pushViewController(productDetailsVC, animated: true)
        }
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
