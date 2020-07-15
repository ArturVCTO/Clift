//
//  ThirdStepOnboardingViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/8/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class ThirdStepOnboardingViewController: UIViewController {
    var rootParentVC: RootOnboardViewController!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.rootParentVC.onboardingUser.toJSON())
        self.updateCurrentPageSelector()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateCurrentPageSelector()
    }
    
    func updateCurrentPageSelector() {
        self.rootParentVC.pageControlSelector.currentPage = 2
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        self.rootParentVC.onboardingUser.event.date = eventDatePicker.date.eventDateFormatter()
    }
}
