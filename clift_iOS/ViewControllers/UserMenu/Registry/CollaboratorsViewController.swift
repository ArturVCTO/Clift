//
//  CollaboratorsViewController.swift
//  clift_iOS
//
//  Created by Lizzie Guajardo on 21/08/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

class CollaboratorsViewController: UIViewController {

    @IBOutlet weak var infoCard: UIView!
    public var product: EventProduct!
    public var currentEvent: Event!
    public var pool: EventPool!
    @IBOutlet weak var collaboratorsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.product.orderItems = self.product.orderItems!.filter { (order) -> Bool in
            order.status != "pending"
        }
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.infoCard.layer.cornerRadius = 5
        self.showAnimation()
        
        self.collaboratorsTableView.delegate = self
        self.collaboratorsTableView.dataSource = self
        self.collaboratorsTableView.allowsMultipleSelection = false
        
    }
    
    func showAnimation(){
        self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: { self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        }, completion: nil)
    }
    @IBAction func closeCollaboratorsInfoWindow(_ sender: Any) {
        self.removeAnimation()
    }
    
    func removeAnimation(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
             self.view.alpha = 0.0
        }, completion: {
            (finished : Bool) in
            if (finished){
                self.navigationController?.popViewController(animated: false)
            }
        })
        
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

extension CollaboratorsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let producto = self.product {
            let counter = producto.guestData?["user_info"]!.count
            return counter ?? 0
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collaboratorCell") as! CollaboratorInfoTableViewCell
        
        var orders: [OrderItem] = []
        
        if let items = self.product.orderItems{
            orders = items
        }
        cell.thankButton.setImage(nil, for: .normal)
        cell.thankButton.borderWidth = CGFloat(0)
        cell.thankButton.isEnabled = false
        cell.parentVC = self
        cell.currentEvent = self.currentEvent
        cell.setup(user: self.product.guestData!["user_info"]![indexPath
            .row], order: orders[indexPath.row])
        
        return cell
    }
    
    
}
