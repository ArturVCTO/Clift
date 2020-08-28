//
//  ProductsRegistryViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/23/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import GSMessages

class ProductsRegistryViewController: UIViewController {
    
    var currentEvent = Event()
    var pagination = Pagination()
    var eventProducts = [EventProduct]()
    var eventPools = [EventPool]()
    var giftedSelected = ""
    var availableSelected = ""
    let buttonBar = UIView()
    var selectedIndexPath = IndexPath()
    var totalProductsCount = Int()
    var filters = Dictionary<String,Any>()
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var addProductsToRegistryButton: customButton!
    @IBOutlet weak var actionButton: customButton!
    var productRegistryGiftedProduct = EventProduct()
    @IBOutlet weak var totalProductsCountLabel: UILabel!
    @IBOutlet weak var eventProductsCollectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var firstPageButton: UIButton!
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var backPageButton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var lastPageButton: UIButton!
    @IBOutlet weak var registrySegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventProductsCollectionView.delegate = self
        self.eventProductsCollectionView.dataSource = self
        self.eventProductsCollectionView.allowsMultipleSelection = false
        self.styleSegmentControl()
        self.loadEvent()
        self.getEventProducts(event: currentEvent, available: availableSelected, gifted: giftedSelected, filters: ["page": 1])
        self.navigationView.layer.cornerRadius = 20
        self.navigationView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func loadTotalProducts() {
        self.totalProductsCountLabel.text = "\(self.totalProductsCount) artículos"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.totalProductsCount = 0
    }
    
    @IBAction func firstPageButton(_ sender: UIButton) {
        self.filters["page"] = 1
        if(registrySegment.selectedSegmentIndex == 0){
            self.getEventProducts(event: self.currentEvent, available: availableSelected, gifted: giftedSelected, filters: self.filters)
        }
        else if(registrySegment.selectedSegmentIndex == 1){
            self.loadGiftedAndThanked()
        }
        else{
            self.getEventPoolsTab(event: self.currentEvent)
        }
        
    }
    @IBAction func backPageButton(_ sender: UIButton) {
        self.filters["page"] = self.pagination.currentPage - 1
        if((self.filters["page"] as! Int) < 1){
            self.filters["page"] = 1
        }
        
        if(registrySegment.selectedSegmentIndex == 0){
            self.getEventProducts(event: self.currentEvent, available: availableSelected, gifted: giftedSelected, filters: self.filters)
        }
        else if(registrySegment.selectedSegmentIndex == 1){
            self.loadGiftedAndThanked()
        }
        else{
            self.getEventPoolsTab(event: self.currentEvent)
        }
    }
    
    @IBAction func nextPageButton(_ sender: UIButton) {
        self.filters["page"] = self.pagination.currentPage + 1
        if(self.filters["page"] as! Int > self.pagination.totalPages){
            self.filters["page"] = self.pagination.totalPages
        }
        if(registrySegment.selectedSegmentIndex == 0){
            self.getEventProducts(event: self.currentEvent, available: availableSelected, gifted: giftedSelected, filters: self.filters)
        }
        else if(registrySegment.selectedSegmentIndex == 1){
            self.loadGiftedAndThanked()
        }
        else{
            self.getEventPoolsTab(event: self.currentEvent)
        }
    }
    @IBAction func lastPageButton(_ sender: UIButton) {
        self.filters["page"] = self.pagination.totalPages
        if(registrySegment.selectedSegmentIndex == 0){
            self.getEventProducts(event: self.currentEvent, available: availableSelected, gifted: giftedSelected, filters: self.filters)
        }
        else if(registrySegment.selectedSegmentIndex == 1){
            self.loadGiftedAndThanked()
        }
        else{
            self.getEventPoolsTab(event: self.currentEvent)
        }
    }
    
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        self.filters["page"] = 1
        if registrySegment.selectedSegmentIndex == 0 {
            self.getEventProducts(event: self.currentEvent, available: "", gifted: "", filters: [:])
        }else if registrySegment.selectedSegmentIndex == 1{
            self.loadGiftedAndThanked()
        }else{
            self.getEventPoolsTab(event: self.currentEvent)
        }
    }
    
    @IBAction func changeBarAnimation(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
          self.buttonBar.frame.origin.x = (self.registrySegment.frame.width / CGFloat(self.registrySegment.numberOfSegments)) * CGFloat(self.registrySegment.selectedSegmentIndex)
        }
    }
    
    func loadEvent() {
        let realm = try! Realm()
        let realmEvents = realm.objects(Event.self)
        if let currentEvent = realmEvents.first {
            self.currentEvent = currentEvent
        }
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
              let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "eventProductFilterViewController") as! EventProductFilterViewController
            vc.productRegistryVC = self
              self.navigationController?.pushViewController(vc, animated: true)
          } else {
            // Fallback on earlier versions
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "eventProductFilterViewController") as! EventProductFilterViewController
            vc.productRegistryVC = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func styleSegmentControl() {
        self.registrySegment.backgroundColor = .white
        self.registrySegment.tintColor = .clear
        self.registrySegment.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular",size: 15)!,NSAttributedString
            .Key.foregroundColor: UIColor(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0)], for: .normal)
        self.registrySegment.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0)], for: .selected)
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0)
//        view.addSubview(buttonBar)
//        buttonBar.topAnchor.constraint(equalTo: self.registrySegment.bottomAnchor).isActive = true
//        buttonBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
//        // Constrain the button bar to the left side of the segmented control
//        buttonBar.leftAnchor.constraint(equalTo: self.registrySegment.leftAnchor).isActive = true
//        // Constrain the button bar to the width of the segmented control divided by the number of segments
//        buttonBar.widthAnchor.constraint(equalTo: self.registrySegment.widthAnchor, multiplier: 1 / CGFloat(self.registrySegment.numberOfSegments)).isActive = true
    }
    

    @IBAction func addObjectToRegistry(_ sender: Any) {
//        let alertActionController = UIAlertController(title: "Agregar producto", message: "", preferredStyle: .actionSheet)
//        let goToStoreAction = UIAlertAction(title: "Ir a tienda", style: .default, handler: nil)
//        let createCashFund = UIAlertAction(title: "Sobre de dinero", style: .default, handler: nil)
//        let createManualProduct = UIAlertAction(title: "Agregar producto manualmente", style: .default, handler: nil)
//        let createURLProduct = UIAlertAction(title: "Agregar producto externo", style: .default, handler: nil)
//        alertActionController.addAction(goToStoreAction)
//        alertActionController.addAction(createCashFund)
//        alertActionController.addAction(createManualProduct)
//        alertActionController.addAction(createURLProduct)
//        present(alertActionController, animated: true, completion: nil)
        let alertController = YBAlertController(title: "Agregar producto", message: nil, style: .ActionSheet)
        // let alertController = YBAlertController(style: .ActionSheet)
        alertController.messageFont = UIFont(name: "Poppins-Bold", size: 15)
        // add a button
        alertController.addButton(icon: UIImage(named: "gotostore"), title: "Ir a tienda", action: {
            if #available(iOS 13.0, *) {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "mainStoreVC") as! MainStoreViewController
                vc.fromRegistry = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainStoreVC") as! MainStoreViewController
                vc.fromRegistry = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        // add a button with closure
        alertController.addButton(icon: UIImage(named: "addcashfund"), title: "Sobre de dinero", action: {
           if #available(iOS 13.0, *) {
                  let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "addCashFundVC") as! AddCashFundViewController
                    vc.productsRegistryVC = self
                  self.navigationController?.pushViewController(vc, animated: true)
              } else {
                // Fallback on earlier versions
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addCashFundVC") as! AddCashFundViewController
                vc.productsRegistryVC = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        alertController.addButton(icon: UIImage(named: "addmanualproduct"), title: "Agregar producto manualmente", action: {
            if #available(iOS 13.0, *) {
                  let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "addManualProductVC") as! AddManualProductViewController
                vc.productsRegistryVC = self
                  self.navigationController?.pushViewController(vc, animated: true)
              } else {
                // Fallback on earlier versions
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addManualProductVC") as! AddManualProductViewController
                vc.productsRegistryVC = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        alertController.addButton(icon: UIImage(named: "addproducturl"), title: "Agregar producto externo", action: {
            if #available(iOS 13.0, *) {
                  let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "addProductUrlVC") as! AddProductByUrlViewController
                vc.productsRegistryVC = self
                  self.navigationController?.pushViewController(vc, animated: true)
              } else {
                // Fallback on earlier versions
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addProductUrlVC") as! AddProductByUrlViewController
                vc.productsRegistryVC = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        // add a button (No image)

        // if you use a cancel Button, set cancelButtonTitle
        alertController.cancelButtonTitle = "Cancelar"
                 
        // show alert
        alertController.show()
    }
    
    func importantActionButtonPressed(alert: UIAlertAction) {
        loadEvent()
        if registrySegment.selectedSegmentIndex == 2 {
            let eventPoolImportantBool = self.eventPools[selectedIndexPath.row].isImportant
            self.updateEventPoolToImportant(event: self.currentEvent, eventPool: self.eventPools[selectedIndexPath.row],importantBool: !eventPoolImportantBool)
        }
        else{
            let eventProductImportantBool = self.eventProducts[selectedIndexPath.row].isImportant
            self.updateEventProductToImportant(eventProduct: self.eventProducts[selectedIndexPath.row],importantBool: !eventProductImportantBool)
        }
    }
    
    func removeProductButtonPressed(alert: UIAlertAction) {
        self.removeProductFromRegistry(eventProduct: self.eventProducts[selectedIndexPath.row], event: self.currentEvent)
    }
    
    func removePoolButtonPressed(alert: UIAlertAction) {
        self.removePoolFromRegistry(eventPool: self.eventPools[selectedIndexPath.row], event: self.currentEvent)
    }
    
    func addCollaboratorsView(alert: UIAlertAction){
        let collaboratorsInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "collaboratorsInfoVC") as!
         CollaboratorsViewController

        collaboratorsInfoVC.product = eventProducts[selectedIndexPath.row]
        collaboratorsInfoVC.currentEvent = self.currentEvent

        self.parent?.parent?.addChild(collaboratorsInfoVC)
        collaboratorsInfoVC.view.frame = self.parent!.view.frame
        self.parent?.parent?.view.addSubview(collaboratorsInfoVC.view)
        collaboratorsInfoVC.didMove(toParent: self.parent)
        
        
    }
    
    func addMoreInfoProductView(alert: UIAlertAction){
        let productInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "productInfoVC") as!
        ProductInformationTableViewController
        
        productInfoVC.product = eventProducts[selectedIndexPath.row].product
        productInfoVC.eventProduct = eventProducts[selectedIndexPath.row]
        productInfoVC.event = self.currentEvent
        productInfoVC.collectionView = self.eventProductsCollectionView
        productInfoVC.selectedIndexPath = self.selectedIndexPath
        
        self.parent?.addChild(productInfoVC)
        productInfoVC.view.frame = self.view.frame
        self.parent?.view.addSubview(productInfoVC.view)
        productInfoVC.didMove(toParent: self)
    }
    
    func removeProductFromRegistry(eventProduct: EventProduct,event: Event) {
        sharedApiManager.deleteEventProduct(eventProduct: eventProduct, event: event) { (emptyObject, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.showMessage(NSLocalizedString("Producto se ha quitado de tu mesa", comment: "Removed Product Success"),type: .success)
                        self.getEventProducts(event: self.currentEvent,available: self.availableSelected, gifted: self.giftedSelected, filters: [:])
                        self.deselectItems()
                        self.eventProductsCollectionView.reloadData()
                } else {
                    self.showMessage(NSLocalizedString("\(emptyObject?.errors.first ?? "Error, intente de nuevo más tarde.")", comment: "Remove  Error"),type: .error)
                }
            }
        }
    }
    
    func removePoolFromRegistry(eventPool: EventPool,event: Event) {
        sharedApiManager.deleteEventPool(eventPool: eventPool, event: event) { (emptyObject, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.showMessage(NSLocalizedString("Sobre se ha quitado de tu mesa", comment: "Removed Pool Success "),type: .success)
                        self.getEventPools(event: event)
                        self.deselectItems()
                        self.eventProductsCollectionView.reloadData()
                } else {
                    self.showMessage(NSLocalizedString("\(emptyObject?.errors.first ?? "Error, intente de nuevo más tarde.")", comment: "Remove  Error"),type: .error)
                }
            }
        }
    }
    
    func collaborativeActionButtonPressed(alert: UIAlertAction) {
        let numberOfCollaboratorsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "numberOfCollaboratorsVC") as!
         NumberOfCollaboratorsViewController
        numberOfCollaboratorsVC.selectedIndexPath = selectedIndexPath
        numberOfCollaboratorsVC.collectionView = self.eventProductsCollectionView
        numberOfCollaboratorsVC.eventProduct = self.eventProducts[selectedIndexPath.row]
        self.parent?.addChild(numberOfCollaboratorsVC)
               numberOfCollaboratorsVC.view.frame = self.view.frame
               self.parent?.view.addSubview(numberOfCollaboratorsVC.view)
               numberOfCollaboratorsVC.didMove(toParent: self)
    }
    
    func individualActionButtonPressed(alert: UIAlertAction){
        sharedApiManager.updateEventProductAsCollaborative(eventProduct: self.eventProducts[self.selectedIndexPath.row], setCollaborative: false, collaborators: 0) { (_, response) in
            if let result = response{
                if result.isSuccess(){
                    self.eventProducts[self.selectedIndexPath.row].isCollaborative = false
                    self.eventProducts[self.selectedIndexPath.row].collaborators = 0
                    self.eventProductsCollectionView.reloadItems(at: [self.selectedIndexPath])
                    self.showMessage(NSLocalizedString("Porducto actualizado como individual", comment: "Producto actualizado"), type: .success)
                }else{
                    self.showMessage(NSLocalizedString("Error de servidor, intente de nuevo más tarde", comment: "Error"), type: .error)
                    
                }
            }
        }
    
    }
    
    func requestGift(alert: UIAlertAction) {
        var requestedGifts: [EventProduct] = []
        
        requestedGifts.append(self.eventProducts[selectedIndexPath.row])
        
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "initialGiftShippingVC") as! InitialGiftShippingViewController
            vc.eventProducts = requestedGifts
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "initialGiftShippingVC") as! InitialGiftShippingViewController
            vc.eventProducts = requestedGifts
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        let sheet = UIAlertController(title: "Acciones", message: nil, preferredStyle: .actionSheet)
        
        var setAsImportant: UIAlertAction
        if registrySegment.selectedSegmentIndex == 2{
            if (self.eventPools[self.selectedIndexPath.row].isImportant){
                setAsImportant = UIAlertAction(title: "Desmarcar como lo más importante", style: .default, handler: importantActionButtonPressed(alert:))
            }
            else{
                setAsImportant = UIAlertAction(title: "Marcar como lo más importante", style: .default, handler: importantActionButtonPressed(alert:))
            }
        }
        else{
            if (self.eventProducts[self.selectedIndexPath.row].isImportant){
                setAsImportant = UIAlertAction(title: "Desmarcar como lo más importante", style: .default, handler: importantActionButtonPressed(alert:))
            }
            else{
                setAsImportant = UIAlertAction(title: "Marcar como lo más importante", style: .default, handler: importantActionButtonPressed(alert:))
            }
        }
        
        //SOLO PARA REGALOS
        var requestGift: UIAlertAction
        var makeCollaborativeGift: UIAlertAction
        var makeIndividualGift: UIAlertAction
        var removeFromRegistry: UIAlertAction
        var seeMoreInfoProduct: UIAlertAction
        if !(registrySegment.selectedSegmentIndex == 2){ //Productos
            //SOLICITAR ENVIO
            requestGift = UIAlertAction(title: "Solicitar envio", style: .default,handler: requestGift(alert:))
            requestGift.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
            sheet.addAction(requestGift)
            
            if(!self.eventProducts[self.selectedIndexPath.row].isCollaborative && self.eventProducts[self.selectedIndexPath.row].gifted_quantity == 0  && self.eventProducts[self.selectedIndexPath.row].product.price>=2000){
                //CONVERTIR A REGALO GRUPAL
                makeCollaborativeGift = UIAlertAction(title: "Convertir a regalo colaborativo", style: .default, handler: collaborativeActionButtonPressed(alert:))
                makeCollaborativeGift.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
                sheet.addAction(makeCollaborativeGift)
            }
            
            if(self.eventProducts[self.selectedIndexPath.row].isCollaborative && self.eventProducts[self.selectedIndexPath.row].gifted_quantity == 0){
                makeIndividualGift = UIAlertAction(title: "Convertir a regalo individual", style: .default, handler: individualActionButtonPressed(alert:))
                makeIndividualGift.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
                sheet.addAction(makeIndividualGift)
            }
            
            //VER INFORMACION DE PRODUCTO
            seeMoreInfoProduct = UIAlertAction(title: "Ver información de producto", style: .default, handler: addMoreInfoProductView(alert:))
            seeMoreInfoProduct.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
            sheet.addAction(seeMoreInfoProduct)
            
            if(self.eventProducts[self.selectedIndexPath.row].gifted_quantity == 0){
                removeFromRegistry = UIAlertAction(title: "Quitar producto de mesa", style: .destructive,handler: removeProductButtonPressed(alert:))
                removeFromRegistry.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
                sheet.addAction(removeFromRegistry)
            }else{
                if(registrySegment.selectedSegmentIndex == 1){
                    let collaboratorsAction = UIAlertAction(title: "Ver colaboradores", style: .default,handler:addCollaboratorsView(alert
                    :))
                    collaboratorsAction.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
                    sheet.addAction(collaboratorsAction)
                }
            }
        }
        else{ //Pools
            if(Float(self.eventPools[self.selectedIndexPath.row].collectedAmount) == 0){
               removeFromRegistry = UIAlertAction(title: "Quitar sobre de mesa", style: .destructive,handler: removePoolButtonPressed(alert:))
               removeFromRegistry.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
                sheet.addAction(removeFromRegistry)
            }
        }
            
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
               
        setAsImportant.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
        cancelAction.setValue(UIColor.init(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0), forKey: "titleTextColor")
    
        sheet.addAction(setAsImportant)
        sheet.addAction(cancelAction)
       
        present(sheet, animated: true, completion: nil)
    }
    
    func updateEventProductToImportant(eventProduct: EventProduct, importantBool: Bool) {
        sharedApiManager.updateEventProductAsImportant(eventProduct: eventProduct,setImportant: importantBool) { (eventProduct,result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.totalProductsCount = 0
                    if eventProduct!.isImportant {
                        self.showMessage(NSLocalizedString("Producto marcado como importante", comment: "Update success"),type: .success)
                    } else {
                        self.showMessage(NSLocalizedString("Producto desmarcado como importante", comment: "Update success"),type: .success)
                    }
                    self.eventProducts[self.selectedIndexPath.row].isImportant = !(self.eventProducts[self.selectedIndexPath.row].isImportant)
                    let cell = self.eventProductsCollectionView.cellForItem(at: self.selectedIndexPath) as! EventProductCell
                    cell.topPriorityView.isHidden = !cell.topPriorityView.isHidden
                    
                }
            }
        }
    }
    
    func updateEventPoolToImportant(event: Event, eventPool: EventPool, importantBool: Bool) {
        print(event.id)
        sharedApiManager.updateEventPoolAsImportant(event: event, eventPool: eventPool,setImportant: importantBool) { (eventPool,result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.totalProductsCount = 0
                    if eventPool!.isImportant {
                        self.showMessage(NSLocalizedString("Sobre marcado como importante", comment: "Update success"),type: .success)
                    } else {
                        self.showMessage(NSLocalizedString("Sobre desmarcado como importante", comment: "Update success"),type: .success)
                    }
                    self.eventPools[self.selectedIndexPath.row].isImportant = !(self.eventPools[self.selectedIndexPath.row].isImportant)
                    let cell = self.eventProductsCollectionView.cellForItem(at: self.selectedIndexPath) as! EventPoolCell
                    cell.isPriorityImageView.isHidden = !cell.isPriorityImageView.isHidden
                }
            }
        }
    }
    
    func updateEventProductToCollaborative(eventProduct: EventProduct){
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func prepareForRestartSegment(){
        self.registrySegment.isEnabled = false
        self.nextPageButton.isEnabled = false
        self.lastPageButton.isEnabled = false
        self.firstPageButton.isEnabled = false
        self.backPageButton.isEnabled = false
        self.currentPageLabel.text = ""
        self.totalProductsCount = 0
        self.eventProducts = []
        self.eventPools = []
        self.eventProductsCollectionView.reloadData()
        self.totalProductsCountLabel.text = "Cargando..."
        self.deselectItems()
    }
    
    func getEventProducts(event: Event,available: String, gifted: String, filters: [String : Any]) {
        self.prepareForRestartSegment()
        sharedApiManager.getEventProducts(event: event, available: available, gifted: gifted, filters: filters) { (eventProducts, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.eventProducts = eventProducts!
                    self.totalProductsCount += eventProducts!.count
                    sharedApiManager.getEventProductsPagination(event: event, available: available, gifted: gifted, filters: self.filters) { (pagination, resultPagination) in
                        if let response = resultPagination {
                            if (response.isSuccess()) {
                                self.setPaginationButtons(pagination: pagination!)
                            }
                        }
                    }
                    self.eventProductsCollectionView.reloadData()
                    self.loadTotalProducts()
                }
                self.registrySegment.isEnabled = true
            }
        }
    }
    
    func setPaginationButtons(pagination: Pagination){
        self.pagination = pagination
        self.currentPageLabel.text =
            String(self.pagination.currentPage)
        if(self.pagination.currentPage == 1 && self.pagination.currentPage == self.pagination.totalPages){
            self.nextPageButton.isEnabled = false
            self.lastPageButton.isEnabled = false
            self.firstPageButton.isEnabled = false
            self.backPageButton.isEnabled = false
        }
        else if(self.pagination.currentPage == self.pagination.totalPages){
            self.nextPageButton.isEnabled = false
            self.lastPageButton.isEnabled = false
            self.firstPageButton.isEnabled = true
            self.backPageButton.isEnabled = true
        }
        else if(self.pagination.currentPage == 1){
            self.nextPageButton.isEnabled = true
            self.lastPageButton.isEnabled = true
            self.firstPageButton.isEnabled = false
            self.backPageButton.isEnabled = false
        }
        else{
            self.nextPageButton.isEnabled = true
            self.lastPageButton.isEnabled = true
            self.firstPageButton.isEnabled = true
            self.backPageButton.isEnabled = true
        }
    }
 
    
    func getEventPools(event: Event) {
        sharedApiManager.getEventPools(event: event) {(pools, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.eventPools = pools!
                    self.totalProductsCount += pools!.count
                    self.eventProductsCollectionView.reloadData()
                }
            }
        }
    }
    
    func getEventPoolsTab(event: Event) {
        self.prepareForRestartSegment()
        sharedApiManager.getEventPools(event: event) {(pools, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.eventPools = pools!
                    self.totalProductsCount += pools!.count
                    self.eventProductsCollectionView.reloadData()
//                    sharedApiManager.getEventPoolsPagination(event: self.currentEvent) { (pagination, result) in
//                        if let response = result{
//                            if(response.isSuccess()){
//                                self.setPaginationButtons(pagination: pagination!)
//                            }
//                        }
//                    }
                    self.loadTotalProducts()
                }
            self.registrySegment.isEnabled = true
            }
        }
    }
    
    func loadGiftedAndThanked() {
        self.prepareForRestartSegment()
        sharedApiManager.getGiftThanksSummary(event: self.currentEvent, hasBeenThanked: false, hasBeenPaid: true, filters: self.filters) {(eventProducts, result) in
             if let response = result {
                 if (response.isSuccess()) {
                    self.eventProducts = eventProducts!
                    self.totalProductsCount += eventProducts!.count
                    self.eventProductsCollectionView.reloadData()
                    sharedApiManager.getGiftThanksSummaryPagination(event: self.currentEvent, hasBeenThanked: true, hasBeenPaid: true, filters: self.filters){ (pagination, result) in
                        if let response = result{
                            if(response.isSuccess()){
                                self.setPaginationButtons(pagination: pagination!)
                            }
                        }
                    }
                    self.loadTotalProducts()
                 }
                self.registrySegment.isEnabled = true
             }
         }
      }
    
    func deselectItems() {
        for indexPath in self.eventProductsCollectionView.indexPathsForSelectedItems! {
            self.eventProductsCollectionView.deselectItem(at: indexPath, animated: true)
        }
        if(!self.selectedIndexPath.isEmpty){
            self.selectedIndexPath.dropLast()
        }
        self.checkIfSelectedCells()
    }
    
}
extension ProductsRegistryViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == 0) ? self.eventProducts.count : self.eventPools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventProductCell", for: indexPath) as! EventProductCell
            cell.paidAmount.barHeight = 10
           
            //icons initialization
            cell.creditedIcon.isHidden = true
            cell.deliveredIcon.isHidden = true
            cell.thankedIcon.isHidden = true
            cell.topPriorityView.isHidden = true
            cell.eventProductImageView.image =  UIImage(named: "cliftplaceholder")!
            
            cell.creditedIcon.image = nil
            cell.deliveredIcon.image = nil
            cell.thankedIcon.image = nil
            
            if !cell.isSelected{
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.layer.cornerRadius = 4
                cell.layer.borderWidth = 0
                cell.isSelected = false
            }else{
                cell.layer.cornerRadius = 4
                cell.layer.borderColor = UIColor.green.cgColor
                cell.layer.borderWidth = 1
                cell.isSelected = true
            }
            
             cell.setup(eventProduct: self.eventProducts[indexPath.row])
            
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventPoolCell", for: indexPath) as! EventPoolCell
            
            cell.eventPoolImageView.image = UIImage(named: "cliftplaceholder")!
            cell.isPriorityImageView.isHidden = true
            
            if !cell.isSelected{
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.layer.cornerRadius = 4
                cell.layer.borderWidth = 0
                cell.isSelected = false
            }else{
                cell.layer.cornerRadius = 4
                cell.layer.borderColor = UIColor.green.cgColor
                cell.layer.borderWidth = 1
                cell.isSelected = true
            }
            
            cell.setup(eventPool: self.eventPools[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.selectedIndexPath == indexPath){
            self.collectionView(collectionView, didDeselectItemAt: indexPath)
            self.deselectItems()
        }else{
            self.selectedIndexPath = indexPath
            self.checkIfSelectedCells()
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.cornerRadius = 4
            cell?.layer.borderColor = UIColor(hue: 0.3556, saturation: 0.7, brightness: 0.7, alpha: 1.0).cgColor
            cell?.layer.borderWidth = 3
            cell?.isSelected = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.checkIfSelectedCells()
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.cornerRadius = 4
        cell?.layer.borderWidth = 0
        cell?.isSelected = false
        self.eventProductsCollectionView.deselectItem(at: indexPath, animated: true)
        self.selectedIndexPath = self.selectedIndexPath.dropLast()
    }
    
    func checkIfSelectedCells() {
        if (self.eventProductsCollectionView.indexPathsForSelectedItems!.count > 0) {
            self.addProductsToRegistryButton.isHidden = true
            self.actionButton.isHidden = false
            self.filterButton.isHidden = true
        } else {
            self.addProductsToRegistryButton.isHidden = false
            self.actionButton.isHidden = true
            self.filterButton.isHidden = false
        }
    }
}
