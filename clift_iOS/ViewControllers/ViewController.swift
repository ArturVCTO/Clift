//
//  ViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/5/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func createRegistryButtonTapped(_ sender: Any) {
        let onboardingEventTypeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onboardingEventTypeVC") as! OnboardingEventTypeViewController
       self.present(onboardingEventTypeVC, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        self.present(loginVC, animated: true, completion: nil)
    }
    
}

