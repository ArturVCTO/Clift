//
//  GuestListTableViewCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/21/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class GuestListTableViewCell: UITableViewCell {
    
    let menuDropDown = DropDown()
    
    override func awakeFromNib() {
        self.setupDropDownStyle()
        self.setupMenuDropDown()
        print(self.email)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupDropDownStyle() {
        let appearance = DropDown.appearance()
        appearance.cornerRadius = 4
        appearance.cellHeight = 40
    }
    
    func setupMenuDropDown() {
        
        var actions = [""]
        
        //invitation not sent with plus one OR pending not sent with plus one
        if ((isConfirmedStatus == "invitation_not_sent" && plusOneStatus) || (isConfirmedStatus == "pending" && plusOneStatus)) {
            actions = ["Quitar +1","Información"]
        }
        //invitation not sent without plus one OR pending without plus one
        else if ((isConfirmedStatus == "invitation_not_sent" && !plusOneStatus) || (isConfirmedStatus == "pending" && !plusOneStatus)){
            actions = ["Agregar +1","Información"]
        }
        //not attending or will attend with or without plus one
        else{
            actions = ["Información"]
        }
        menuDropDown.anchorView = self.menuButton
        menuDropDown.dataSource = actions
        menuDropDown.bottomOffset = CGPoint(x: 0, y: self.menuButton.bounds.height)
        
        menuDropDown.selectionAction = { [weak self] (index, item) in
            //Pending without plus one
            if item == "Información"{
                let guestInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "guestInfoVC") as!
                 GuestInfoViewController
                self?.vc.parent?.addChild(guestInfoVC)
                guestInfoVC.view.frame = self?.vc.parent?.view.frame as! CGRect
                self?.vc.parent?.view.addSubview(guestInfoVC.view)
                guestInfoVC.didMove(toParent: self?.vc.parent)
                guestInfoVC.guestNameLabel.text = self?.guestListNameLabel.text
                guestInfoVC.guestEmailLabel.text = self?.guestLIstEmailLabel.text
                guestInfoVC.guestPhoneLabel.text = self?.guestListTelephoneLabel.text
                if(self!.plusOneStatus){
                    guestInfoVC.guestPlusOneLabel.text = self?.companionName
                }else{
                    guestInfoVC.guestPlusOneLabel.text = "Sin Acompañante"
                }
                guestInfoVC.guestAddressLabel.text = self?.address
                if(self!.isConfirmedStatus == "will_attend"){
                    guestInfoVC.guestStatus.text = "Asistirá"
                    guestInfoVC.guestStatus.textColor = UIColor.systemGreen
                }
                else if(self!.isConfirmedStatus == "pending"){
                    guestInfoVC.guestStatus.text = "Pendiente"
                    guestInfoVC.guestStatus.textColor = UIColor.systemOrange
                }
                else if(self!.isConfirmedStatus == "not_attending"){
                    guestInfoVC.guestStatus.text = "No Asistirá"
                    guestInfoVC.guestStatus.textColor = UIColor.systemRed
                }
                else {
                    guestInfoVC.guestStatus.text = "No ha sido invitado"
                }
                
            }
            else{ //Agregar +1 o Quitar +1
                self!.guestsId.removeAll()
                self?.guestsId.append(self!.guestId)
                self!.updateGuest(event: self!.currentEvent, id: self!.guestsId, plusOne: !(self!.plusOneStatus))
               
            }
        }
    }
    
    
    var currentFilters = [String : Any]()
    var currentEvent = Event()
    var guestsId = [String]()
    var guestId = ""
    var email = ""
    var isConfirmedStatus = ""
    var plusOneStatus = false
    var companionName = ""
    var address = ""
    var indexCell : IndexPath? = nil
    @IBOutlet weak var inviteButton: customButton!
    @IBOutlet weak var guestListNameLabel: UILabel!
    @IBOutlet weak var guestLIstEmailLabel: UILabel!
    @IBOutlet weak var guestListTelephoneLabel: UILabel!
    @IBOutlet weak var guestListStatusLabel: UILabel!
    @IBOutlet weak var guestListStackView: UIStackView!
    @IBOutlet weak var guestListStatusImageView: UIImageView!
    @IBOutlet weak var guestListAssitingStatusStackView: UIStackView!
    @IBOutlet weak var guestListAssitingStatusLabel: UILabel!
    @IBOutlet weak var guestListAssitingStatusImageView: UIImageView!
    @IBOutlet weak var guestListPlus1StatusLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    var vc: GuestListViewController!
    
    @IBAction func guestListEllipsisButtonTapped(_ sender: Any) {
        self.menuDropDown.show()
    }
    
    @IBAction func inviteButtonTapped(_ sender: Any) {
        sharedApiManager.sendInvitation(event: currentEvent, email: email) {(emptyObject, result) in
            if let response = result {
                if response.isSuccess() {
                    self.vc.showMessage(NSLocalizedString("Se ha enviado la invitacion a tu invitado.", comment: ""),type: .success)
                    self.inviteButton.isHidden = true
                }
            }
        }
    }
    
    func updateGuest(event: Event, id: [String], plusOne: Bool) {
        sharedApiManager.updateGuests(event: event, guests: id, plusOne: plusOne ) { (emptyObject,result) in
            if let response = result {
                if response.isSuccess() {
                     self.vc.getGuests(event: self.currentEvent, filters: self.vc.currentFilters)
                     self.guestsId.removeAll()
                    self.vc.showMessage(NSLocalizedString("+1 de Invitado ha sido modificado", comment: "Update success"),type: .success)
                }
            }
        }
    }
    
    
    func setup(eventGuest: EventGuest) {
        self.isConfirmedStatus = eventGuest.isConfirmed
        self.plusOneStatus = eventGuest.has_plus_one
        self.guestId = eventGuest.id
        self.email = eventGuest.email
        self.guestListNameLabel.text = eventGuest.name
        self.guestLIstEmailLabel.text = eventGuest.email
        self.guestListTelephoneLabel.text = eventGuest.cellPhoneNumber
        self.companionName = eventGuest.companion_name
        self.address = eventGuest.address
        self.inviteButton.isHidden = true
        self.guestListStatusLabel.isHidden = true
        self.guestListStackView.isHidden = true
        
        if isConfirmedStatus == "invitation_not_sent"{
            self.guestListAssitingStatusStackView.isHidden = true
            self.inviteButton.isHidden = false
        }
        else if isConfirmedStatus == "pending"{
            self.guestListAssitingStatusImageView.image = UIImage(named: "icpending")
            self.guestListAssitingStatusLabel.text = "Pendiente"
            
        }
        else if isConfirmedStatus == "not_attending"{
            self.guestListAssitingStatusImageView.image = UIImage(named: "icnotassisting")
            self.guestListAssitingStatusLabel.text = "No Asistirá"
            
        }
        else if isConfirmedStatus == "will_attend"{
            self.guestListAssitingStatusImageView.image = UIImage(named: "icassisting")
            self.guestListAssitingStatusLabel.text = "Asistirá"
        }
        
        if plusOneStatus{
            self.guestListStatusLabel.isHidden = false
            if isConfirmedStatus == "will_attend"{
                self.guestListStackView.isHidden = false
            }
        }
        
    }
    
    
}
