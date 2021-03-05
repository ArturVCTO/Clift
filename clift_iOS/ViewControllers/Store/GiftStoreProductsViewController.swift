//
//  GiftStoreProductsViewController.swift
//  clift_iOS
//
//  Created by Fernando Limón Flores on 24/02/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

class GiftStoreProductsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var menuContainerWidth: NSLayoutConstraint!
    @IBOutlet var subgroupLabel: UILabel!
    @IBOutlet weak var filterView: UIView!
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
    
    var category = Category()
    var subgroupNameString = ""
    var currentEvent = Event()
    var products: [Product]! = []
    var orderByViewSizeFlag = true
    var filtersDic: [String: Any] = [:]
    var currentOrder: sortKeys = .nameAscending
    var isSearchBarHIdden = true
    
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
        getEventAndProducts()
        setNavBar()
        setSubgroupLabel()
        registerCells()
        setPaginationMenu()
        selectButton(button: firstMenuButton)
    }
    
    private func setNavBar() {
        let titleLabel = UILabel()
        titleLabel.text = category.name.uppercased()
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Mihan-Regular", size: 16.0)!
        titleLabel.addCharactersSpacing(5)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let searchImage = UIImage(named: "searchicon")
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton(sender:)))
        navigationItem.rightBarButtonItems = [searchButton]
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setSubgroupLabel() {
        subgroupLabel.text = subgroupNameString.uppercased()
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
        filterView.layer.cornerRadius = 10
    }
    
    private func registerCells() {
        productsCollectionView.register(UINib(nibName: "StoreProductCell", bundle: nil), forCellWithReuseIdentifier: "StoreProductCell")
    }
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 150, height: 280)
        return layout
    }()
    
    private func setCollectionViewHeight() {
        collectionViewHeight.constant = CGFloat(productsCollectionView.collectionViewLayout.collectionViewContentSize.height)
    }
    
    @IBAction func didTapOrderByButtonTest(_ sender: UIButton) {
        
        let orderBySheet = UIAlertController(title: "Ordenar por", message: nil, preferredStyle: .actionSheet)
        orderBySheet.view.tintColor = UIColor(named: "PrimaryBlue")
        
        let priceHightToLow = UIAlertAction(title: "PRECIO: ALTO - BAJO", style: .default, handler: {(action) in self.didTapOrderByHighPrice()})
        let priceLowToHight = UIAlertAction(title: "PRECIO: BAJO - ALTO", style: .default, handler: {(action) in self.didTapOrderByLowPrice()})
        let nameAtoZ = UIAlertAction(title: "A - Z", style: .default, handler: {(action) in self.didTapOrderByAZ()})
        let nameZToA = UIAlertAction(title: "Z - A", style: .default, handler: {(action) in self.didTapOrderByZA()})
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        orderBySheet.addAction(priceHightToLow)
        orderBySheet.addAction(priceLowToHight)
        orderBySheet.addAction(nameAtoZ)
        orderBySheet.addAction(nameZToA)
        orderBySheet.addAction(cancelAction)
        
        present(orderBySheet, animated: true, completion: nil)
    }
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        actualPage = 1
        getStoreProducts()
    }
    
    @IBAction func rightButtonPressed(_ sender: Any) {
        actualPage = numberOfPages
        getStoreProducts()
    }
    
    @IBAction func firstButtonPressed(_ sender: Any) {
        actualPage = firstButtonValue
        lastButtonPressed = firstMenuButton
        setButtonValues()
        addOrDeleteMenuButtonsDependingOnNumberOfPages()
        getStoreProducts()
    }
    
    @IBAction func secondButtonPressed(_ sender: Any) {
        actualPage = secondButtonValue
        lastButtonPressed = secondButton
        setButtonValues()
        addOrDeleteMenuButtonsDependingOnNumberOfPages()
        getStoreProducts()
    }
    
    @IBAction func thirdButtonPressed(_ sender: Any) {
        actualPage = thirdButtonValue
        lastButtonPressed = thirdButton
        setButtonValues()
        addOrDeleteMenuButtonsDependingOnNumberOfPages()
        getStoreProducts()
    }
}

// MARK: Extension OrderBy
extension GiftStoreProductsViewController {
    
    func didTapOrderByLowPrice() {
        currentOrder = .priceAscending
        getStoreProducts()
    }
    
    func didTapOrderByHighPrice() {
        currentOrder = .priceDescending
        getStoreProducts()
    }
    
    func didTapOrderByAZ() {
        currentOrder = .nameAscending
        getStoreProducts()
    }
    
    func didTapOrderByZA() {
        currentOrder = .nameDescending
        getStoreProducts()
    }
}

// MARK: Extension Collection View Delegate and Data Source
extension GiftStoreProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: "StoreProductCell", for: indexPath) as? StoreProductCell {
            
            cell.configure(product: products[indexPath.row])
            cell.cellWidth = (collectionView.frame.size.width - 25) / 2
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*if eventPools.count > indexPath.row {
            goToEnvelopeInformation(eventPool: eventPools[indexPath.row])
        } else {
            let productDetailsVC = UIStoryboard(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsViewController
            productDetailsVC.currentEventProduct = eventRegistries[indexPath.row - eventPools.count]
            productDetailsVC.currentEvent = currentEvent
            productDetailsVC.productDetailType = eventRegistries[indexPath.row - eventPools.count].wishableType == "ExternalProduct" ? .EventExternalProduct : .EventProduct
            productDetailsVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(productDetailsVC, animated: true)
        }*/
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.productsCollectionView.reloadData()
            self.setCollectionViewHeight()
        }
    }
}

//Pagination Menu
extension GiftStoreProductsViewController {
    
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

extension GiftStoreProductsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !searchBar.isHidden {
            searchBar.endEditing(true)
            if let query = searchBar.text {
                getStoreProducts(query: query)
            }
        }
        searchBar.text = ""
        searchBar.isHidden = true
        isSearchBarHIdden = !isSearchBarHIdden
    }
}

// MARK: Extension REST APIs
extension GiftStoreProductsViewController {
    
    func getStoreProducts(query: String = "") {
        self.presentLoader()
        products.removeAll()
        reloadCollectionView()
        filtersDic["page"] = actualPage
        filtersDic["sort_by"] = currentOrder.rawValue
        sharedApiManager.getProductsAsLoggedInUserLessParams(event:currentEvent, filters: filtersDic) { (products,result) in
            
            if let response = result{
                if (response.isSuccess()) {
                    self.products = products
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
        }
    }
        
    func getEventAndProducts() {
        sharedApiManager.getEvents() { (events, result) in
            self.presentLoader()
            if let response = result {
                if (response.isSuccess()) {
                    if let currentEvent = events?.first {
                        self.currentEvent = currentEvent
                        self.setup(event: self.currentEvent)
                        self.getStoreProducts()
                    }
                }
            } else {
                self.dismissLoader()
            }
        }
    }
}
