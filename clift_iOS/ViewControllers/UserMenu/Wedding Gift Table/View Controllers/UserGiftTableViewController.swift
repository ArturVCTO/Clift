//
//  UserGiftTableViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 03/02/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit
import SideMenu

class UserGiftTableViewController: UIViewController {
    
    @IBOutlet weak var menuContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var orderByView: UIView!
    @IBOutlet weak var orderByInnerView: UIView!
    @IBOutlet weak var orderByFirstButton: UIButton!
    @IBOutlet weak var orderBySecondButton: UIButton!
    @IBOutlet weak var orderByThirdButton: UIButton!
    @IBOutlet weak var orderByFourthButton: UIButton!
    @IBOutlet var smallViewOrderByConstraint: NSLayoutConstraint!
    @IBOutlet weak var largeViewOrderByConstraint: NSLayoutConstraint!
    @IBOutlet weak var paginationLabel: UILabel!
    @IBOutlet weak var paginationStackViewButtons: UIStackView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var goToStoreButton: UIButton!
    
    @IBOutlet weak var productsCollectionView: UICollectionView! {
        didSet {
            productsCollectionView.delegate = self
            productsCollectionView.dataSource = self
        }
    }
    
    //Pages Menu
    @IBOutlet weak var backMenuContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var backMenuContainerView: UIView!
    @IBOutlet weak var backMenuButton: UIButton!
    @IBOutlet weak var nextMenuButton: UIButton!
    
    //First Button
    @IBOutlet weak var firstMenuButtonContainerView: UIView!
    @IBOutlet weak var firstMenuButton: UIButton!
    
    //Second Button
    @IBOutlet weak var secondButtonContainerView: UIView!
    @IBOutlet weak var secondButton: UIButton!
    
    //Third Button
    @IBOutlet weak var thirdButtonContainerView: UIView!
    @IBOutlet weak var thirdButton: UIButton!
    
    
    var currentEvent = Event()
    var eventRegistries: [EventProduct]! = []
    var eventPools: [EventPool]! = []
    var orderByViewSizeFlag = true
    var filtersDic: [String: Any] = ["shop":"","category":"","price_range":""]
    var currentOrder: sortKeys = .nameAscending
    
    private var actualPage = 1
    private var numberOfPages = 0
    private let selectedButtonColor = UIColor(red: 0.1961, green: 0.1882, blue: 0.2314, alpha: 1)
    
    private var firstButtonValue = 1
    private var secondButtonValue = 2
    private var thirdButtonValue = 3
    
    var lastButtonPressed: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsCollectionView.collectionViewLayout = layout

        getPoolsAndRegistries()
        setNavBar()
        registerCells()
        setPaginationMenu()
        setup(event: currentEvent)
        selectButton(button: firstMenuButton)
    }
        
    func setNavBar() {
        
        let titleLabel = UILabel()
        titleLabel.text = "MESA DE REGALO"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Mihan-Regular", size: 16.0)!
        titleLabel.addCharactersSpacing(5)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel

        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
    
    func setup(event: Event) {
        orderByView.layer.cornerRadius = 10
        orderByInnerView.layer.cornerRadius = 10
        filterView.layer.cornerRadius = 10
        goToStoreButton.layer.cornerRadius = 5
    }
    
    private func registerCells() {
        productsCollectionView.register(UINib(nibName: "UserEventProductCell", bundle: nil), forCellWithReuseIdentifier: "UserEventProductCell")
    }
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 150, height: 300)
        return layout
    }()
    
    private func setCollectionViewHeight() {
        collectionViewHeight.constant = CGFloat(productsCollectionView.collectionViewLayout.collectionViewContentSize.height)
    }
    
    private func displayEmptyState() {
        scrollView.isHidden = true
        emptyStateView.isHidden = false
    }
    
    private func displayGiftTable() {
        scrollView.isHidden = false
        emptyStateView.isHidden = true
    }
    
    @IBAction func goToStorePressed(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    @IBAction func didTapFilterButton(_ sender: UIButton) {
        
        let FilterSelectionVC = UIStoryboard(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "FilterSelectionVC") as! FilterSelectionViewController
        FilterSelectionVC.sideFilterSelectionDelegate = self
        FilterSelectionVC.categorySelectedId = filtersDic["category"] as! String
        FilterSelectionVC.priceSelectedId = filtersDic["price_range"] as! String
        FilterSelectionVC.shopSelectedId = filtersDic["shop"] as! String
        let menu = UISideMenuNavigationController(rootViewController: FilterSelectionVC)
        SideMenuManager.default.leftMenuNavigationController = menu
        menu.presentationStyle = .menuSlideIn
        menu.statusBarEndAlpha = 0
        menu.menuWidth = UIScreen.main.bounds.size.width * 0.8
        present(menu,animated: true, completion: nil)
    }
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        actualPage = 1
        getEventProducts()
    }
    
    @IBAction func rightButtonPressed(_ sender: Any) {
        actualPage = numberOfPages
        getEventProducts()
    }
    
    @IBAction func firstButtonPressed(_ sender: Any) {
        actualPage = firstButtonValue
        lastButtonPressed = firstMenuButton
        setButtonValues()
        addOrDeleteMenuButtonsDependingOnNumberOfPages()
        getEventProducts()
    }
    
    @IBAction func secondButtonPressed(_ sender: Any) {
        actualPage = secondButtonValue
        lastButtonPressed = secondButton
        setButtonValues()
        addOrDeleteMenuButtonsDependingOnNumberOfPages()
        getEventProducts()
    }
    
    @IBAction func thirdButtonPressed(_ sender: Any) {
        actualPage = thirdButtonValue
        lastButtonPressed = thirdButton
        setButtonValues()
        addOrDeleteMenuButtonsDependingOnNumberOfPages()
        getEventProducts()
    }
    
}

// MARK: Extension REST APIs
extension UserGiftTableViewController {
    
    func getPoolsAndRegistries(){
        
        sharedApiManager.getEventPools(event: currentEvent) {(pools, result) in
            self.presentLoader()
            if let response = result {
                if (response.isSuccess()) {
                    self.eventPools = pools
                }
            }
            self.getEventProducts()
        }
    }
    
    func getEventProducts() {
        
        self.presentLoader()
        eventRegistries.removeAll()
        reloadCollectionView()
        filtersDic["page"] = actualPage
        filtersDic["sort_by"] = currentOrder.rawValue
        
        sharedApiManager.getEventProducts(event: currentEvent, available: "", gifted: "", filters: filtersDic) { (eventProducts, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.eventRegistries = eventProducts!
                    
                    guard let json = try? JSONSerialization.jsonObject(with: response.data,
                                                                       options: []) as? [String: Any],
                          let meta = json["meta"] as? [String: Any],
                          let pagination = Pagination(JSON: meta) else {
                        return
                    }
                    self.actualPage = pagination.currentPage
                    self.numberOfPages = pagination.totalPages
                    self.paginationLabel.text = "Mostrando del \(pagination.from) al \(pagination.to) de \(pagination.totalCount)"
                    self.reloadCollectionView()
                }
            }
            self.setPaginationMenu()
            self.setButtonValues()
            self.addOrDeleteMenuButtonsDependingOnNumberOfPages()
            self.lastButtonPressed = nil
            self.dismissLoader()
            if self.eventPools.isEmpty && self.eventRegistries.isEmpty {
                self.displayEmptyState()
            } else {
                self.displayGiftTable()
            }
        }
    }
    
    func updateEventProductToImportant(eventProduct: EventProduct, importantBool: Bool) {
        
        sharedApiManager.updateEventProductAsImportant(eventProduct: eventProduct,setImportant: importantBool) { (eventProduct,result) in
            if let response = result {
                if (response.isSuccess()) {
                    if eventProduct!.isImportant {
                        self.showMessage(NSLocalizedString("Producto marcado como importante", comment: "Update success"),type: .success)
                    } else {
                        self.showMessage(NSLocalizedString("Producto desmarcado como importante", comment: "Update success"),type: .success)
                    }
                    if let productUpdatedIndex = self.eventRegistries.firstIndex(where: {$0.id == eventProduct?.id}) {
                        self.eventRegistries[productUpdatedIndex].isImportant = importantBool
                        self.productsCollectionView.reloadItems(at: [IndexPath(row: productUpdatedIndex + self.eventPools.count, section: 0)])
                    }
                }
            }
        }
    }
    
    func updateEventPoolToImportant(event: Event, oldEventPool: EventPool, importantBool: Bool) {

        sharedApiManager.updateEventPoolAsImportant(event: event, eventPool: oldEventPool,setImportant: importantBool) { (eventPool,result) in
            if let response = result {
                if (response.isSuccess()) {
                    if !oldEventPool.isImportant {
                        self.showMessage(NSLocalizedString("Sobre marcado como importante", comment: "Update success"),type: .success)
                    } else {
                        self.showMessage(NSLocalizedString("Sobre desmarcado como importante", comment: "Update success"),type: .success)
                    }
                    if let poolUpdatedIndex = self.eventPools.firstIndex(where: {$0.id == oldEventPool.id}) {
                        self.eventPools[poolUpdatedIndex].isImportant = importantBool
                        self.productsCollectionView.reloadItems(at: [IndexPath(row: poolUpdatedIndex, section: 0)])
                    }
                }
            }
        }
    }
    
    func removeProductFromRegistry(eventProduct: EventProduct,event: Event) {
        
        sharedApiManager.deleteEventProduct(eventProduct: eventProduct, event: event) { (emptyObject, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.showMessage(NSLocalizedString("Producto se ha quitado de tu mesa", comment: "Removed Product Success"),type: .success)
                    self.getEventProducts()
                    self.reloadCollectionView()
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
                    self.getPoolsAndRegistries()
                    self.reloadCollectionView()
                } else {
                    self.showMessage(NSLocalizedString("\(emptyObject?.errors.first ?? "Error, intente de nuevo más tarde.")", comment: "Remove  Error"),type: .error)
                }
            }
        }
    }
    
    func convertToIndividualGift(eventProduct: EventProduct) {
        
        sharedApiManager.updateEventProductAsCollaborative(eventProduct: eventProduct, setCollaborative: false, collaborators: 0) { (_, response) in
            if let result = response{
                if result.isSuccess() {
                    if let productUpdatedIndex = self.eventRegistries.firstIndex(where: {$0.id == eventProduct.id}) {
                        self.eventRegistries[productUpdatedIndex].isCollaborative = false
                        self.eventRegistries[productUpdatedIndex].collaborators = 0
                        self.productsCollectionView.reloadItems(at: [IndexPath(row: productUpdatedIndex + self.eventPools.count, section: 0)])
                    }
                    self.showMessage(NSLocalizedString("Porducto actualizado como individual", comment: "Producto actualizado"), type: .success)
                }else{
                    self.showMessage(NSLocalizedString("Error de servidor, intente de nuevo más tarde", comment: "Error"), type: .error)
                }
            }
        }
    }
}

// MARK: Extension OrderBy
extension UserGiftTableViewController {
    
    @IBAction func didTapOrderByButton(_ sender: UITapGestureRecognizer) {
        
        if orderByViewSizeFlag {
            setLargeOrderByView()
        } else {
            setSmallOrderByView()
        }
        orderByViewSizeFlag = !orderByViewSizeFlag
    }
    
    func setSmallOrderByView() {
        
        largeViewOrderByConstraint.isActive = false
        smallViewOrderByConstraint.isActive = true
        
        orderByFirstButton.isHidden = true
        orderBySecondButton.isHidden = true
        orderByThirdButton.isHidden = true
        orderByFourthButton.isHidden = true
    }
    
    func setLargeOrderByView() {
        
        smallViewOrderByConstraint.isActive = false
        largeViewOrderByConstraint.isActive = true
        
        orderByFirstButton.isHidden = false
        orderBySecondButton.isHidden = false
        orderByThirdButton.isHidden = false
        orderByFourthButton.isHidden = false
    }
    
    @IBAction func didTapOrderByLowPrice(_ sender: UIButton) {
        currentOrder = .priceAscending
        getEventProducts()
    }
    
    @IBAction func didTapOrderByHighPrice(_ sender: UIButton) {
        currentOrder = .priceDescending
        getEventProducts()
    }
    
    @IBAction func didTapOrderByAZ(_ sender: UIButton) {
        currentOrder = .nameAscending
        getEventProducts()
    }
    
    @IBAction func didTapOrderByZA(_ sender: UIButton) {
        currentOrder = .nameDescending
        getEventProducts()
    }
}

// MARK: Extension FilterBy
extension UserGiftTableViewController: SideFilterSelectionDelegate {
    func didTapCleanFilters() {
        filtersDic["category"] = ""
        filtersDic["price_range"] = ""
        filtersDic["shop"] = ""
    }
    
    func didTapCategoryFilter(categoryId: String) {
        filtersDic["category"] = categoryId
    }
    
    func didTapPriceFilter(priceQuery: String) {
        filtersDic["price_range"] = priceQuery
    }
    
    func didTapShopFilter(shopId: String) {
        filtersDic["shop"] = shopId
    }
}

// MARK: Extension Collection View Delegate and Data Source
extension UserGiftTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventPools.count + eventRegistries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: "UserEventProductCell", for: indexPath) as? UserEventProductCell {
            
            cell.userProductCellDelegate = self
            //Set Pool Cells and Product Cells
            if eventPools.count > indexPath.row {
                cell.cellType = .EventPool
                cell.configure(pool: eventPools[indexPath.row])
            } else {
                if eventRegistries[indexPath.row - eventPools.count].wishableType == "ExternalProduct" {
                    cell.cellType = .EventExternalProduct
                    cell.configure(product: eventRegistries[indexPath.row - eventPools.count])
                } else {
                    cell.cellType = .EventProduct
                    cell.configure(product: eventRegistries[indexPath.row - eventPools.count])
                }
            }
            cell.cellWidth = (collectionView.frame.size.width - 25) / 2
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row >= eventPools.count {
            let productDetailsVC = UIStoryboard(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsViewController
            productDetailsVC.currentEventProduct = eventRegistries[indexPath.row - eventPools.count]
            productDetailsVC.currentEvent = currentEvent
            productDetailsVC.showAddProductToCart = false
            productDetailsVC.productDetailType = eventRegistries[indexPath.row - eventPools.count].wishableType == "ExternalProduct" ? .EventExternalProduct : .EventProduct
            productDetailsVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(productDetailsVC, animated: true)
        }
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.productsCollectionView.reloadData()
            self.setCollectionViewHeight()
        }
    }
}

//MARK:- Extension ProductCellDelegate
extension UserGiftTableViewController: UserProductCellDelegate {
    
    func didTapStarProduct(eventProduct: EventProduct) {
        updateEventProductToImportant(eventProduct: eventProduct, importantBool: !eventProduct.isImportant)
    }
    
    func didTapStarPool(eventPool: EventPool) {
        updateEventPoolToImportant(event: currentEvent, oldEventPool: eventPool, importantBool: !eventPool.isImportant)
    }
    
    func didTapMoreOptions(cellType: ProductCellType, eventPool: EventPool, eventProduct: EventProduct) {
        
        let sheet = UIAlertController(title: "Acciones", message: nil, preferredStyle: .actionSheet)
        
        var setAsImportant: UIAlertAction
        if cellType == .EventPool {
            if (eventPool.isImportant){
                setAsImportant = UIAlertAction(title: "Desmarcar como importante", style: .default, handler: {(action) in self.importantActionButtonPressedPool(eventPool: eventPool)})
            } else {
                setAsImportant = UIAlertAction(title: "Marcar como importante", style: .default, handler: {(action) in self.importantActionButtonPressedPool(eventPool: eventPool)})
            }
        } else {
            if (eventProduct.isImportant){
                setAsImportant = UIAlertAction(title: "Desmarcar como importante", style: .default, handler: {(action) in self.importantActionButtonPressedProduct(eventProduct: eventProduct)})
            } else {
                setAsImportant = UIAlertAction(title: "Marcar como importante", style: .default, handler: {(action) in self.importantActionButtonPressedProduct(eventProduct: eventProduct)})
            }
        }
        
        //SOLO PARA REGALOS
        var makeCollaborativeGift: UIAlertAction
        var makeIndividualGift: UIAlertAction
        var removeFromRegistry: UIAlertAction
        var seeMoreInfoProduct: UIAlertAction
        if cellType == .EventProduct || cellType == .EventExternalProduct { //Productos
              
            if (!eventProduct.isCollaborative && eventProduct.gifted_quantity == 0  && eventProduct.product.price>=2000){
                //CONVERTIR A REGALO GRUPAL
                makeCollaborativeGift = UIAlertAction(title: "Convertir a regalo colaborativo", style: .default, handler: {(action) in self.collaborativeActionButtonPressed(eventProduct: eventProduct)})
                makeCollaborativeGift.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
                makeCollaborativeGift.setValue(UIImage(named: "addmanualcolab"), forKey: "image")
                sheet.addAction(makeCollaborativeGift)
            }
            
            if (eventProduct.isCollaborative && eventProduct.gifted_quantity == 0){
                makeIndividualGift = UIAlertAction(title: "Convertir a regalo individual", style: .default, handler: {(action) in self.individualActionButtonPressed(eventProduct: eventProduct)})
                makeIndividualGift.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
                makeIndividualGift.setValue(UIImage(named: "infoprofileic"), forKey: "image")
                sheet.addAction(makeIndividualGift)
            }
            
            //VER INFORMACION DE PRODUCTO
            seeMoreInfoProduct = UIAlertAction(title: "Ver información de producto", style: .default, handler: {(action) in self.addMoreInfoProductView(eventProduct: eventProduct)})
            seeMoreInfoProduct.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
            seeMoreInfoProduct.setValue(UIImage(named: "icsearch"), forKey: "image")
            sheet.addAction(seeMoreInfoProduct)
            
            if (eventProduct.gifted_quantity == 0){
                removeFromRegistry = UIAlertAction(title: "Quitar producto de mesa", style: .destructive,handler: {(action) in self.removeProductButtonPressed(eventProduct: eventProduct)})
                removeFromRegistry.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
                removeFromRegistry.setValue(UIImage(named: "icremove"), forKey: "image")
                sheet.addAction(removeFromRegistry)
            }
        } else if(Float(eventPool.collectedAmount) == 0) { //Pools
            removeFromRegistry = UIAlertAction(title: "Quitar sobre de mesa", style: .destructive,handler: {(action) in self.removePoolButtonPressed(eventPool: eventPool)})
            removeFromRegistry.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
            removeFromRegistry.setValue(UIImage(named: "icremove"), forKey: "image")
            sheet.addAction(removeFromRegistry)
        }
            
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
               
        setAsImportant.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
        setAsImportant.setValue(UIImage(named: "addmanualfav"), forKey: "image")
        
        cancelAction.setValue(UIColor.init(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0), forKey: "titleTextColor")
        cancelAction.setValue(UIImage(named: "icnotassisting"), forKey: "image")
    
        sheet.addAction(setAsImportant)
        sheet.addAction(cancelAction)
       
        present(sheet, animated: true, completion: nil)
    }
}

//MARK:- Extension More Options Functions
extension UserGiftTableViewController {
    
    func importantActionButtonPressedPool(eventPool: EventPool) {
        updateEventPoolToImportant(event: currentEvent, oldEventPool: eventPool, importantBool: !eventPool.isImportant)
    }
    
    func importantActionButtonPressedProduct(eventProduct: EventProduct) {
        updateEventProductToImportant(eventProduct: eventProduct, importantBool: !eventProduct.isImportant)
    }
    
    func collaborativeActionButtonPressed(eventProduct: EventProduct) {
        let numberOfCollaboratorsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "numberOfCollaboratorsVC") as! NumberOfCollaboratorsViewController
        numberOfCollaboratorsVC.numberOfCollaboratorsViewControllerDelegate = self
        numberOfCollaboratorsVC.eventProduct = eventProduct
        self.parent?.addChild(numberOfCollaboratorsVC)
        numberOfCollaboratorsVC.view.frame = self.view.frame
        self.parent?.view.addSubview(numberOfCollaboratorsVC.view)
        numberOfCollaboratorsVC.didMove(toParent: self)
    }
    
    func individualActionButtonPressed(eventProduct: EventProduct) {
        
        convertToIndividualGift(eventProduct: eventProduct)
    }
    
    func addMoreInfoProductView(eventProduct: EventProduct){
        let productInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "productInfoVC") as!
        ProductInformationTableViewController
        
        let productDetailsVC = UIStoryboard(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsViewController
        productDetailsVC.currentEventProduct = eventProduct
        productDetailsVC.currentEvent = currentEvent
        productDetailsVC.showAddProductToCart = false
        productDetailsVC.productDetailType = eventProduct.wishableType == "ExternalProduct" ? .EventExternalProduct : .EventProduct
        productDetailsVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
    }
    
    func removeProductButtonPressed(eventProduct: EventProduct) {
        self.removeProductFromRegistry(eventProduct: eventProduct, event: currentEvent)
    }
    
    func removePoolButtonPressed(eventPool: EventPool) {
        self.removePoolFromRegistry(eventPool: eventPool, event: currentEvent)
    }
}

//MARK:- NumberOfCollaboratorsViewControllerDelegate
extension UserGiftTableViewController:NumberOfCollaboratorsViewControllerDelegate {
    func didChangeToCollaborativeProduct(eventProduct: EventProduct) {
        
        if let productUpdatedIndex = self.eventRegistries.firstIndex(where: {$0.id == eventProduct.id}) {
            self.eventRegistries[productUpdatedIndex] = eventProduct
            self.productsCollectionView.reloadItems(at: [IndexPath(row: productUpdatedIndex + self.eventPools.count, section: 0)])
        }
    }
}
//MARK:- Extension UISideMenuNavigationControllerDelegate
extension UserGiftTableViewController: UISideMenuNavigationControllerDelegate {

        func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
            getEventProducts()
        }
}

//MARK:- Extension Pagination Menu
extension UserGiftTableViewController {
    
    private func setButtonValues() {
        let remainingPages = numberOfPages - actualPage
        guard actualPage != 1 else {
            firstButtonValue = 1
            secondButtonValue = 2
            thirdButtonValue = 3
            selectButton(button: firstMenuButton)
            return
        }
        if remainingPages == 0, let lastButtonPressed = lastButtonPressed {
            selectButton(button: lastButtonPressed)
            return
        } else if remainingPages == 0 {
            //This case is a next button pressed so we need to now how many buttons we have to give them the text number
            if thirdButtonContainerView.isHidden && secondButtonContainerView.isHidden {
                firstButtonValue = actualPage
                selectButton(button: firstMenuButton)
                return
            }
            if thirdButtonContainerView.isHidden {
                firstButtonValue = actualPage - 1
                secondButtonValue = actualPage
                selectButton(button: secondButton)
                return
            }
            firstButtonValue = actualPage - 2
            secondButtonValue = actualPage - 1
            thirdButtonValue = actualPage
            selectButton(button: thirdButton)
            return
        }
        firstButtonValue = actualPage - 1
        selectButton(button: secondButton)
        secondButtonValue = actualPage
        thirdButtonValue = actualPage + 1
    }
    
    private func setPaginationMenu() {
        let borderColor = UIColor(red: 0.9333, green: 0.9333, blue: 0.9294, alpha: 1)
        setMenuContainerViewCornerRadius(borderColor: borderColor)
        setButtons()
        unselectAllButtons()
    }
    
    private func setMenuContainerViewCornerRadius(borderColor: UIColor) {
        menuContainerView.layer.cornerRadius = 10
        menuContainerView.layer.borderWidth = 2.0
        menuContainerView.layer.borderColor = borderColor.cgColor
    }
    
    private func setButtons() {
        setButtonContainerWidth()
        addOrDeleteMenuButtonsDependingOnNumberOfPages()
    }
    
    private func setButtonContainerWidth() {
        var numberOfButtons = numberOfPages
        if numberOfPages >= 3 {
            numberOfButtons = 3
        }
        let buttonsWidth: CGFloat = (buttonContainerWidth.constant * CGFloat(numberOfButtons))
        let newWidth: CGFloat = (backMenuContainerWidth.constant + backMenuContainerWidth.constant ) + buttonsWidth
        menuContainerWidth.constant = newWidth
    }
    
    /// This functions adds or deletes buttons in the pagination menu depending on the number of pages
    func addOrDeleteMenuButtonsDependingOnNumberOfPages() {
        
        let borderColor = UIColor(red: 0.9333, green: 0.9333, blue: 0.9294, alpha: 1)
        let width:CGFloat = 2.0
        
        if numberOfPages == 1 {
            firstMenuButtonContainerView.isHidden = false
            secondButtonContainerView.isHidden = true
            thirdButtonContainerView.isHidden = true
            addLeftAndRightCorners(button: firstMenuButtonContainerView,
                                   color: borderColor,
                                   width: width)
        }
        
        if numberOfPages == 2 {
            firstMenuButtonContainerView.isHidden = false
            secondButtonContainerView.isHidden = false
            thirdButtonContainerView.isHidden = true
            firstMenuButtonContainerView.addLeftBorder(with: borderColor, andWidth: width)
            addLeftAndRightCorners(button: secondButtonContainerView, color: borderColor, width: width)
        }
        
        if numberOfPages >= 3 {
            firstMenuButtonContainerView.isHidden = false
            secondButtonContainerView.isHidden = false
            thirdButtonContainerView.isHidden = false
            firstMenuButtonContainerView.addLeftBorder(with: borderColor, andWidth: width)
            addLeftAndRightCorners(button: secondButtonContainerView, color: borderColor, width: width)
            thirdButton.addRightBorder(with: borderColor, andWidth: width)
        }
        
        if numberOfPages == 0 {
            firstMenuButtonContainerView.isHidden = true
            secondButtonContainerView.isHidden = true
            thirdButtonContainerView.isHidden = true
        }
        
        updateMenuButtonsText()
        
    }
    
    private func updateMenuButtonsText() {
        firstMenuButton.titleLabel?.font = UIFont(name: "Mihan-Regular", size: 14.0)!
        secondButton.titleLabel?.font = UIFont(name: "Mihan-Regular", size: 14.0)!
        thirdButton.titleLabel?.font = UIFont(name: "Mihan-Regular", size: 14.0)!
        firstMenuButton.setTitle(String(firstButtonValue), for: .normal)
        secondButton.setTitle(String(secondButtonValue), for: .normal)
        thirdButton.setTitle(String(thirdButtonValue), for: .normal)
    }
    
    func addLeftAndRightCorners(button: UIView, color: UIColor, width: CGFloat) {
        button.addLeftBorder(with: color, andWidth: width)
        button.addRightBorder(with: color, andWidth: width)
    }
    
    private func unselectAllButtons() {
        unselectButton(button: firstMenuButton)
        unselectButton(button: secondButton)
        unselectButton(button: thirdButton)
    }
    
    private func unselectButton(button: UIButton) {
        button.titleLabel?.font = UIFont(name: "Mihan-Regular", size: 20.0)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
    }
    
    private func selectButton(button: UIButton) {
        unselectAllButtons()
        button.titleLabel?.font = UIFont(name: "Mihan-Regular", size: 20.0)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = selectedButtonColor
        
    }
    
}
