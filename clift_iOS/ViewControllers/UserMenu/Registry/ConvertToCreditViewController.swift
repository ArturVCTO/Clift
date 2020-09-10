//
//  ConvertToCreditViewController.swift
//  clift_iOS
//
//  Created by Lizzie Guajardo on 09/09/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import Moya
import GSMessages
import RealmSwift

class ConvertToCreditViewController: UIViewController {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var infoCard: UIView!
    @IBOutlet weak var creditAmountLabel: UILabel!
    
    var eventProduct = EventProduct()
    var collectionView: UICollectionView!
    var selectedIndexPath: IndexPath!
    var event = Event()
    
    var creditQty = 0.0
    var creditIds: [Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.infoCard.layer.cornerRadius = 5
        self.showAnimation()
        
        self.productNameLabel.text = eventProduct.product.name

        self.calculateCredit()
        
        self.creditAmountLabel.text = "\u{24} \(String(format: "%.2f", self.creditQty)) MXN"
    }
    
    func calculateCredit(){
        for orderItem in eventProduct.orderItems! {
            self.creditQty += Double( orderItem.amount) ?? 0
            self.creditIds.append(["registry_id": eventProduct.id, "order_id": orderItem.orderId])
        }
    }
    
    func showAnimation(){
        self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: { self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        }, completion: nil)
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        self.removeAnimation()
    }
    @IBAction func creditProducts(_ sender: Any) {
        sharedApiManager.convertToCredits(event: event, payload: creditIds) { (_, result) in
            if let response = result{
                if response.isSuccess(){
                    self.eventProduct.status = "credit"
                    self.collectionView.reloadItems(at: [self.selectedIndexPath!])
                    self.removeAnimation()
                    self.navigationController?.showMessage(NSLocalizedString("Se ha convertido a crédito satisfactoriamente", comment: "Producto actualizado"), type: .success)
                }else {
                    self.showMessage(NSLocalizedString("Error de servidor, intente de nuevo más tarde", comment: "Error"), type: .error)
                }
            }
        }
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.removeAnimation()
    }
    
    func removeAnimation(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
             self.view.alpha = 0.0
        }, completion: {
            (finished : Bool) in
            if (finished){
                //self.view.removeFromSuperview()
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
