//
//  FourthStepOnboardingViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/9/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class FourthStepOnboardingViewController: UIViewController {
    
    @IBOutlet weak var interestCollectionView: UICollectionView!
    var interests = [Interest]()
    var rootParentVC: RootOnboardViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interestCollectionView.delegate = self as? UICollectionViewDelegate
        self.interestCollectionView.dataSource = self as? UICollectionViewDataSource
        self.getInterests()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateCurrentPageSelector()
    }
    
    func updateCurrentPageSelector() {
        self.rootParentVC.pageControlSelector.currentPage = 3
    }
    
    
    func getInterests() {
        sharedApiManager.interests() { (interests, result) in
            if let response = result {
                if response.isSuccess() {
                    self.interests = interests!
                    self.interestCollectionView.reloadData()
                }
            }
        }
    }
}
extension FourthStepOnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.interestCollectionView.dequeueReusableCell(withReuseIdentifier: "interestCell", for: indexPath) as! OnboardingInterestCell
        cell.interest = self.interests[indexPath.row]
        cell.parentVC = self
        cell.setupInterest(interest: interests[indexPath.row])
        return cell
    }
}
