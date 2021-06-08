//
//  InvitationTemplatesViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 11/21/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class InvitationTemplatesViewController: UIViewController {
    
    
    @IBOutlet weak var invitationTemplatesCollectionView: UICollectionView!
    var invitationTemplates: [InvitationTemplate] = []
    var currentEvent = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.invitationTemplatesCollectionView.delegate = self
        self.invitationTemplatesCollectionView.dataSource = self
        self.loadEvent()
        self.getInvitationTemplates(event: currentEvent)
    }
    
    func loadEvent() {
        let realm = try! Realm()
        let realmEvents = realm.objects(Event.self)
        if let currentEvent = realmEvents.first {
            self.currentEvent = currentEvent
        }
    }
    
    func getInvitationTemplates(event: Event) {
        sharedApiManager.getInvitationTemplates(event: event) { (invitationTemplates, result) in
            if let response = result {
                if response.isSuccess() {
                    self.invitationTemplates = invitationTemplates!
                    self.invitationTemplatesCollectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension InvitationTemplatesViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.invitationTemplates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.invitationTemplatesCollectionView.dequeueReusableCell(withReuseIdentifier: "invitationTemplateCell", for: indexPath) as! InvitationTemplateCollectionViewCell
        cell.setup(invitationTemplate: invitationTemplates[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
                 let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "invitationVC") as! InvitationViewController
            vc.invitationTemplate = self.invitationTemplates[indexPath.row]
            vc.currentEvent = self.currentEvent
                 self.navigationController?.pushViewController(vc, animated: true)
             } else {
               // Fallback on earlier versions
               let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "invitationVC") as! InvitationViewController
            vc.invitationTemplate = self.invitationTemplates[indexPath.row]
            vc.currentEvent = self.currentEvent
               self.navigationController?.pushViewController(vc, animated: true)
           }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = UICollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader {
            let view = self.invitationTemplatesCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "invitationTemplatesHeader", for: indexPath)
               // do any programmatic customization, if any, here
               return view
        }
        return view
    }
}
