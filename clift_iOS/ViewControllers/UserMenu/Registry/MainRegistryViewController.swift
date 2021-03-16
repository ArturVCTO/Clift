
//
//  Rgk.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/26/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
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
        let viewController = GiftsViewController.make()
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
}

