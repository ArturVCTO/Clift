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
    }
    
    func setupDropDownStyle() {
        let appearance = DropDown.appearance()
        appearance.cornerRadius = 4
        appearance.cellHeight = 40
    }
    
    func setupMenuDropDown() {
        let actions = ["Modificar +1"]
        menuDropDown.anchorView = self.menuButton
        menuDropDown.dataSource = actions
        menuDropDown.bottomOffset = CGPoint(x: 0, y: self.menuButton.bounds.height)
        
        menuDropDown.selectionAction = { [weak self] (index, item) in
            if self?.isConfirmedStatus == "pending" {
                self!.guestsId.removeAll()
                self?.guestsId.append(self!.guestId)
                self!.updateGuest(event: self!.currentEvent, isConfirmed: 3, id: self!.guestsId)
                self!.vc.getGuests(event: self!.currentEvent, filters: self!.vc.currentFilters)
                self!.guestsId.removeAll()
            } else if self!.isConfirmedStatus == "pending_with_plus_one" {
                self!.guestsId.removeAll()
                self?.guestsId.append(self!.guestId)
                self!.updateGuest(event: self!.currentEvent, isConfirmed: 1, id: self!.guestsId)
                self!.vc.getGuests(event: self!.currentEvent, filters: self!.vc.currentFilters)
                self!.guestsId.removeAll()
            } else if self!.isConfirmedStatus == "invitation_not_sent_with_plus_one" {
                self!.guestsId.removeAll()
               self?.guestsId.append(self!.guestId)
               self!.updateGuest(event: self!.currentEvent, isConfirmed: 0, id: self!.guestsId)
               self!.vc.getGuests(event: self!.currentEvent, filters: self!.vc.currentFilters)
               self!.guestsId.removeAll()
            } else if self!.isConfirmedStatus == "invitation_not_sent" {
                self!.guestsId.removeAll()
               self?.guestsId.append(self!.guestId)
               self!.updateGuest(event: self!.currentEvent, isConfirmed: 8, id: self!.guestsId)
               self!.vc.getGuests(event: self!.currentEvent, filters: self!.vc.currentFilters)
               self!.guestsId.removeAll()
            }
            
        }
    }
    
    
    var currentFilters = [String : Any]()
    var currentEvent = Event()
    var guestsId = [String]()
    var guestId = ""
    var email = ""
    var isConfirmedStatus = ""
    @IBOutlet weak var inviteButton: customButton!
    @IBOutlet weak var guestListNameLabel: UILabel!
    @IBOutlet weak var guestLIstEmailLabel: UILabel!
    @IBOutlet weak var guestListTelephoneLabel: UILabel!
    @IBOutlet weak var guestListStatusLabel: UILabel!
    @IBOutlet weak var guestListStackView: UIStackView!
    @IBOutlet weak var guestListStatusImageView: UIImageView!
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
    
    func updateGuest(event: Event, isConfirmed: Int, id: [String]) {
        sharedApiManager.updateGuests(event: event, isConfirmed: isConfirmed, guests: id) { (emptyObject,result) in
            if let response = result {
                if response.isSuccess() {
                    print("Guest updated!")
                }
            }
        }
    }
    
    
    func setup(eventGuest: EventGuest) {
        self.isConfirmedStatus = eventGuest.isConfirmed
        self.guestId = eventGuest.id
        self.email = eventGuest.email
        self.guestListNameLabel.text = eventGuest.name
        self.guestLIstEmailLabel.text = eventGuest.email
        self.guestListTelephoneLabel.text = eventGuest.cellPhoneNumber
        if eventGuest.status {
            self.inviteButton.isHidden = true
        } else {
            self.inviteButton.isHidden = false
        }
        if eventGuest.isConfirmed == "not_attending_with_plus_one" || eventGuest.isConfirmed == "not_attending"{
            self.guestListStatusLabel.isHidden = true
            self.guestListStackView.isHidden = true
            self.menuButton.isHidden = true
        } else if eventGuest.isConfirmed == "invitation_not_sent_with_plus_one" || eventGuest.isConfirmed == "pending_with_plus_one" || eventGuest.isConfirmed == "confirmed_with_plus_one" || eventGuest.isConfirmed == "confirmed_and_rejected_plus_one"{
            self.menuButton.isHidden = false
            if eventGuest.isConfirmed == "confirmed_and_rejected_plus_one" {
                self.guestListPlus1StatusLabel.text = "Rechazo +1"
                self.guestListStatusImageView.image = UIImage(named: "icnotassisting")
                self.guestListStackView.isHidden = false
                self.guestListStatusLabel.isHidden = false
            } else if eventGuest.isConfirmed == "confirmed_with_plus_one" {
                self.guestListPlus1StatusLabel.text = "Usó +1"
                self.guestListStatusImageView.image = UIImage(named: "icassisting")
                self.guestListStackView.isHidden = false
                self.guestListStatusLabel.isHidden = false
            } else {
                self.guestListStackView.isHidden = true
                self.guestListStatusLabel.isHidden = false
            }
        } else {
            self.menuButton.isHidden = false
            self.guestListStatusLabel.isHidden = true
            self.guestListStackView.isHidden = true
        }
    }
}
