//
//  RootViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/22/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Realm

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        let users = realm.objects(Session.self)
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
        if(users.isEmpty) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showCreateSessionFlow()
        }
        else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.userHasSuccesfullySignedIn()
        }
    }
}
