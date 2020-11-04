//
//  ViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/5/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var createRegistryButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		createRegistryButton.layer.cornerRadius = 4
    }

	@IBAction func createRegistryButtonTapped(_ sender: Any) {
		let onboardingEventTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onboardingEventTypeVC") as! OnboardingEventTypeViewController
		present(onboardingEventTypeVC, animated: true, completion: nil)
	}
    
	@IBAction func loginButtonTapped(_ sender: Any) {
		let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
		present(loginVC, animated: true, completion: nil)
	}
    
}

