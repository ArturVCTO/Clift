//
//  ThankCollaboratorViewController.swift
//  clift_iOS
//
//  Created by Lizzie Guajardo on 27/08/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import Moya
import GSMessages
import RealmSwift

class ThankCollaboratorViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var infoCard: UIView!
    
    @IBOutlet weak var thankMessageTextField: UITextView!
    var thankedUser : ThankYouUser!
    var event: Event!
    var orderItem: OrderItem!
    @IBOutlet weak var saveButton: customButton!
    var placeHolderText = ""
    var collabVC: CollaboratorsViewController!
    var productRegistryVC: ProductsRegistryViewController!
    var selectedIndexPath : IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.infoCard.layer.cornerRadius = 5
        self.showAnimation()
        
        self.thankMessageTextField.delegate = self
        
        self.placeHolderText = "Ejemplo: ¡Muchas gracias \( thankedUser!.name!) por tu regalo!"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnClickOutside))
        view.addGestureRecognizer(tap)
        
        thankMessageTextField.textColor = .lightGray
        thankMessageTextField.text = placeHolderText
        thankMessageTextField.layer.masksToBounds = true
        thankMessageTextField.layer.cornerRadius = 4.0
        thankMessageTextField.layer.borderWidth = 1
        thankMessageTextField.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    @IBAction func hideKeyboardOnClickOutside(){
        view.endEditing(true)
    }
    
    func textViewDidEndEditing (_ textView: UITextView){
        if thankMessageTextField.text.isEmpty || thankMessageTextField.text == ""{
            thankMessageTextField.textColor = .lightGray
            thankMessageTextField.text = placeHolderText
        }
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if (thankMessageTextField.isFirstResponder && thankMessageTextField.text == placeHolderText){
            thankMessageTextField.textColor = .black
            thankMessageTextField.text = ""
        }
    }
    
    func showAnimation(){
        self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: { self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        }, completion: nil)
    }
    
    func removeAnimation(){
        self.hideKeyboardOnClickOutside()
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
    @IBAction func saveThankMessage(_ sender: Any) {
        if (!thankMessageTextField.text.isEmpty && thankMessageTextField.text != "" && thankMessageTextField.text != placeHolderText){
            sharedApiManager.updateEventProductThankMessage(event: self.event, orderItem: self.orderItem, names: [self.thankedUser.name!], emails: [self.thankedUser.email!], message: self.thankMessageTextField.text!) { (_, response) in
                if let result=response{
                    if result.isSuccess(){
                        self.parent?.showMessage(NSLocalizedString("Mensaje de agradecimiento mandado con éxito", comment: "Update success"),type: .success)
                        self.orderItem!.hasBeenThanked = true
                        self.collabVC!.collaboratorsTableView.reloadData()
                        self.productRegistryVC.eventProducts[self.selectedIndexPath.row].hasBeenThanked = true
                        self.productRegistryVC.eventProductsCollectionView.reloadItems(at: [self.selectedIndexPath])
                    }
                }
            }
            self.removeAnimation()
        }
    }
    
    @IBAction func exitButtonIsTapped(_ sender: Any) {
        self.removeAnimation()
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
