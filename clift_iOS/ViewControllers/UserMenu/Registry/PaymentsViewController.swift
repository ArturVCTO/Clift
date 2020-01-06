//
//  CashViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/26/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class PaymentsViewController: UIViewController {
    
    @IBOutlet weak var eventImageView: customImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventTypeAndVisibilityLabel: UILabel!
    @IBOutlet weak var monthCountDownLabel: UILabel!
    @IBOutlet weak var weekCountDownLabel: UILabel!
    @IBOutlet weak var daysCountDownLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var pageRefreshControl = UIRefreshControl()

    
    var containerView: UIView!
    var mainRegistryVC: MainRegistryViewController!
    @IBOutlet weak var registrySegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageRefreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        self.scrollView.refreshControl = self.pageRefreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getEvents()
        self.setupInitialView()
    }
    
    
    @objc func refreshPage() {
        self.getEvents()
        self.pageRefreshControl.endRefreshing()
    }
    
    private lazy var invitationsViewController: InvitationsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "invitationsVC") as! InvitationsViewController
        viewController.containerView = self.containerView
        viewController.mainRegistryVC = self.mainRegistryVC
        
        return viewController
    }()
    
    private lazy var giftsViewController: GiftsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "giftsVC") as! GiftsViewController
        viewController.containerView = self.containerView
        viewController.mainRegistryVC = self.mainRegistryVC
        
        return viewController
    }()
    
    func setupInitialView() {
        self.setupSegmentControl()
        self.registrySegmentControl.selectedSegmentIndex = 2
        self.registrySegmentControl.sendActions(for: UIControl.Event.valueChanged)
    }
    
    func setupSegmentControl() {
        self.registrySegmentControl.removeAllSegments()
        self.registrySegmentControl.insertSegment(withTitle: "Regalos", at: 0, animated: false)
        self.registrySegmentControl.insertSegment(withTitle: "Invitados", at: 1, animated: false)
        self.registrySegmentControl.insertSegment(withTitle: "Dinero", at: 2, animated: false)
        self.registrySegmentControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        self.updateView()
    }
    
    func updateView() {
        switch registrySegmentControl.selectedSegmentIndex {
        case 0:
            remove(asChildViewController: invitationsViewController)
            remove(asChildViewController: self)
            add(asChildViewController: giftsViewController)
            addView(asChildViewController: giftsViewController)
        case 1:
            remove(asChildViewController: self)
            remove(asChildViewController: giftsViewController)
            add(asChildViewController: invitationsViewController)
            addView(asChildViewController: invitationsViewController)
        case 2:
            remove(asChildViewController: self)
            remove(asChildViewController: invitationsViewController)
        default:
            break
        }
    }
    
    private func addView(asChildViewController viewController: UIViewController) {
        self.containerView.addSubview(viewController.view)
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
        self.containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
    }
    
    
    func getEvents() {
        sharedApiManager.getEvents() { (events, result) in
            if let response = result {
                if (response.isSuccess()) {
                    print("\(events!.first!.id)")
                    self.showEvent(id: events!.first!.id)
                }
            }
        }
    }
    
    func loadEventInformation(event: Event) {
        var eventVisibilityString = String()
        var eventTypeString = String()
        
        self.eventNameLabel.text = event.name
        self.countDownCalendar(eventDate: event.date.stringToDate())
        
        switch event.visibility {
        case 0:
            eventVisibilityString = "Evento Privado"
        case 1:
            eventVisibilityString = "Evento Público"
        default:
            break
        }
        
        switch event.eventType {
        case 0:
            eventTypeString = "Boda"
        case 1:
            eventTypeString = "XV Años"
        case 2:
            eventTypeString = "Baby Shower"
        case 3:
            eventTypeString = "Cumpleaños"
        case 4:
            eventTypeString = "Otro"
        default:
            break
        }
        
        self.eventTypeAndVisibilityLabel.text = eventTypeString + " - " + eventVisibilityString
        
        if let imageURL = URL(string:"\(event.eventImageUrl)") {
            self.eventImageView.kf.setImage(with: imageURL)
        }
        
        if let imageURL = URL(string:"\(event.coverImageUrl)") {
            self.coverImageView.kf.setImage(with: imageURL)
        }
    }
    
    func countDownCalendar(eventDate: Date) {
        let date = NSDate()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month,.weekOfMonth,.day], from: date as Date)
        let currentDate = calendar.date(from: components)
        
        //        let eventDateComponents = calendar.dateComponents([.month,.weekOfYear,.day], from: eventDate)
        
        let difference = calendar.dateComponents([.year,.month,.weekOfMonth,.day], from: currentDate!, to: eventDate)
        self.monthCountDownLabel.text = "\(difference.month ?? 0)"
        self.weekCountDownLabel.text = "\(difference.weekOfMonth ?? 0)"
        self.daysCountDownLabel.text = "\(difference.day ?? 0)"
    }
    
    
    func showEvent(id: String) {
        sharedApiManager.showEvent(id: id) {(event, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.loadEventInformation(event: event!)
                }
            }
        }
    }
}
