//
//  EventGiftListViewController.swift
//  clift_iOS
//
//  Created by Juan Pablo Ramos on 29/11/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

class EventGiftListViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: customImageView!
    @IBOutlet weak var eventImageView: customImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
	
    @IBOutlet weak var productsCollectionView: UICollectionView! {
        didSet {
            productsCollectionView.delegate = self
            productsCollectionView.dataSource = self
            //productsCollectionView.allowsMultipleSelection = false
        }
    }
	
	var currentEvent = Event()
    var eventRegistries: [EventProduct]! = []
	
	override func viewDidLoad() {
		super.viewDidLoad()

        setNavBar()
        registerCells()
        setup(event: currentEvent)
        getRegistries()
	}
    
    func setNavBar() {
        
        navigationItem.title = "EVENTO"
        
        let cartImage = UIImage(named: "cart")
        let searchImage = UIImage(named: "searchicon")
        let editButton   = UIBarButtonItem(image: cartImage,  style: .plain, target: self, action: #selector(didTapCartButton(sender:)))
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton(sender:)))
        navigationItem.rightBarButtonItems = [editButton, searchButton]
    }
    
    @objc func didTapCartButton(sender: AnyObject){
        print("Carrito de compras")
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
    }
    
    private func registerCells() {
        productsCollectionView.register(UINib(nibName: "GuestEventProductCell", bundle: nil), forCellWithReuseIdentifier: "GuestEventProductCell")
    }
    
    func getRegistries(){
        sharedApiManager.getRegistriesGuest(event: currentEvent, filters:[:]){ (eventProducts, result) in
                if let response = result{
                    if response.isSuccess() {
                        self.eventRegistries = eventProducts
                        self.productsCollectionView.reloadData()
                    }
                }
        }
    }
}

// MARK: Collection View Delegate and Data Source
extension EventGiftListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventRegistries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: "GuestEventProductCell", for: indexPath) as? GuestEventProductCell {
            
            cell.configure(product: eventRegistries[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension EventGiftListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let padding: CGFloat =  50
            let collectionViewSize = collectionView.frame.size.width - padding

            return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
}
