//
//  ProfileViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/22/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var profileImageView: customImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getProfile()
    }
    
    func getProfile() {
        sharedApiManager.getProfile() { (profile, result) in
            if let response = result {
                if response.isSuccess() {
                    self.profileNameLabel.text = profile?.fullName()
                    self.userEmailLabel.text = profile?.email
                    if let imageURL = URL(string:"\(profile!.imageUrl)") {
                        self.profileImageView.kf.setImage(with: imageURL)
                    }
                }
            }
        }
    }
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let editProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileHomeViewController") as! ProfileHomeViewController
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @IBAction func myAddressesButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addressTableVC = storyboard.instantiateViewController(withIdentifier: "addressesTableVC") as! AddressesTableViewController
        self.navigationController?.pushViewController(addressTableVC, animated: true)
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        sharedApiManager.deleteLogoutSession() { (emptyObjectWithErrors, result) in
            if let response = result {
                if(response.isSuccess()) {
                    let realm = try! Realm()
                    try! realm.write {
                        realm.deleteAll()
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.showCreateSessionFlow()
                    }
                } else {
                    self.showMessage(NSLocalizedString("unknownError", comment: "unknownError"), type: .error)
                }
            }
        }
    }
    
    
}
