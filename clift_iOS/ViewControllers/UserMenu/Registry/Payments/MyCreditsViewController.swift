//
//  MyCreditsViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 3/4/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

class MyCreditsViewController: UIViewController {
    @IBOutlet weak var totalCreditsAmountLabel: UILabel!
    @IBOutlet weak var creditsCodeLabel: UILabel!
    @IBOutlet weak var creditsTableView: UITableView!
    var credits: [ShopCredit] = []
    var currentEvent = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creditsTableView.delegate = self
        self.creditsTableView.dataSource = self
        self.getCredits()
    }
    
    func getCredits() {
        sharedApiManager.getCredits(event: currentEvent ) { (credits, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.credits = credits!
                    self.creditsTableView.reloadData()
                    self.loadCode(code: self.credits.first!.code)
                }
            }
        }
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getTotalAmount() {
        
    }
    
    func loadCode(code: String) {
        self.creditsCodeLabel.text = code
    }
}
extension MyCreditsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = creditsTableView.dequeueReusableCell(withIdentifier: "shopCreditCell", for: indexPath) as! ShopCreditCell
        cell.configure(cell: credits[indexPath.row])
        cell.shopId = credits[indexPath.row].shop.id
        cell.eventId = currentEvent.id
        cell.navigationController = self.navigationController
        return cell
    }
    
    
}
