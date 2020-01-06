//
//  PreviewInvitationViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 12/9/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class PreviewInvitationViewController: UIViewController {
    
        @IBOutlet weak var invitationBGImageView: UIImageView!
        @IBOutlet weak var shortMessageWSIWYGLabel: UILabel!
       @IBOutlet weak var yourNameWSIWYGLabel: UILabel!
       @IBOutlet weak var yourCoupleWSIWYGLabel: UILabel!
       @IBOutlet weak var eventDateWSIWYGLabel: UILabel!
       @IBOutlet weak var ceremonyNameWYSIWYGLabel: UILabel!
       @IBOutlet weak var ceremonyAddressWYSIWYGLabel: UILabel!
       @IBOutlet weak var ceremonyHourWYSIWYGLabel: UILabel!
       @IBOutlet weak var dressCodeWYSIWYGLabel: UILabel!
       @IBOutlet weak var receptionNameWYSIWYGLabel: UILabel!
       @IBOutlet weak var receptionAddressWYSIWYGLabel: UILabel!
       @IBOutlet weak var receptionHourWYSIWYGLabel: UILabel!
       
       @IBOutlet weak var yourFatherLabel: UILabel!
       
       @IBOutlet weak var yourMotherLabel: UILabel!
       
       @IBOutlet weak var coupleFatherLabel: UILabel!
       
       @IBOutlet weak var coupleMotherLabel: UILabel!
    
    var invitationTemplate = InvitationTemplate()
    var invitation = Invitation()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setupTemplateArrangement()
        self.setupEventInformation(invitation: self.invitation)
        self.yourNameWSIWYGLabel.adjustsFontSizeToFitWidth = true
        self.yourCoupleWSIWYGLabel.adjustsFontSizeToFitWidth = true
        self.shortMessageWSIWYGLabel.adjustsFontSizeToFitWidth = true
        self.yourFatherLabel.adjustsFontSizeToFitWidth = true
        self.yourMotherLabel.adjustsFontSizeToFitWidth = true
        self.coupleFatherLabel.adjustsFontSizeToFitWidth = true
        self.coupleMotherLabel.adjustsFontSizeToFitWidth = true
        self.ceremonyNameWYSIWYGLabel.adjustsFontSizeToFitWidth = true
        self.ceremonyAddressWYSIWYGLabel.adjustsFontSizeToFitWidth = true
        self.receptionNameWYSIWYGLabel.adjustsFontSizeToFitWidth = true
        self.receptionAddressWYSIWYGLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupEventInformation(invitation: Invitation) {
         self.yourNameWSIWYGLabel.text = invitation.creatorName
         self.yourCoupleWSIWYGLabel.text = invitation.spouseName
         
         self.shortMessageWSIWYGLabel.text = invitation.message
         
         self.ceremonyAddressWYSIWYGLabel.text = invitation.locationCeremonyUrl
         
         self.ceremonyNameWYSIWYGLabel.text = invitation.ceremonyPlace
         
         self.receptionNameWYSIWYGLabel.text = invitation.receptionPlace
         
         self.receptionAddressWYSIWYGLabel.text = invitation.locationReceptionUrl
         
        self.yourFatherLabel.text = invitation.relativeOne
        self.yourMotherLabel.text = invitation.relativeTwo
        self.coupleFatherLabel.text = invitation.relativeThree
        self.coupleMotherLabel.text = invitation.relativeFour
         
         switch invitation.dressCode {
         case 0:
             self.dressCodeWYSIWYGLabel.text = "Vestimenta: Semiformal"
         case 1:
             self.dressCodeWYSIWYGLabel.text = "Vestimenta: Formal"
         case 2:
             self.dressCodeWYSIWYGLabel.text = "Vestimenta: Etiqueta"
         case 3:
             self.dressCodeWYSIWYGLabel.text = "Vestimenta: Guayabera/Playa"
         default:
             self.dressCodeWYSIWYGLabel.text = "Vestimenta:"
         }
     }
    
    func setupTemplateArrangement() {
        if invitationTemplate.templateArrangement == 1 {
            self.invitationBGImageView.image = UIImage(named: "Clift_Invitaciones_Type_BG_1")
            self.yourNameWSIWYGLabel.textColor = UIColor(displayP3Red: 231/255, green: 190/255, blue: 129/255, alpha: 1.0)
            self.yourCoupleWSIWYGLabel.textColor = UIColor(displayP3Red: 231/255, green: 190/255, blue: 129/255, alpha: 1.0)
            self.shortMessageWSIWYGLabel.frame = CGRect(x: 67, y: 20, width: 176, height: 34)
            self.shortMessageWSIWYGLabel.textAlignment = .center
            self.yourNameWSIWYGLabel.frame = CGRect(x: 8, y: 96, width: 287, height: 23)
            self.yourNameWSIWYGLabel.textAlignment = .center
            
            self.yourCoupleWSIWYGLabel.frame = CGRect(x: 8, y: 125, width: 287, height: 23)
            self.yourCoupleWSIWYGLabel.textAlignment = .center
            self.yourFatherLabel.frame = CGRect(x: 8, y: 53, width: 138, height: 11)
            self.yourFatherLabel.textAlignment = .left
            self.yourMotherLabel.frame = CGRect(x: 8, y: 65, width: 138, height: 11)
            self.yourMotherLabel.textAlignment = .left
            self.coupleFatherLabel.frame = CGRect(x: 181, y: 53, width: 114, height: 11)
            self.coupleMotherLabel.frame = CGRect(x: 181, y: 65, width: 114, height: 11)
            self.dressCodeWYSIWYGLabel.frame = CGRect(x: 66,y:282,width: 170, height: 13)
            self.dressCodeWYSIWYGLabel.textAlignment = .center
            self.eventDateWSIWYGLabel.frame = CGRect(x: 58, y: 180, width: 187, height: 16)
            self.eventDateWSIWYGLabel.textAlignment = .center
            
            self.ceremonyNameWYSIWYGLabel.frame = CGRect(x: 8, y: 205, width: 138, height: 10)
            self.ceremonyNameWYSIWYGLabel.textAlignment = .center
            
            self.ceremonyAddressWYSIWYGLabel.frame = CGRect(x: 8, y: 218, width: 138, height: 22.5)
            self.ceremonyAddressWYSIWYGLabel.textAlignment = .center
            
            self.ceremonyHourWYSIWYGLabel.frame = CGRect(x: 24, y: 241, width: 106, height: 10)
            self.ceremonyHourWYSIWYGLabel.textAlignment = .center
            
            self.receptionNameWYSIWYGLabel.frame = CGRect(x: 157, y: 205, width: 138, height: 10)
            self.receptionNameWYSIWYGLabel.textAlignment = .center
            
            self.receptionAddressWYSIWYGLabel.frame = CGRect(x: 157, y: 218, width: 138, height: 22.5)
            self.receptionAddressWYSIWYGLabel.textAlignment = .center
            
            self.receptionHourWYSIWYGLabel.frame = CGRect(x: 173, y: 241, width: 106, height: 9)
            self.receptionHourWYSIWYGLabel.textAlignment = .center
        }else if invitationTemplate.templateArrangement == 2 {
            self.invitationBGImageView.image = UIImage(named: "Clift_Invitaciones_Type_BG_4")
            self.yourNameWSIWYGLabel.textColor = UIColor(displayP3Red: 125/255, green: 125/255, blue: 125/255, alpha: 1.0)
            self.yourCoupleWSIWYGLabel.textColor = UIColor(displayP3Red: 125/255, green: 125/255, blue: 125/255, alpha: 1.0)
            self.shortMessageWSIWYGLabel.frame = CGRect(x: 16, y: 132, width: 175, height: 33)
            self.shortMessageWSIWYGLabel.textAlignment = .left
            self.yourNameWSIWYGLabel.frame = CGRect(x: 16, y: 74, width: 287, height: 19)
            self.yourNameWSIWYGLabel.textAlignment = .left
            self.yourCoupleWSIWYGLabel.frame = CGRect(x: 16, y: 101, width: 287, height: 19)
            self.yourCoupleWSIWYGLabel.textAlignment = .left
            self.yourFatherLabel.frame = CGRect(x: 16, y: 177, width: 138, height: 11)
            self.yourFatherLabel.textAlignment = .left
              self.yourMotherLabel.frame = CGRect(x: 16, y: 189, width: 138, height: 11)
              self.yourMotherLabel.textAlignment = .left
              self.coupleFatherLabel.frame = CGRect(x: 189, y: 177, width: 114, height: 11)
              self.coupleMotherLabel.frame = CGRect(x: 189, y: 189, width: 114, height: 11)
              self.dressCodeWYSIWYGLabel.frame = CGRect(x: 66,y:315,width: 170, height: 13)
              self.dressCodeWYSIWYGLabel.textAlignment = .center
              self.eventDateWSIWYGLabel.frame = CGRect(x: 16, y: 207, width: 187, height: 16)
              self.eventDateWSIWYGLabel.textAlignment = .left
              
              self.ceremonyNameWYSIWYGLabel.frame = CGRect(x: 16, y: 231, width: 138, height: 10)
              self.ceremonyNameWYSIWYGLabel.textAlignment = .left
              
              self.ceremonyAddressWYSIWYGLabel.frame = CGRect(x: 16, y: 244, width: 138, height: 22.5)
              self.ceremonyAddressWYSIWYGLabel.textAlignment = .left
              
              self.ceremonyHourWYSIWYGLabel.frame = CGRect(x: 16, y: 267, width: 127, height: 10)
              self.ceremonyHourWYSIWYGLabel.textAlignment = .left
              
              self.receptionNameWYSIWYGLabel.frame = CGRect(x: 165, y: 231, width: 138, height: 10)
              self.receptionNameWYSIWYGLabel.textAlignment = .left
              
              self.receptionAddressWYSIWYGLabel.frame = CGRect(x: 165, y: 244, width: 138, height: 22.5)
              self.receptionAddressWYSIWYGLabel.textAlignment = .left
              
              self.receptionHourWYSIWYGLabel.frame = CGRect(x: 165, y: 267, width: 122, height: 9)
              self.receptionHourWYSIWYGLabel.textAlignment = .left
        }
    }
    
}
