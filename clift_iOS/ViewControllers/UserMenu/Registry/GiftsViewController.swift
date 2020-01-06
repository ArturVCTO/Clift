//
//  GiftsViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/26/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
class GiftsViewController: UIViewController {
    
    
    @IBOutlet weak var giftsScrollView: UIScrollView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventTypeAndVisibilityLabel: UILabel!
    @IBOutlet weak var monthCountDownLabel: UILabel!
    @IBOutlet weak var weekCountDownLabel: UILabel!
    @IBOutlet weak var dayCountDownLabel: UILabel!
    @IBOutlet weak var productsAddedProgressButton: customButton!
    @IBOutlet weak var giftCountAnalyticsLabel: UILabel!
    @IBOutlet weak var giftUserActivityLabel: UILabel!
    @IBOutlet weak var dateActivityLabel: UILabel!
    @IBOutlet weak var eventImageView: customImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    var pageRefreshControl = UIRefreshControl()
    var containerView: UIView!
    var mainRegistryVC: MainRegistryViewController!
    @IBOutlet weak var registrySegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getEvents()
        self.pageRefreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        self.giftsScrollView.refreshControl = self.pageRefreshControl
        self.setupInitialView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getEvents()
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
    
    private lazy var paymentsViewController: PaymentsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "paymentsVC") as! PaymentsViewController
        viewController.containerView = self.containerView
        viewController.mainRegistryVC = self.mainRegistryVC
        
        return viewController
    }()
    
    func setupInitialView() {
        self.setupSegmentControl()
        self.registrySegmentControl.selectedSegmentIndex = 0
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
            remove(asChildViewController: paymentsViewController)
        case 1:
            remove(asChildViewController: self)
            remove(asChildViewController: paymentsViewController)
            add(asChildViewController: invitationsViewController)
            addView(asChildViewController: invitationsViewController)
        case 2:
            remove(asChildViewController: self)
            remove(asChildViewController: invitationsViewController)
            add(asChildViewController: paymentsViewController)
            addView(asChildViewController: paymentsViewController)
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
        
        if event.eventProgress.productsHaveBeenAdded == false {
            self.productsAddedProgressButton.isHidden = false
        } else {
            self.productsAddedProgressButton.isHidden = true
        }
        
        self.giftCountAnalyticsLabel.text = "\(event.eventAnalytics.giftCount)"
        
        if let eventImageURL = URL(string:"\(event.eventImageUrl)") {
            self.eventImageView.kf.setImage(with: eventImageURL)
        }
        
        if let coverImageURL = URL(string:"\(event.coverImageUrl)") {
            self.coverImageView.kf.setImage(with: coverImageURL)
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
        self.dayCountDownLabel.text = "\(difference.day ?? 0)"
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
    
    
    @IBAction func showSummaryVC(_ sender: Any) {
        if #available(iOS 13.0, *) {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "summaryRegistryVC") as! SummaryRegistryViewController
                self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "summaryRegistryVC") as! SummaryRegistryViewController
                self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
            }
        }
    
    @IBAction func tapEventRegistryButton(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "productsRegistryVC") as! ProductsRegistryViewController
            self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "productsRegistryVC") as! ProductsRegistryViewController
            self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
