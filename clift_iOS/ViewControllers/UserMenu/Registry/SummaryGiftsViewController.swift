//
//  SummaryGiftsViewController.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 1/24/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import Foundation
import UIKit

struct MockGift{
    let category: String
    let giftersEmail: [String]
    let image: UIImage
    let dateGifted: String
    let giftName: String
    let giftPrice: Int
    let isThanked: Bool
}

class SummaryGiftsViewController: UIViewController {
    @IBOutlet weak var thankedGiftsSegment: UISegmentedControl!
    @IBOutlet weak var barView1: UIView!
    @IBOutlet weak var barView2: UIView!
    @IBOutlet weak var giftsTableView: UITableView!
    
//  Mock purposes only
    var mockGifts: [MockGift] = [
        MockGift(category: "Cocina", giftersEmail: ["j.garza@email.com"], image: UIImage(named: "15")!, dateGifted: "26 Junio de 2019",giftName: "1.5 Qt Fruit Scoop Máquina de postres congelados.",giftPrice: 2500,isThanked: true),
        MockGift(category: "Cocina", giftersEmail: ["k.garza@email.com","o.garza@email.com","p.garza@email.com"], image: UIImage(named: "15")!, dateGifted: "26 Junio de 2019",giftName: "1.5 Qt Fruit Scoop Máquina de postres congelados.", giftPrice: 2500,isThanked: true),
        MockGift(category: "Cocina", giftersEmail: ["l.garza@email.com"], image: UIImage(named: "15")!, dateGifted: "26 Junio de 2019", giftName: "1.5 Qt Fruit Scoop Máquina de postres congelados.", giftPrice: 2500,isThanked: false),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.giftsTableView.delegate = self
        self.giftsTableView.dataSource = self
    }
    
    
    @IBAction func thankedSegment(_ sender: Any) {
    }
}
extension SummaryGiftsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockGifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = giftsTableView.dequeueReusableCell(withIdentifier: "giftSummaryCell", for: indexPath) as! GiftSummaryCell
        cell.configure(with: mockGifts[indexPath.row])
        return cell
    }
}
