//
//  OnboardingEventType.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/15/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import UIKit

class OnboardingEventTypeViewController: UIViewController {
    
    @IBOutlet weak var weddingEventTypeButton: customButton!
    @IBOutlet weak var babyShowerEventTypeButton: customButton!
    @IBOutlet weak var birthdayEventTypeButton: customButton!
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
            weddingEventTypeButton.setTitleColor(UIColor(displayP3Red: 0/255, green: 149/255, blue: 255/255, alpha: 1.0), for: .normal)
        } else {
            weddingEventTypeButton.isSelected = true
            self.eventType = 0
            
            babyShowerEventTypeButton.isSelected = false
            birthdayEventTypeButton.isSelected = false
            babyShowerEventTypeButton.backgroundColor = UIColor(named: "transparent")
            birthdayEventTypeButton.backgroundColor = UIColor(named: "transparent")
            weddingEventTypeButton.backgroundColor = UIColor(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0)
            birthdayEventTypeButton.setTitleColor(UIColor(displayP3Red: 0/255, green: 149/255, blue: 255/255, alpha: 1.0), for: .normal)
            babyShowerEventTypeButton.setTitleColor(UIColor(displayP3Red: 0/255, green: 149/255, blue: 255/255, alpha: 1.0), for: .normal)
            weddingEventTypeButton.setTitleColor(.white, for: .normal)
        }
        self.typeSelectedValidator()
    }
    
    func typeSelectedValidator() {
        if weddingEventTypeButton.isSelected == true || babyShowerEventTypeButton.isSelected == true || birthdayEventTypeButton.isSelected == true {
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
             babyShowerEventTypeButton.setTitleColor(UIColor(displayP3Red: 0/255, green: 149/255, blue: 255/255, alpha: 1.0), for: .normal)
        } else {
            babyShowerEventTypeButton.isSelected = true
            self.eventType = 2
            weddingEventTypeButton.isSelected = false
            birthdayEventTypeButton.isSelected = false
            weddingEventTypeButton.backgroundColor = UIColor(named: "transparent")
            birthdayEventTypeButton.backgroundColor = UIColor(named: "transparent")
            weddingEventTypeButton.setTitleColor(UIColor(displayP3Red: 0/255, green: 149/255, blue: 255/255, alpha: 1.0), for: .normal)
            birthdayEventTypeButton.setTitleColor(UIColor(displayP3Red: 0/255, green: 149/255, blue: 255/255, alpha: 1.0), for: .normal)
            babyShowerEventTypeButton.backgroundColor = UIColor(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0)
            babyShowerEventTypeButton.setTitleColor(.white, for: .normal)
        }
        self.typeSelectedValidator()
    }
    
    @IBAction func birthdayButtonTapped(_ sender: Any) {
        if birthdayEventTypeButton.isSelected == true {
            birthdayEventTypeButton.isSelected = false
            birthdayEventTypeButton.backgroundColor = UIColor(named: "transparent")
            birthdayEventTypeButton.setTitleColor(UIColor(displayP3Red: 0/255, green: 149/255, blue: 255/255, alpha: 1.0), for: .normal)
        } else {
            birthdayEventTypeButton.isSelected = true
            self.eventType = 3
            weddingEventTypeButton.isSelected = false
            babyShowerEventTypeButton.isSelected = false
            weddingEventTypeButton.backgroundColor = UIColor(named: "transparent")
            babyShowerEventTypeButton.backgroundColor = UIColor(named: "transparent")
            weddingEventTypeButton.setTitleColor(UIColor(displayP3Red: 0/255, green: 149/255, blue: 255/255, alpha: 1.0), for: .normal)
            babyShowerEventTypeButton.setTitleColor(UIColor(displayP3Red: 0/255, green: 149/255, blue: 255/255, alpha: 1.0), for: .normal)
            birthdayEventTypeButton.backgroundColor = UIColor(displayP3Red: 177/255, green: 211/255, blue: 246/255, alpha: 1.0)
            birthdayEventTypeButton.setTitleColor(.white, for: .normal)
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
