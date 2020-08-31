//
//  EventProductCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 10/31/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class EventProductCell: UICollectionViewCell {
 
    @IBOutlet weak var eventProductImageView: customImageView!
    @IBOutlet weak var eventProductName: UILabel!
    @IBOutlet weak var shopProductName: UILabel!
    @IBOutlet weak var brandProductName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var eventProductQuantityLabel: UILabel!
    @IBOutlet weak var paidAmount: customProgressView!
    @IBOutlet weak var topPriorityView: customView!
    @IBOutlet weak var thankedIcon: UIImageView!
    @IBOutlet weak var creditedIcon: UIImageView!
    @IBOutlet weak var deliveredIcon: UIImageView!
    @IBOutlet weak var giftedLabel: UILabel!
    @IBOutlet weak var giftedCheckmark: UIImageView!
    @IBOutlet weak var collaboratorsLeftLabel: UILabel!
    
    func setup(eventProduct: EventProduct) {
        var thanked:[OrderItem] = []

        
        
        
        if (eventProduct.isImportant == true) {
            topPriorityView.isHidden = false
        }
        else {
            topPriorityView.isHidden = true
        }
        
        if (eventProduct.wishableType == "Product")
        {
            self.eventProductQuantityLabel.layer.masksToBounds = true
            self.eventProductQuantityLabel.layer.cornerRadius = 5
            self.eventProductName.text = eventProduct.product.name
            var string = self.getPriceStringFormat(value: Double(eventProduct.product.price))
            let substring = string.suffix(string.count-1)
            self.productPrice.text = "\u{24}\(substring) MXN"
            
            self.shopProductName.text = eventProduct.product.shop.name
            self.brandProductName.text = eventProduct.product.brand_name
            
            if let imageURL = URL(string:"\(eventProduct.product.imageUrl)"){
                self.eventProductImageView.kf.setImage(with: imageURL,placeholder: UIImage(named: "cliftplaceholder"))
            }
            var isProductGifted = self.isGifted(price: eventProduct.product.price, paidAmount: eventProduct.paidAmount)
            
            if eventProduct.status == "credit"{
                self.creditedIcon.isHidden = false
                self.creditedIcon.image = UIImage(named: "iccreditgreen")
            }
            
            if eventProduct.status == "requested"{
                self.deliveredIcon.isHidden = false
                self.deliveredIcon.image = UIImage(named: "icdeliveredgreen")
            }
            
            if eventProduct.hasBeenPaid{
                self.giftedLabel.text = "Regalado"
                self.giftedCheckmark.isHidden = false
                if eventProduct.status == "pending"{
                    self.creditedIcon.isHidden = false
                    self.creditedIcon.image = UIImage(named: "iccreditblack")
                    self.deliveredIcon.isHidden = false
                    self.deliveredIcon.image = UIImage(named: "icdeliverblack")
                }
                
            }
            else{ //has_been_paid = false
                self.thankedIcon.isHidden = true
                self.creditedIcon.isHidden = true
                self.deliveredIcon.isHidden = true
                self.giftedLabel.text = "Disponible"
                self.giftedCheckmark.isHidden = true
            }
            
            if eventProduct.orderItems != nil{
                eventProduct.orderItems = eventProduct.orderItems!.filter { (order) -> Bool in
                    order.status != "pending"
                }
                print(eventProduct.product.name)
                print(eventProduct.orderItems)
                thanked = eventProduct.orderItems!.filter { (order) -> Bool in !order.hasBeenThanked }
                if thanked.count == 0{
                    self.thankedIcon.isHidden = false
                    self.thankedIcon.image = UIImage(named: "icthankgreen")
                }
                else{
                    self.thankedIcon.isHidden = false
                    self.thankedIcon.image = UIImage(named: "icthankblack")
                }
                
            }
            
          } else { //Productos externos
                self.eventProductName.text = eventProduct.externalProduct.name
                self.productPrice.text = "\(self.getPriceStringFormat(value: Double(eventProduct.externalProduct.price)))"
                if let imageURL = URL(string:"\(eventProduct.externalProduct.imageUrl)") {
                    self.eventProductImageView.kf.setImage(with: imageURL,placeholder: UIImage(named: "cliftplaceholder"))
                }
               
                if(!eventProduct.isCollaborative){
                    self.paidAmount.barHeight = 0.0
                }
                
                var isProductGifted = self.isGifted(price: eventProduct.externalProduct.price, paidAmount: eventProduct.paidAmount)
                if isProductGifted {
                    self.giftedLabel.text = "Regalado"
                    self.giftedCheckmark.isHidden = false
                } else {
                    self.giftedLabel.text = "Disponible"
                    self.giftedCheckmark.isHidden = true
                }
        }
        if(eventProduct.isCollaborative){ //Es un producto colaborativo
            self.eventProductQuantityLabel.text = "\(eventProduct.guestData?["user_info"]?.count ?? 0)/\(eventProduct.collaborators)"
            self.collaboratorsLeftLabel.isHidden = false
            self.collaboratorsLeftLabel.text = "Faltan: \(eventProduct.collaborators - eventProduct.gifted_quantity) colaboracion(es)"
            self.paidAmount.progress = Float(eventProduct.gifted_quantity) / Float(eventProduct.collaborators)
        }else{
            self.eventProductQuantityLabel.text = "\(eventProduct.gifted_quantity)/\(eventProduct.quantity)"
            self.paidAmount.barHeight = 0.0
            self.collaboratorsLeftLabel.isHidden = true
        }
    }
    
    func isGifted(price: Int,paidAmount: String) -> Bool {
        var bool = Bool()
        
        if paidAmount == "\(price)" {
            bool = true
        } else {
            bool = false
        }
        
        return bool
    }
    
    func getPriceStringFormat(value: Double) -> String {
           
           let formatter = NumberFormatter()
           formatter.numberStyle = .currency
           
           return formatter.string(from: NSNumber(value: value))!
    }
}
