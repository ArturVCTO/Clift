//
//  MyEventsCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 8/29/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class MyEventsCell: UITableViewCell {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    func setup(event: Event) {
        self.eventNameLabel.text = event.name
        switch event.eventType {
        case 0:
            self.eventTypeLabel.text = "Tipo de evento: boda"
        case 1:
            self.eventTypeLabel.text = "Tipo de evento: XV Años"
        case 2:
            self.eventTypeLabel.text = "Tipo de evento: baby shower"
        case 3:
            self.eventTypeLabel.text = "Tipo de evento: cumpleaños"
        case 4:
            self.eventTypeLabel.text = "Tipo de evento: otro"
        default:
            break
        }
    }
}
