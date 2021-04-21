//
//  ViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/5/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

	@IBOutlet weak var createRegistryButton: UIButton!
    @IBOutlet var logInButton: UIButton!
    
	override func viewDidLoad() {
        super.viewDidLoad()
		createRegistryButton.layer.cornerRadius = 12
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

	@IBAction func createRegistryButtonTapped(_ sender: Any) {
		let onboardingEventTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onboardingEventTypeVC") as! OnboardingEventTypeViewController
		present(onboardingEventTypeVC, animated: true, completion: nil)
	}
    
	@IBAction func loginButtonTapped(_ sender: Any) {
		let loginVC = UIStoryboard(name: "Session", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
		present(loginVC, animated: true, completion: nil)
	}
    
    @IBAction func purchaseForYouPressed(_ sender: customButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let giftStoreVC = storyBoard.instantiateViewController(withIdentifier: "GiftStoreViewController") as! GiftStoreViewController
        giftStoreVC.modalPresentationStyle = .fullScreen
        getGuestToken()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(giftStoreVC, animated: true)
    }
    
    private func getGuestToken() {
        
        let realm = try! Realm()
        let users = realm.objects(Session.self)
        
        if(users.isEmpty || users.first!.accountType == "Host"){
            sharedApiManager.getGuestToken() {(session,result) in
                if let response = result{
                    if response.isSuccess(){
                        print("Session",session!.token)
                        try! realm.write {
                            realm.deleteAll()
                        }
                        try! realm.write {
                            realm.add(session!)
                        }
                    }
                }
            }
        }else{
            print(users.first!.accountType)
        }
    }
}

