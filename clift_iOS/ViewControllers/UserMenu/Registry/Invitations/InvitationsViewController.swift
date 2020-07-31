//
//  RegistryViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/26/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

class InvitationsViewController: UIViewController,CNContactPickerDelegate{
    
    
    @IBOutlet weak var totalAssistAnalytics: UILabel!
    @IBOutlet weak var willNotAssistAnalytics: UILabel!
    @IBOutlet weak var pendingAssistAnalytics: UILabel!
    @IBOutlet weak var willAssistAnalytics: UILabel!
    @IBOutlet weak var chosenInvitationCollectionView: UICollectionView!
    @IBOutlet weak var invitationTemplatesCollectionView: UICollectionView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTypeAndVisibilityLabel: UILabel!
    @IBOutlet weak var monthCountDownLabel: UILabel!
    @IBOutlet weak var weeksCountDownLabel: UILabel!
    @IBOutlet weak var daysCountDownLabel: UILabel!
    @IBOutlet weak var guestsHaveBeenInvitedProgressButton: customButton!
    @IBOutlet weak var assistanceAnalyticsCount: UILabel!
    @IBOutlet weak var userInvitationActivityLabel: UILabel!
    @IBOutlet weak var dateInvitationActivityLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var eventImageView: customImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var pageRefreshControl = UIRefreshControl()
    var containerView: UIView!
    var mainRegistryVC: MainRegistryViewController!
    @IBOutlet weak var registrySegmentControl: UISegmentedControl!
    var invitationTemplates = [InvitationTemplate]()

    // If user has not invited guests
    @IBOutlet weak var inviteesGuestListAnalyticsSV: UIStackView!
    @IBOutlet weak var totalGuestsView: customView!
    @IBOutlet weak var recentActivityView: customView!
    @IBOutlet weak var guestListButton: UIButton!
    @IBOutlet weak var myInvitationStackView: UIStackView!
    @IBOutlet weak var totalGuestsAndRecentActivitySV: UIStackView!
    @IBOutlet weak var emptySpaceHaveNotInvitedView: customView!
    var currentEvent = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.invitationTemplatesCollectionView.dataSource = self
        self.invitationTemplatesCollectionView.delegate = self
        self.chosenInvitationCollectionView.delegate = self
        self.chosenInvitationCollectionView.dataSource = self
        self.setupInitialView()
        self.pageRefreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        self.scrollView.refreshControl = self.pageRefreshControl
    }
    
    @objc func refreshPage() {
        self.getEvents()
        self.pageRefreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getEvents()
        self.setupInitialView()
    }
    
    private lazy var giftsViewController: GiftsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "giftsVC") as! GiftsViewController
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
        self.registrySegmentControl.selectedSegmentIndex = 1
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
            remove(asChildViewController: self)
            remove(asChildViewController: paymentsViewController)
            add(asChildViewController: giftsViewController)
            addView(asChildViewController: giftsViewController)
        case 1:
            remove(asChildViewController: self)
            remove(asChildViewController: paymentsViewController)
        case 2:
            remove(asChildViewController: self)
            remove(asChildViewController: giftsViewController)
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
    
    func loadEventInformation(event: Event) {
        var eventVisibilityString = String()
        var eventTypeString = String()
        
        self.eventNameLabel.text = event.name
        self.eventDateLabel.text = event.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        self.eventDateLabel.text = dateFormatter.string(from: event.date.stringToDate())
        
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
        
//        if event.eventProgress.guestsHaveBeenInvited == false {
//            self.guestsHaveBeenInvitedProgressButton.isHidden = false
//        } else {
//            self.guestsHaveBeenInvitedProgressButton.isHidden = true
//        }
        if event.eventProgress.invitationHasBeenChosen {
            self.myInvitationStackView.isHidden = false
        } else {
            self.myInvitationStackView.isHidden = true
        }
        
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
        self.monthCountDownLabel.text = "\( (difference.month ?? 0) + ( difference.year ?? 0)*12)"
        self.weeksCountDownLabel.text = "\(difference.weekOfMonth ?? 0)"
        self.daysCountDownLabel.text = "\(difference.day ?? 0)"
    }
    
    func showEvent(id: String) {
        sharedApiManager.showEvent(id: id) {(event, result) in
            if let response = result {
                if (response.isSuccess()) {
                    self.loadEventInformation(event: event!)
                    self.currentEvent = event!
                    self.getInvitationTemplates(event: event!)
                    self.getEventGuestAnalytics(event: event!)
                    if event!.invitation.id != "" {
                        self.chosenInvitationCollectionView.reloadData()
                    } else {
                        return
                    }
                    
                    
                }
            }
        }
    }
    
    func getEventGuestAnalytics(event: Event) {
        sharedApiManager.getGuestAnalytics(event: event) {(analytics,result) in
            if let response = result {
                if response.isSuccess() {
                    self.getAnalyticsInformation(analytics: analytics!)
                }
            }
        }
    }
    
    func getAnalyticsInformation(analytics: EventGuestAnalytics) {
        self.willNotAssistAnalytics.text = "\(analytics.willNotAttend)"
        self.willAssistAnalytics.text = "\(analytics.willAttend)"
        self.pendingAssistAnalytics.text = "\(analytics.pending)"
        self.totalAssistAnalytics.text = "\(analytics.total)"
        
        if analytics.total > 0 {
            self.inviteesGuestListAnalyticsSV.isHidden = false
            self.totalGuestsAndRecentActivitySV.isHidden = false
            self.guestListButton.isHidden = false
            self.emptySpaceHaveNotInvitedView.isHidden = true
            
        } else {
            self.inviteesGuestListAnalyticsSV.isHidden = true
            self.totalGuestsAndRecentActivitySV.isHidden = true
            self.guestListButton.isHidden = true
            self.emptySpaceHaveNotInvitedView.isHidden = false
        }
        

    }
    
    @IBAction func seeGuestListButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "guestListVC") as! GuestListViewController
            vc.eventInformation = self.currentEvent
            vc.invitationsVC = self
                self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
               } else {
                 // Fallback on earlier versions
                 let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "guestListVC") as! GuestListViewController
            vc.invitationsVC = self
                self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
             }
    }
    
    
    @IBAction func editChosenInvitationButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "invitationVC") as! InvitationViewController
            vc.eventInformation = self.currentEvent
            vc.invitationTemplate = self.currentEvent.invitation.invitationTemplate!
            self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "invitationVC") as! InvitationViewController
            vc.invitationTemplate = self.currentEvent.invitation.invitationTemplate!
                vc.eventInformation = self.currentEvent
               self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    
    @IBAction func seeAllInvitationTemplatesButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
             let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "invitationTemplatesVC") as! InvitationTemplatesViewController
             
            self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
         } else {
           // Fallback on earlier versions
           let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "invitationTemplatesVC") as! InvitationTemplatesViewController
           self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
       }
    }
        
    @IBAction func addGuestsButtonTapped(_ sender: Any) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let addManually = UIAlertAction(title: "Agregar manualmente", style: .default,handler: importFromGmailButtonPressed(alert:))
        let addFromPhoneBook = UIAlertAction(title: "Agregar de tus contactos de tu telefono", style: .default,handler: phoneBookButtonPressed(alert:))
         let cancelAction = UIAlertAction(title: "CANCELAR", style: .cancel)
         
        addManually.setValue(UIColor.init(displayP3Red: 49/255, green: 48/255, blue: 60/255, alpha: 1.0), forKey: "titleTextColor")
        
          addFromPhoneBook.setValue(UIColor.init(displayP3Red: 49/255, green: 48/255, blue: 60/255, alpha: 1.0), forKey: "titleTextColor")
        
        
          cancelAction.setValue(UIColor.init(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0), forKey: "titleTextColor")
         sheet.addAction(addManually)
         sheet.addAction(addFromPhoneBook)
         sheet.addAction(cancelAction)
         
         present(sheet, animated: true, completion: nil)
    }
    
    func phoneBookButtonPressed(alert: UIAlertAction) {
       let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker,animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        var guests: [EventGuest] = []
        for contact in contacts {
            let guest = EventGuest()
            guest.name = "\(contact.givenName) \(contact.familyName)"
            
            if let phoneBookEmailAddress = contact.emailAddresses.first {
                guest.email = phoneBookEmailAddress.value as String
            }
            
            if let phoneBookNumber = contact.phoneNumbers.first {
                guest.cellPhoneNumber = phoneBookNumber.value.stringValue
            }
            guest.eventId = self.currentEvent.id
            if let creator = self.currentEvent.creator {
                guest.userId = creator.id
            }
            guests.append(guest)
            
        }
        
        sharedApiManager.addGuests(event: self.currentEvent, guest: guests) { (emptyObject,result) in
            if let response = result {
                if response.isSuccess() {
                    if #available(iOS 13.0, *) {
                                 let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "guestListVC") as! GuestListViewController
                                    
                                 self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
                                vc.showMessage(NSLocalizedString("Se han agregado tus invitados", comment: ""),type: .success)

                                } else {
                                  // Fallback on earlier versions
                                  let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "guestListVC") as! GuestListViewController
                                 self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
                                vc.showMessage(NSLocalizedString("Se han agregado tus invitados", comment: ""),type: .success)
                              }
                } else {
                    self.showMessage(NSLocalizedString("\(emptyObject!.errors.first!)", comment: ""),type: .error)
                }
            }
        }
    }
    
    func importFromGmailButtonPressed(alert: UIAlertAction) {
        if #available(iOS 13.0, *) {
                   let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "addGuestsVC") as! AddGuestsViewController
                   
                  self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
               } else {
                 // Fallback on earlier versions
                 let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addGuestsVC") as! AddGuestsViewController
                 self.mainRegistryVC.navigationController?.pushViewController(vc, animated: true)
             }
    }
    
    
    
}
extension InvitationsViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount = Int()
        if collectionView == invitationTemplatesCollectionView {
            cellCount = self.invitationTemplates.count
            return cellCount
        } else if collectionView == chosenInvitationCollectionView {
            if (self.currentEvent.invitation.id != "") {
                cellCount = 1
            } else {
                cellCount = 0
            }
            
            return cellCount
        }
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView == invitationTemplatesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainInvitationTemplatesCell", for: indexPath) as! MainInvitationTemplateCVCell
            cell.setup(invitationTemplate: self.invitationTemplates[indexPath.row])
            return cell
        } else if collectionView == chosenInvitationCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainChosenInvitationCell", for: indexPath) as! MainChosenInvitationCVCell
            cell.setup(invitation: self.currentEvent.invitation)
            return cell
        }
        return cell
    }
    
    
}
