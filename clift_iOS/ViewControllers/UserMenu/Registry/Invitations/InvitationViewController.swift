//
//  InvitationViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/22/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import RealmSwift
import Realm

class InvitationViewController: UIViewController {
    
    var hasNotSaved = true
    var invitationTemplate = InvitationTemplate()
    var currentEvent = Event()
    var eventInformation = Event()
    var invitation = Invitation()
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadEvent()
        self.getEventInformation()
        self.loadContainerView()
    }
    
    func loadEvent() {
           let realm = try! Realm()
           let realmEvents = realm.objects(Event.self)
           if let currentEvent = realmEvents.first {
               self.currentEvent = currentEvent
           }
    }
    
    func getEventInformation() {
        sharedApiManager.showEvent(id: self.currentEvent.id) {(event, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.eventInformation = event!
                    if event!.invitation.id != "" {
                        self.invitation = event!.invitation
                    } else {
                        
                    }
                }
            }
        }
    }
    
    func loadContainerView() {
          if #available(iOS 13.0, *) {
              let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "editInvitationVC") as! InvitationEditFormTableViewController
            vc.invitationTemplate = self.invitationTemplate
            vc.eventInformation = self.eventInformation
              vc.invitationVC = self
              self.addChild(vc)
              vc.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
              self.containerView.addSubview(vc.view)
              vc.didMove(toParent: self)
          } else {
              let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editInvitationVC") as! InvitationEditFormTableViewController
            vc.invitationTemplate = self.invitationTemplate
            vc.eventInformation = self.eventInformation
              vc.invitationVC = self
              self.addChild(vc)
             vc.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
              self.containerView.addSubview(vc.view)
              vc.didMove(toParent: self)
          }
      }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if hasNotSaved {
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "discardChangesAlert") as! DiscardChangesAlertView
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            customAlert.delegate = self
            self.present(customAlert, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        if self.eventInformation.id != "" {
            self.updateInvitation()
            self.hasNotSaved = false
        } else {
            self.createInvitation()
            self.hasNotSaved = false
        }
    }
    
    func createInvitation() {
        sharedApiManager.createInvitation(event: self.eventInformation, invitationTemplate: self.invitationTemplate, invitation: self.invitation) {(invitation, result) in
            if let response = result {
                if response.isSuccess() {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func updateInvitation() {
        self.invitation.invitationTemplate = nil
        sharedApiManager.updateInvitation(event: self.eventInformation, invitation: self.invitation) { (invitation, result) in
            if let response = result {
                if response.isSuccess() {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    
    
    @IBAction func invitationPreviewButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
                   let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "previewInvitationVC") as! PreviewInvitationViewController
                   vc.invitationTemplate = self.invitationTemplate
            vc.invitation = self.invitation
            
                   self.navigationController?.pushViewController(vc, animated: true)
               } else {
                 // Fallback on earlier versions
                 let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "previewInvitationVC") as! PreviewInvitationViewController
                vc.invitationTemplate = self.invitationTemplate
            vc.invitation = self.invitation
                 self.navigationController?.pushViewController(vc, animated: true)
             }
    }
    
    
}
extension InvitationViewController: DiscardChangesViewDeleagate {
    func discardChangesButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func stayButtonTapped() {
        
    }
}
