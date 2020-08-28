//
//  NumberOfCollaboratorsViewController.swift
//  clift_iOS
//
//  Created by Lizzie Guajardo on 26/08/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import Moya
import GSMessages
import RealmSwift

class NumberOfCollaboratorsViewController: UIViewController {

    @IBOutlet weak var infoCard: UIView!
    @IBOutlet weak var numerOfCollaboratorsLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var amoutPerCollaboratorLabel: UILabel!
    
    var eventProduct = EventProduct()
    var collectionView: UICollectionView!
    var selectedIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.infoCard.layer.cornerRadius = 5
        self.showAnimation()
        self.stepper.minimumValue = 2
        self.stepper.maximumValue = 30
        self.stepper.value = 2
        self.updateLabels()
    }
    
    func showAnimation(){
        self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: { self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        }, completion: nil)
    }
    @IBAction func stepperIsTapped(_ sender: Any) {
        self.updateLabels()
    }
    
    @IBAction func closeNumberOfCollaboratorsWindow(_ sender: Any) {
        self.removeAnimation()
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        sharedApiManager.updateEventProductAsCollaborative(eventProduct: eventProduct, setCollaborative: true, collaborators: Int(self.stepper.value)) { (_, result) in
            if let response = result{
                if (response.isSuccess()) {
                    
                    self.eventProduct.collaborators = Int(self.stepper.value)
                    self.eventProduct.isCollaborative = true
                    self.collectionView.reloadItems(at: [self.selectedIndexPath!])
                    self.removeAnimation()
                    self.navigationController?.showMessage(NSLocalizedString("Porducto actualizado como colaborativo", comment: "Producto actualizado"), type: .success)
                }
                else {
                    self.showMessage(NSLocalizedString("Error de servidor, intente de nuevo más tarde", comment: "Error"), type: .error)
                }
            }
        }
        self.removeAnimation()
    }
    
    func updateLabels(){
        self.numerOfCollaboratorsLabel.text = "\(Int(self.stepper.value)) Colaboradores"
        var pricePerCollab = Double(eventProduct.product.price) / Double(self.stepper.value)
        self.amoutPerCollaboratorLabel.text = "\u{24} \(String(format: "%.2f", pricePerCollab)) MXN"
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
