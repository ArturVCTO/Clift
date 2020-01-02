//
//  OnboardingEventType.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/15/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class OnboardingEventTypeViewController: UIViewController {
    
    @IBOutlet weak var weddingEventTypeButton: customButton!
    @IBOutlet weak var babyShowerEventTypeButton: customButton!
    @IBOutlet weak var birthdayEventTypeButton: customButton!
    @IBOutlet weak var otherEventTypeButton: customButton!
    @IBOutlet weak var nextButton: customButton!
    var eventType = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.typeSelectedValidator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.typeSelectedValidator()
    }
    
    @IBAction func weddingButtonTapped(_ sender: Any) {
        if weddingEventTypeButton.isSelected == true {
            weddingEventTypeButton.isSelected = false
             weddingEventTypeButton.backgroundColor = UIColor(named: "transparent")
        } else {
            weddingEventTypeButton.isSelected = true
            self.eventType = 0
            
            babyShowerEventTypeButton.isSelected = false
            birthdayEventTypeButton.isSelected = false
            otherEventTypeButton.isSelected = false
            babyShowerEventTypeButton.backgroundColor = UIColor(named: "transparent")
            birthdayEventTypeButton.backgroundColor = UIColor(named: "transparent")
            otherEventTypeButton.backgroundColor = UIColor(named: "transparent")
            weddingEventTypeButton.backgroundColor = UIColor(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0)
        }
        self.typeSelectedValidator()
    }
    
    func typeSelectedValidator() {
        if weddingEventTypeButton.isSelected == true || babyShowerEventTypeButton.isSelected == true || birthdayEventTypeButton.isSelected == true || otherEventTypeButton.isSelected == true {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    @IBAction func babyShowerButtonTapped(_ sender: Any) {
        if babyShowerEventTypeButton.isSelected == true {
            babyShowerEventTypeButton.isSelected = false
            babyShowerEventTypeButton.backgroundColor = UIColor(named: "transparent")
        } else {
            babyShowerEventTypeButton.isSelected = true
            self.eventType = 2
            weddingEventTypeButton.isSelected = false
            birthdayEventTypeButton.isSelected = false
            otherEventTypeButton.isSelected = false
            weddingEventTypeButton.backgroundColor = UIColor(named: "transparent")
            birthdayEventTypeButton.backgroundColor = UIColor(named: "transparent")
            otherEventTypeButton.backgroundColor = UIColor(named: "transparent")
            babyShowerEventTypeButton.backgroundColor = UIColor(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0)
        }
        self.typeSelectedValidator()
    }
    
    @IBAction func birthdayButtonTapped(_ sender: Any) {
        if birthdayEventTypeButton.isSelected == true {
            birthdayEventTypeButton.isSelected = false
            birthdayEventTypeButton.backgroundColor = UIColor(named: "transparent")
        } else {
            birthdayEventTypeButton.isSelected = true
            self.eventType = 3
            weddingEventTypeButton.isSelected = false
            babyShowerEventTypeButton.isSelected = false
            otherEventTypeButton.isSelected = false
            weddingEventTypeButton.backgroundColor = UIColor(named: "transparent")
            babyShowerEventTypeButton.backgroundColor = UIColor(named: "transparent")
            otherEventTypeButton.backgroundColor = UIColor(named: "transparent")
            birthdayEventTypeButton.backgroundColor = UIColor(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0)
        }
        self.typeSelectedValidator()
    }
    
    @IBAction func otherButtonTapped(_ sender: Any) {
        if otherEventTypeButton.isSelected == true {
            otherEventTypeButton.isSelected = false
            otherEventTypeButton.backgroundColor = UIColor(named: "transparent")
        } else {
            otherEventTypeButton.isSelected = true
            self.eventType = 4
            weddingEventTypeButton.isSelected = false
            babyShowerEventTypeButton.isSelected = false
            birthdayEventTypeButton.isSelected = false
            weddingEventTypeButton.backgroundColor = UIColor(named: "transparent")
            babyShowerEventTypeButton.backgroundColor = UIColor(named: "transparent")
            birthdayEventTypeButton.backgroundColor = UIColor(named: "transparent")
            otherEventTypeButton.backgroundColor = UIColor(displayP3Red: 117/255, green: 126/255, blue: 106/255, alpha: 1.0)
        }
        self.typeSelectedValidator()
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let rootOnboardingVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rootOnboardVC") as! RootOnboardViewController
        rootOnboardingVC.eventType = self.eventType
        self.present(rootOnboardingVC, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
