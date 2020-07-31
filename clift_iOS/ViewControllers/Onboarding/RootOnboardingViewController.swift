//
//  RootOnboardingViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/9/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import GSMessages

class RootOnboardViewController: UIViewController {
    
    var onboardingUser = User()
    var eventType = Int()
    @IBOutlet weak var pageControlSelector: UIPageControl!
    private var pageViewController: UIPageViewController!
    var currentPage: Int?
    private var pendingPage: Int?
    @IBOutlet weak var nextButton: customButton!
    @IBOutlet weak var previousButton: customButton!
    @IBOutlet weak var startButton: customButton!
    
    private lazy var onboardingViewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstStepVC = storyboard.instantiateViewController(withIdentifier: "firstStepVC") as! FirstStepOnboardingViewController
        let secondStepVC = storyboard.instantiateViewController(withIdentifier: "secondStepVC") as! SecondStepOnboardingViewController
        let thirdStepVC = storyboard.instantiateViewController(withIdentifier: "thirdStepVC") as! ThirdStepOnboardingViewController
        let addressStepVC = storyboard.instantiateViewController(withIdentifier: "addressOnboardingVC") as! AddressOnboardingViewController
        let fourthStepVC = storyboard.instantiateViewController(withIdentifier: "fourthStepVC") as! FourthStepOnboardingViewController
        let fifthStepVC = storyboard.instantiateViewController(withIdentifier: "fifthStepVC") as! FifthStepOnboardingViewController
        let lastStepVC = storyboard.instantiateViewController(withIdentifier: "lastStepVC") as! LastStepOnboardingViewController
        
        firstStepVC.rootParentVC = self
        secondStepVC.rootParentVC = self
        thirdStepVC.rootParentVC = self
        addressStepVC.rootParentVC = self
        fourthStepVC.rootParentVC = self
        fifthStepVC.rootParentVC = self
        lastStepVC.rootParentVC = self
        
//        Please refer to this appended array for the order.
        viewControllers.append(contentsOf: [firstStepVC,secondStepVC,thirdStepVC,addressStepVC,fourthStepVC,fifthStepVC,lastStepVC])
        
        
        
        return viewControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupEventType()
        self.setupInitialPageControl()
        view.gestureRecognizers = []

    }
    
    func setupEventType() {
        self.onboardingUser.event.eventType = self.eventType
    }
    
    func setupInitialPageControl() {
        pageControlSelector.numberOfPages = onboardingViewControllers.count
        pageControlSelector.currentPage = 0
        self.currentPage = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UIPageViewController {
            pageViewController = vc
            pageViewController.dataSource = self
            pageViewController.delegate = self
            pageViewController.setViewControllers([onboardingViewControllers.first!], direction: .forward, animated: true, completion: nil)
            for view in self.pageViewController!.view.subviews{
                if let subView = view as? UIScrollView{
                    subView.isScrollEnabled = false
                }
            }
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        self.pageViewController.goToNextPage()
    }
    
    
    @IBAction func previousButtonClicked(_ sender: Any) {
        self.pageViewController.goToPreviousPage()
    }
    
    func createAccount(user: User) {
        sharedApiManager.postUsers(user: user) {(user,result) in
            if let response = result {
                if (response.isSuccess()) {
                    let postOnboardingVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postOnboardVC") as! PostOnboardingViewController
                    postOnboardingVC.onboardingEmail = self.onboardingUser.email
                    postOnboardingVC.onboardingPassword = self.onboardingUser.password
                    self.show(postOnboardingVC, sender: self)
                } else if (response.isClientError()) {
                    self.showMessage(NSLocalizedString("\(user!.errors.first!)", comment: "Account Error"),type: .error)
                    
                }
            }
        }
    }
    
    func postLoginSession() {
        sharedApiManager.login(email: self.onboardingUser.email, password: self.onboardingUser.password) { (session, result) in
            if let response = result {
                if response.isSuccess() {
                    if (session != nil && session?.token != "") {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.add(session!)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.userHasSuccesfullySignedIn()
                        }
                    }
                } else if (response.isClientError() && session != nil && !(session?.errors.isEmpty)!) {
                    self.showMessage(NSLocalizedString("\(session!.errors.first!)", comment: "Login Error"),type: .error)
                }
            }
        }
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        self.createAccount(user: self.onboardingUser)
        
       
    }
    
}
extension RootOnboardViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = onboardingViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard onboardingViewControllers.count > previousIndex else {
            return nil
        }
        
        return onboardingViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = onboardingViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let viewControllersCount = onboardingViewControllers.count
        
        guard nextIndex != viewControllersCount else {
            return nil
        }
        
        guard viewControllersCount > nextIndex else {
            return nil
        }
        
        return onboardingViewControllers[nextIndex]
    }
}

extension RootOnboardViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return onboardingViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingPage = onboardingViewControllers.firstIndex(of: pendingViewControllers.first!)
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentPage = pendingPage
            self.pageControlSelector.currentPage = currentPage!
        }
    }
}

