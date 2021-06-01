//
//  DatePickerView.swift
//  clift_iOS
//
//  Created by Lydia Marion Gonzalez on 26/05/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate {
    func returnSelectedDate(date: Date)
}

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var delegate: DatePickerViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        setDatePicker()
    }
    
    func setDatePicker() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.minimumDate = Date()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        delegate.returnSelectedDate(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 0)
                }
            }
        }
    }
}
