//
//  GuestInfoViewController.swift
//  clift_iOS
//
//  Created by Lizzie Guajardo on 30/07/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

class GuestInfoViewController: UIViewController {

    @IBOutlet weak var infoCard: UIView!
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var guestEmailLabel: UILabel!
    @IBOutlet weak var guestPhoneLabel: UILabel!
    @IBOutlet weak var guestPlusOneLabel: UILabel!
    @IBOutlet weak var guestAddressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.infoCard.layer.cornerRadius = 5
        self.showAnimation()
    }
    
    func showAnimation(){
        self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: { self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        }, completion: nil)
    }
    
    func removeAnimation(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
             self.view.alpha = 0.0
        }, completion: {
            (finished : Bool) in
            if (finished){
                self.view.removeFromSuperview()
            }
        })
        
    }
    
    @IBAction func closeGuestInfoWindow(_ sender: Any) {
        self.removeAnimation()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
