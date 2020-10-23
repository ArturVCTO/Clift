//
//  GuestGiftListViewController.swift
//  clift_iOS
//
//  Created by Alejandro González on 20/08/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

class GuestGiftListViewController: UIViewController {
    
    public var currentEvent: Event!
    var eventRegistries: [EventProduct]! = []
    
    @IBOutlet weak var registriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.registriesCollectionView.delegate = self
        self.registriesCollectionView.dataSource = self
        self.registriesCollectionView.allowsMultipleSelection = false
        
        self.getRegistries()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getRegistries(){
        sharedApiManager.getRegistriesGuest(event: currentEvent, filters:[:]){ (eventProducts, result) in
                if let response = result{
                    if response.isSuccess() { 
                        self.eventRegistries = eventProducts
                        self.registriesCollectionView.reloadData()
                    }
                }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GuestGiftListViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.eventRegistries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "registryCell", for: indexPath) as! RegistryGuestCell
        
        cell.currentEvent = self.currentEvent
            
        cell.setup(product: self.eventRegistries[indexPath.row])
        
        return cell
    }
    
    
}
