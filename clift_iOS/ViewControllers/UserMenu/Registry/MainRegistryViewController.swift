
//
//  Rgk.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/26/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import RealmSwift
import Realm

protocol CurrentEvent {
    func getCurrentEvent() -> Event
}

class MainRegistryViewController: UIViewController{
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var registrySegmentControl: UISegmentedControl!
    weak var currentEventDelegate: CurrentEventDelegate? = nil
    var event = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getEvents()
        self.setupInitialView()
    }
    
    private lazy var giftsViewController: GiftsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "giftsVC") as! GiftsViewController
        viewController.mainRegistryVC = self
        viewController.containerView = self.containerView
        
        return viewController
    }()
    
    private lazy var invitationsViewController: InvitationsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "invitationsVC") as! InvitationsViewController
        viewController.containerView = self.containerView
        viewController.mainRegistryVC = self
        return viewController
    }()
    
    private lazy var paymentsViewController: PaymentsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "paymentsVC") as! PaymentsViewController
        viewController.containerView = self.containerView
        viewController.mainRegistryVC = self
        
        return viewController
    }()
    
    func setupInitialView() {
        self.setupSegmentControl()
        self.registrySegmentControl.selectedSegmentIndex = 0
        self.registrySegmentControl.sendActions(for: UIControl.Event.valueChanged)
    }
    
    func setupSegmentControl() {
        self.registrySegmentControl.removeAllSegments()
        self.registrySegmentControl.insertSegment(withTitle: "Regalos", at: 0, animated: true)
        self.registrySegmentControl.insertSegment(withTitle: "Invitados", at: 1, animated: true)
        self.registrySegmentControl.insertSegment(withTitle: "Dinero", at: 2, animated: true)
        self.registrySegmentControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        self.updateView()
    }
    
    func updateView() {
        switch registrySegmentControl.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: invitationsViewController)
            remove(asChildViewController: paymentsViewController)
            add(asChildViewController: giftsViewController)
            addView(asChildViewController: giftsViewController)
        case 1:
            remove(asChildViewController: giftsViewController)
            remove(asChildViewController: paymentsViewController)
            add(asChildViewController: invitationsViewController)
            addView(asChildViewController: invitationsViewController)
        case 2:
            remove(asChildViewController: giftsViewController)
            remove(asChildViewController: invitationsViewController)
            add(asChildViewController: paymentsViewController)
            addView(asChildViewController: paymentsViewController)
        default:
            break
        }
    }
    
    private func addView(asChildViewController viewController: UIViewController) {
        containerView.addSubview(viewController.view)
        viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        
        viewController.removeFromParent()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
    }
    
    @IBAction func optionsButtonTapped(_ sender: Any) {
        let sheet = UIAlertController(title: "Opciones de mesa", message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Editar", style: .default, handler: editButtonPressed(alert:))
        let shareAction = UIAlertAction(title: "Compartir", style: .default, handler: shareButtonPressed(alert:))
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
       editAction.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
        
        shareAction.setValue(UIColor.init(displayP3Red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forKey: "titleTextColor")
        cancelAction.setValue(UIColor.init(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0), forKey: "titleTextColor")
        sheet.addAction(editAction)
        sheet.addAction(shareAction)
        sheet.addAction(cancelAction)
        
        present(sheet, animated: true, completion: nil)
    }
    
    func editButtonPressed(alert: UIAlertAction) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editRegistryVC = storyboard.instantiateViewController(withIdentifier: "editRegistryVC") as! EditRegistryViewController
        editRegistryVC.eventId = self.event.id
        editRegistryVC.giftsVC = giftsViewController
        editRegistryVC.invitationsVC = invitationsViewController
        editRegistryVC.paymentsVC = paymentsViewController
        
        self.navigationController?.pushViewController(editRegistryVC, animated: true)
    }
    
    func shareButtonPressed(alert: UIAlertAction) {
        if let link = NSURL(string: "http://cliftapp.com/gift-table?id=\(self.event.id)")
        {
            let objectsToShare = [link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func getEvents() {
        sharedApiManager.getEvents() { (events, result) in
            if let response = result {
                if (response.isSuccess()) {
//                    self.currentEventDelegate?.currentEvent = events!.first!
                    self.showEvent(id: events!.first!.id)
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(events!.first!)
                    }
                }
            }
        }
    }
    
    func showEvent(id: String) {
        sharedApiManager.showEvent(id: id) {(event, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.event = event!
                    self.event.id = event!.id
                }
            }
        }
    }
    
    @IBAction func myEventsSideMenuTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "myEventsSideMenu") as! MyEventsTableViewController
        viewController.mainRegistryVC = self
        let menu = UISideMenuNavigationController(rootViewController: viewController)
        menu.leftSide = true
        present(menu,animated: true, completion: nil)
    }
    
}

