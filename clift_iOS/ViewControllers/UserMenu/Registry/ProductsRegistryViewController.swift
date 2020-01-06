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
    var eventProducts = [EventProduct]()
    var eventPools = [EventPool]()
    var giftedSelected = ""
    var availableSelected = ""
    let buttonBar = UIView()
    var selectedIndexPaths = [IndexPath]()
    var totalProductsCount = Int()
    @IBOutlet weak var addProductsToRegistryButton: customButton!
    @IBOutlet weak var actionButton: customButton!
    
    @IBOutlet weak var totalProductsCountLabel: UILabel!
    @IBOutlet weak var eventProductsCollectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var registrySegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventProductsCollectionView.delegate = self
        self.eventProductsCollectionView.dataSource = self
        self.eventProductsCollectionView.allowsMultipleSelection = false
        self.styleSegmentControl()
        self.loadEvent()
        self.getEventProducts(event: currentEvent, available: availableSelected, gifted: giftedSelected, filters: [:])
    }
    
    func loadTotalProducts() {
        self.totalProductsCountLabel.text = "\(self.totalProductsCount) artículos"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.totalProductsCount = 0
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
       
//        if self.registrySegment.selectedSegmentIndex == 1 {
//            self.addProductsToRegistryButton.isHidden = true
//            self.actionButton.isHidden = false
//            self.filterButton.isHidden = true
//        } else {
//            self.addProductsToRegistryButton.isHidden = false
//            self.actionButton.isHidden = true
//            self.filterButton.isHidden = false
//        }
      
        
    }
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        self.totalProductsCount = 0
        if registrySegment.selectedSegmentIndex == 0 {
                  self.getEventProducts(event: self.currentEvent, available: "", gifted: "", filters: [:])
              }else if registrySegment.selectedSegmentIndex == 1 {
                 self.getEventProducts(event: self.currentEvent, available: self.currentEvent.id, gifted: "", filters: [:])
              } else {
                   self.getEventProducts(event: self.currentEvent, available: "", gifted: self.currentEvent.id, filters: [:])
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
            .Key.foregroundColor: UIColor(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)], for: .normal)
        self.registrySegment.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0)], for: .selected)
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0)
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
        for indexPath in selectedIndexPaths {
            let eventProductImportantBool = self.eventProducts[indexPath.row].isImportant
            
            self.updateEventProductToImportant(eventProduct: self.eventProducts[indexPath.row],importantBool: !eventProductImportantBool)
        }
    }
    
    func collaborativeActionButtonPressed(alert: UIAlertAction) {
        for indexPath in selectedIndexPaths {
                 let eventProductCollaborativeBool = self.eventProducts[indexPath.row].isCollaborative
                 
                 self.updateEventProductToCollaborative(eventProduct: self.eventProducts[indexPath.row],collaborativeBool:  !eventProductCollaborativeBool)
             }
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        let sheet = UIAlertController(title: "Acciones", message: nil, preferredStyle: .actionSheet)
        let setAsImportant = UIAlertAction(title: "Marcar como lo más importante", style: .default, handler: importantActionButtonPressed(alert:))
            
               let buyAction = UIAlertAction(title: "Comprar", style: .default)
               let removeFromRegistry = UIAlertAction(title: "Quitar de mesa", style: .default)
        let makeCollaborativeGift = UIAlertAction(title: "Convertir a regalo grupal", style: .default, handler: collaborativeActionButtonPressed(alert:))
               let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
               
              setAsImportant.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
                buyAction.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
               removeFromRegistry.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
        makeCollaborativeGift.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
               cancelAction.setValue(UIColor.init(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0), forKey: "titleTextColor")
        
               sheet.addAction(setAsImportant)
               sheet.addAction(buyAction)
               sheet.addAction(removeFromRegistry)
                sheet.addAction(makeCollaborativeGift)
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
                    self.getEventProducts(event: self.currentEvent,available: self.availableSelected, gifted: self.giftedSelected, filters: [:])
                    self.deselectItems()
                    self.eventProductsCollectionView.reloadData()
                }
            }
        }
    }
    
    func updateEventProductToCollaborative(eventProduct: EventProduct, collaborativeBool: Bool) {
        sharedApiManager.updateEventProductAsCollaborative(eventProduct: eventProduct, setCollaborative: collaborativeBool) { (eventProduct, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.totalProductsCount = 0
                    if eventProduct!.isCollaborative {
                        self.showMessage(NSLocalizedString("Producto marcado como colaborativo", comment: "Update success"),type: .success)
                    } else {
                        self.showMessage(NSLocalizedString("Producto desmarcado como colaborativo", comment: "Update success"),type: .success)
                    }
                    self.getEventProducts(event: self.currentEvent,available: self.availableSelected, gifted: self.giftedSelected, filters: [:])
                    self.deselectItems()
                    self.eventProductsCollectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getEventProducts(event: Event,available: String, gifted: String, filters: [String : Any]) {
        sharedApiManager.getEventProducts(event: event, available: available, gifted: gifted, filters: filters) { (eventProducts, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.eventProducts = eventProducts!
                    self.totalProductsCount += eventProducts!.count
                    self.getEventPools(event: self.currentEvent)
                }
            }
        }
    }
    
    func getEventPools(event: Event) {
        sharedApiManager.getEventPools(event: event) {(pools, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.eventPools = pools!
                    self.totalProductsCount += pools!.count
                    self.loadTotalProducts()
                    self.eventProductsCollectionView.reloadData()
                }
            }
        }
    }
    
    func deselectItems() {
        for indexPath in self.eventProductsCollectionView.indexPathsForSelectedItems! {
            self.eventProductsCollectionView.deselectItem(at: indexPath, animated: true)
        }
        self.selectedIndexPaths.removeAll()
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
            
            cell.setup(eventProduct: self.eventProducts[indexPath.row])
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventPoolCell", for: indexPath) as! EventPoolCell
            cell.setup(eventPool: self.eventPools[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPaths.append(indexPath)
        self.checkIfSelectedCells()
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.cornerRadius = 4
        cell?.layer.borderColor = UIColor.green.cgColor
        cell?.layer.borderWidth = 1
        cell?.isSelected = true
        print("selected")
        print(self.selectedIndexPaths)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.checkIfSelectedCells()
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.cornerRadius = 4
        cell?.layer.borderWidth = 0
        cell?.isSelected = false
        print("deselected")
        self.eventProductsCollectionView.deselectItem(at: indexPath, animated: true)
        self.selectedIndexPaths = self.selectedIndexPaths.dropLast()
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
