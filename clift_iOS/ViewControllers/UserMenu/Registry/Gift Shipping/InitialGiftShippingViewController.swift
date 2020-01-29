//
//  GiftShippingTableViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/28/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

struct MockGiftedProduct {
    let brand: String
    let name: String
    let image: UIImage
    let quantity: Int
    let shop: String
}

class InitialGiftShippingViewController: UIViewController {
    @IBOutlet weak var giftTableViewController: UITableView!
    var eventProducts: [MockGiftedProduct] = [
        MockGiftedProduct(brand: "CUSINART", name: "Licuadora SmartPower ™ Duet de 500 vatios / Procesador de alimentos.", image: UIImage(named: "15")!,quantity: 1, shop: "Liverpool"),
        MockGiftedProduct(brand: "CUSINART", name: "1.5 Qt Fruit Scoop Máquina de postres congelados.", image: UIImage(named: "10")!,quantity: 1, shop: "GANT")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.giftTableViewController.delegate = self
        self.giftTableViewController.dataSource = self
        self.giftTableViewController.reloadData()
    }
    
    
    @IBAction func goToShippingMethodButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "giftShippingTableVC") as! GiftShippingTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
          // Fallback on earlier versions
          let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "giftShippingTableVC") as! GiftShippingTableViewController
          self.navigationController?.pushViewController(vc, animated: true)
      }
    }
    
    func removeEventProductsFromCart(row: Int) {
        self.eventProducts.remove(at: row)
        self.giftTableViewController.reloadData()
    }
}
extension InitialGiftShippingViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = giftTableViewController.dequeueReusableCell(withIdentifier: "giftShippingCell") as! GiftShippingCell
        cell.configure(cell: eventProducts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteTitle = NSLocalizedString("Eliminar", comment: "Delete action")

        let deleteAction = UITableViewRowAction(style: .destructive,
          title: deleteTitle) { (action, indexPath) in
            self.removeEventProductsFromCart(row: indexPath.row)
        }
        
        return [deleteAction]
    }
}
