//
//  EventGiftListViewController.swift
//  clift_iOS
//
//  Created by Juan Pablo Ramos on 29/11/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit
import SideMenu

enum sortKeys: String {
    case nameAscending = "sort_name.asc"
    case nameDescending = "sort_name.desc"
    case priceAscending = "sort_price.asc"
    case priceDescending = "sort_price.desc"
}

class EventGiftListViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: customImageView!
    @IBOutlet weak var eventImageView: customImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
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
    
    @IBOutlet weak var productsCollectionView: UICollectionView! {
        didSet {
            productsCollectionView.delegate = self
            productsCollectionView.dataSource = self
        }
    }
	
	var currentEvent = Event()
    var eventRegistries: [EventProduct]! = []
    var eventPools: [EventPool]! = []
    var orderByViewSizeFlag = true
    var filtersDic = ["shop":"","category":"","price":""]
	
	override func viewDidLoad() {
		super.viewDidLoad()

        getPoolsAndRegistries()
        setNavBar()
        registerCells()
        setup(event: currentEvent)
	}
    
    func setNavBar() {
        
        navigationItem.title = "EVENTO"
        
        let cartImage = UIImage(named: "cart")
        let searchImage = UIImage(named: "searchicon")
        let cartButton   = UIBarButtonItem(image: cartImage,  style: .plain, target: self, action: #selector(didTapCartButton(sender:)))
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton(sender:)))
        navigationItem.rightBarButtonItems = [cartButton, searchButton]
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func didTapCartButton(sender: AnyObject){
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "checkoutVC") as! CheckoutViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func didTapSearchButton(sender: AnyObject){
        print("Buscar")
    }
    
    func setup(event: Event) {
        
        if let coverURL = URL(string: event.coverImageUrl) {
            backgroundImageView.kf.setImage(with: coverURL, placeholder: UIImage(named: "cliftplaceholder"))
        }
        
        if let eventURL = URL(string: event.eventImageUrl) {
            eventImageView.kf.setImage(with: eventURL, placeholder: UIImage(named: "profilePlaceHolder"))
        }
        
        eventNameLabel.text = event.name
        dateLabel.text = event.formattedDate()
        typeLabel.text = event.stringVisibility()
        eventImageView.layer.cornerRadius = 30
        
        orderByView.layer.cornerRadius = 10
        orderByInnerView.layer.cornerRadius = 10
        filerView.layer.cornerRadius = 10
    }
    
    private func registerCells() {
        productsCollectionView.register(UINib(nibName: "GuestEventProductCell", bundle: nil), forCellWithReuseIdentifier: "GuestEventProductCell")
    }
    
    func getRegistries(orderBy: String = ""){
        self.presentLoader()
        productsCollectionView.isScrollEnabled = false
        eventRegistries.removeAll()
        productsCollectionView.reloadData()
        sharedApiManager.getRegistriesGuest(event: currentEvent, filters:filtersDic, orderBy: orderBy){ (eventProducts, result) in
                if let response = result{
                    if response.isSuccess() {
                        self.eventRegistries = eventProducts
                        self.productsCollectionView.reloadData()
                    }
                }
            self.dismissLoader()
            self.productsCollectionView.isScrollEnabled = true
        }
    }
    
    func getPoolsAndRegistries(){
        
        sharedApiManager.getEventPools(event: currentEvent) {(pools, result) in
            self.presentLoader()
            if let response = result {
                if (response.isSuccess()) {
                    self.eventPools = pools
                }
            }
            self.getRegistries()
        }
    }
    
    func addProductToCart(quantity: Int, product: Product) {
        sharedApiManager.addItemToCart(quantity: quantity, product: product) { (cartItem, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.showMessage(NSLocalizedString("Producto se ha agregado a tu carrito.", comment: ""),type: .success)
                } else if (response.isClientError()) {
                    self.showMessage(NSLocalizedString("Producto no se pudo agregar, intente de nuevo más tarde.", comment: "Login Error"),type: .error)
                }
            }
        }
    }
    
    @IBAction func didTapFilterButton(_ sender: UIButton) {
        
        let FilterSelectionVC = UIStoryboard(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "FilterSelectionVC") as! FilterSelectionViewController
        
        FilterSelectionVC.eventGiftListVC = self
        let menu = UISideMenuNavigationController(rootViewController: FilterSelectionVC)
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = UIScreen.main.bounds.size.width * 0.8
        present(menu,animated: true, completion: nil)
    }
    
    func goToEnvelopeInformation(eventPool: EventPool) {
        
        let envelopeInfoVC = UIStoryboard(name: "EnvelopeFlow", bundle: nil).instantiateViewController(withIdentifier: "EnvelopeInfoVC") as! EnvelopeInfoViewController
        envelopeInfoVC.currentEventPool = eventPool
        envelopeInfoVC.currentEvent = currentEvent
        envelopeInfoVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(envelopeInfoVC, animated: true)
    }
}

// MARK: Extension OrderBy
extension EventGiftListViewController {
    
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
        getRegistries(orderBy: sortKeys.priceAscending.rawValue)
    }
    
    @IBAction func didTapOrderByHighPrice(_ sender: UIButton) {
        eventRegistries.removeAll()
        productsCollectionView.reloadData()
        getRegistries(orderBy: sortKeys.priceDescending.rawValue)
    }
    
    @IBAction func didTapOrderByAZ(_ sender: UIButton) {
        eventRegistries.removeAll()
        productsCollectionView.reloadData()
        getRegistries(orderBy: sortKeys.nameAscending.rawValue)
    }
    
    @IBAction func didTapOrderByZA(_ sender: UIButton) {
        eventRegistries.removeAll()
        productsCollectionView.reloadData()
        getRegistries(orderBy: sortKeys.nameDescending.rawValue)
    }
}

// MARK: Extension Collection View Delegate and Data Source
extension EventGiftListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventPools.count + eventRegistries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: "GuestEventProductCell", for: indexPath) as? GuestEventProductCell {
            
            cell.productCellDelegate = self
            
            //Set Pool Cells and Product Cells
            if eventPools.count > indexPath.row {
                cell.cellType = .Eventpool
                cell.configure(pool: eventPools[indexPath.row])
            } else {
                cell.cellType = .Eventproduct
                cell.configure(product: eventRegistries[indexPath.row - eventPools.count])
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if eventPools.count > indexPath.row {
            goToEnvelopeInformation(eventPool: eventPools[indexPath.row])
        } else {
            let productDetailsVC = UIStoryboard(name: "Guest", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsViewController
            productDetailsVC.currentEventProduct = eventRegistries[indexPath.row - eventPools.count]
            productDetailsVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(productDetailsVC, animated: true)
        }
    }
}

//MARK:- Extension UICollectionViewDelegateFlowLayout
extension EventGiftListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let padding: CGFloat =  50
            let collectionViewSize = collectionView.frame.size.width - padding

            return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
}

//MARK:- Extension ProductCellDelegate
extension EventGiftListViewController: ProductCellDelegate {
    func didTapCashFundPool(eventPool: EventPool) {
        goToEnvelopeInformation(eventPool: eventPool)
    }
    
    
    func didTapAddProductToCart(quantity: Int, product: Product) {
        addProductToCart(quantity: quantity, product: product)
    }
}

extension EventGiftListViewController: UISideMenuNavigationControllerDelegate {

        func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
            
            getRegistries()
        }
}
