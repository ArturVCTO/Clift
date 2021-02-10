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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var menuContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var filerView: UIView!
    @IBOutlet weak var orderByView: UIView!
    @IBOutlet weak var orderByInnerView: UIView!
    @IBOutlet weak var orderByFirstButton: UIButton!
    @IBOutlet weak var orderBySecondButton: UIButton!
    @IBOutlet weak var orderByThirdButton: UIButton!
    @IBOutlet weak var orderByFourthButton: UIButton!
    @IBOutlet weak var smallViewOrderByConstraint: NSLayoutConstraint!
    @IBOutlet weak var largeViewOrderByConstraint: NSLayoutConstraint!
    @IBOutlet weak var paginationLabel: UILabel!
    @IBOutlet weak var paginationStackViewButtons: UIStackView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
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
    var filtersDic: [String: Any] = ["shop":"","category":"","price":""]
    var currentOrder: sortKeys = .nameAscending
    var isSearchBarHIdden = true
    var availableSelected = ""
    var giftedSelected = ""
    
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
        searchBar.delegate = self

        getPoolsAndRegistries()
        setNavBar()
        registerCells()
        setPaginationMenu()
        setup(event: currentEvent)
        selectButton(button: firstMenuButton)
    }
        
    func setNavBar() {
        
        navigationItem.title = "MESA DE REGALO"
        
        let searchImage = UIImage(named: "searchicon")
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton(sender:)))
        navigationItem.rightBarButtonItems = [searchButton]
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }

    @objc func didTapSearchButton(sender: AnyObject){
        if isSearchBarHIdden {
            searchBar.isHidden = false
        } else {
            searchBar.isHidden = true
        }
        
        isSearchBarHIdden = !isSearchBarHIdden
    }
    
    func setup(event: Event) {
        orderByView.layer.cornerRadius = 10
        orderByInnerView.layer.cornerRadius = 10
        filerView.layer.cornerRadius = 10
    }
    
    private func registerCells() {
        productsCollectionView.register(UINib(nibName: "UserEventProductCell", bundle: nil), forCellWithReuseIdentifier: "UserEventProductCell")
    }
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 150, height: 280)
        return layout
    }()
    
    private func setCollectionViewHeight() {
        collectionViewHeight.constant = CGFloat(productsCollectionView.collectionViewLayout.collectionViewContentSize.height)
    }
    
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
    
    func getEventProducts(available: String = "", gifted: String = "") {
        
        self.presentLoader()
        eventRegistries.removeAll()
        reloadCollectionView()
        filtersDic["page"] = actualPage
        filtersDic["sort_by"] = currentOrder.rawValue
        
        sharedApiManager.getEventProducts(event: currentEvent, available: available, gifted: gifted, filters: filtersDic) { (eventProducts, result) in
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
                    self.reloadCollectionView()
                }
            }
            self.setPaginationMenu()
            self.setButtonValues()
            self.addOrDeleteMenuButtonsDependingOnNumberOfPages()
            self.lastButtonPressed = nil
            self.dismissLoader()
        }
    }
    
    @IBAction func didTapFilterButton(_ sender: UIButton) {
        
        let FilterSelectionVC = UIStoryboard(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "FilterSelectionVC") as! FilterSelectionViewController
        
        FilterSelectionVC.sideFilterSelectionDelegate = self
        let menu = UISideMenuNavigationController(rootViewController: FilterSelectionVC)
        menu.presentationStyle = .menuSlideIn
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
        eventRegistries.removeAll()
        reloadCollectionView()
        currentOrder = .priceAscending
        getEventProducts()
    }
    
    @IBAction func didTapOrderByHighPrice(_ sender: UIButton) {
        eventRegistries.removeAll()
        reloadCollectionView()
        currentOrder = .priceDescending
        getEventProducts()
    }
    
    @IBAction func didTapOrderByAZ(_ sender: UIButton) {
        eventRegistries.removeAll()
        reloadCollectionView()
        currentOrder = .nameAscending
        getEventProducts()
    }
    
    @IBAction func didTapOrderByZA(_ sender: UIButton) {
        eventRegistries.removeAll()
        reloadCollectionView()
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
        
        if eventPools.count > indexPath.row {
            //goToEnvelopeInformation(eventPool: eventPools[indexPath.row])
        } else {
            let productDetailsVC = UIStoryboard(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsViewController
            productDetailsVC.currentEventProduct = eventRegistries[indexPath.row - eventPools.count]
            productDetailsVC.currentEvent = currentEvent
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
    func didTapStartProduct() {
        print("estrella")
    }
    
    func didTapMoreOptions() {
        
        /*let sheet = UIAlertController(title: "Acciones", message: nil, preferredStyle: .actionSheet)
        var setAsImportant: UIAlertAction
        
        if registrySegment.selectedSegmentIndex == 2{
            if (self.eventPools[self.selectedIndexPath.row].isImportant){
                setAsImportant = UIAlertAction(title: "Desmarcar como importante", style: .default, handler: importantActionButtonPressed(alert:))
            }
            else{
                setAsImportant = UIAlertAction(title: "Marcar como importante", style: .default, handler: importantActionButtonPressed(alert:))
            }
        }
        else{
            if (self.eventProducts[self.selectedIndexPath.row].isImportant){
                setAsImportant = UIAlertAction(title: "Desmarcar como importante", style: .default, handler: importantActionButtonPressed(alert:))
            }
            else{
                setAsImportant = UIAlertAction(title: "Marcar como importante", style: .default, handler: importantActionButtonPressed(alert:))
            }
        }*/
    }
}

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

extension UserGiftTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !searchBar.isHidden {
            searchBar.endEditing(true)
            if let query = searchBar.text {
                //getEventProducts(query: query)
            }
        }
        searchBar.text = ""
        searchBar.isHidden = true
        isSearchBarHIdden = !isSearchBarHIdden
    }
}
