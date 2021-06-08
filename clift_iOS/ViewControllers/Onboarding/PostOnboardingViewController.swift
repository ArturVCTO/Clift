//
//  PostOnboardingViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/2/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class PostOnboardingViewController: UIViewController {
    
    var onboardingEmail = ""
    var onboardingPassword = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func goToMyRegistry(_ sender: Any) {
        self.postLoginSession()
    }
    
    func postLoginSession() {
        sharedApiManager.login(email: self.onboardingEmail, password: self.onboardingPassword) { (session, result) in
            if let response = result {
                if response.isSuccess() {
                    if (session != nil && session?.token != "") {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.add(session!)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.userHasSuccesfullySignedIn()
                        }
                    }
                } else if (response.isClientError() && session != nil && !(session?.errors.isEmpty)!) {
                    self.showMessage(NSLocalizedString("\(session!.errors.first!)", comment: "Login Error"),type: .error)
                }
            }
        }
    }
}
