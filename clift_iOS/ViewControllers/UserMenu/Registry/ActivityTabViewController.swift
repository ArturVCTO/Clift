//
//  ActivityTabViewController.swift
//  clift_iOS
//
//  Created by Lizzie Guajardo on 10/09/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

class ActivityTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func redirectToWeb(_ sender: Any) {
        if let url = URL(string: "https://www.cliftapp.com") {
            UIApplication.shared.open(url)
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
