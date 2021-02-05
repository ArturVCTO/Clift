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
    
    static func make() -> GiftsViewController {
        let storyboard = UIStoryboard(name: "GiftsViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "giftsVC") as! GiftsViewController
    }
    
    @IBOutlet weak var giftsScrollView: UIScrollView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel! {
        didSet {
            eventDateLabel?.addCharactersSpacing(1)
        }
    }
    
    @IBOutlet weak var eventTypeAndVisibilityLabel: UILabel!
    @IBOutlet weak var giftSummaryButton: customButton!
    @IBOutlet weak var monthCountDownLabel: UILabel!
    @IBOutlet weak var weekCountDownLabel: UILabel!
    @IBOutlet weak var dayCountDownLabel: UILabel!


    @IBOutlet weak var giftCountAnalyticsLabel: UILabel!
    @IBOutlet weak var giftUserActivityLabel: UILabel!
    @IBOutlet weak var giftUserActivityView: customView!
    @IBOutlet weak var dateActivityLabel: UILabel!
    @IBOutlet weak var eventImageView: customImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    var pageRefreshControl = UIRefreshControl()
    var containerView: UIView!
    var mainRegistryVC: MainRegistryViewController!
    var currentEvent: Event!
    @IBOutlet weak var registrySegmentControl: UISegmentedControl!

    @IBOutlet weak var mostRecentActivityDateLabel: UILabel!
    @IBOutlet weak var mostRecentActivityLabel: UILabel!
    @IBOutlet weak var giftsReceivedLabel: UILabel!
    @IBOutlet weak var tableGiftButton: customButton! {
        didSet {
            tableGiftButton?.setTitle("VER MI LISTA DE REGALOS", for: .normal)
            tableGiftButton.titleLabel?.addCharactersSpacing(1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getEvents()
        self.pageRefreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        self.giftsScrollView.refreshControl = self.pageRefreshControl
        self.mainRegistryVC.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        
        //HIDE ACTIVITY VIEW
        self.giftUserActivityView.isHidden = true
        self.giftSummaryButton.isHidden = true
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
    
    @IBAction func tableGiftButtonPressed(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "GiftsViewController", bundle: nil).instantiateViewController(identifier: "UserGiftTableVC") as! UserGiftTableViewController
            vc.currentEvent = currentEvent
            self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "GiftsViewController", bundle: nil).instantiateViewController(withIdentifier: "UserGiftTableVC") as! UserGiftTableViewController
            vc.currentEvent = currentEvent
            self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
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
		self.eventNameLabel.text = event.name
        self.eventDateLabel.text = event.dateWithOfWord().uppercased()
        self.eventDateLabel.addCharactersSpacing(1)
        self.countDownCalendar(eventDate: event.date.stringToDate())
        
		self.eventTypeAndVisibilityLabel.text = event.stringType() + " · " + event.stringVisibility()
        
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
        self.monthCountDownLabel.text = "\( (difference.month ?? 0) + ( difference.year ?? 0)*12)"
        self.weekCountDownLabel.text = "\(difference.weekOfMonth ?? 0)"
        self.dayCountDownLabel.text = "\(difference.day ?? 0)"
    }
    
    func showEvent(id: String) {
        sharedApiManager.showEvent(id: id) {(event, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.currentEvent = event
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
