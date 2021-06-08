//
//  RootViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/22/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Realm
import AVFoundation
import AVKit


class RootViewController: UIViewController {

    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        let users = realm.objects(Session.self)
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
        loadVideo()

        let seconds = 4.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            if(users.isEmpty || users.first!.accountType == "Guest") {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.showCreateSessionFlow()
            }
            else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.userHasSuccesfullySignedIn()
            }
        }
        
    }
    
    private func loadVideo() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }

        let path = Bundle.main.path(forResource: "SplashScreenMobile", ofType:"mp4")

        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1

        self.view.layer.addSublayer(playerLayer)

        player.seek(to: CMTime.zero)
        player.play()
    }
}
 
