//
//  PriceRangeTableViewCell.swift
//  clift_iOS
//
//  Created by Juan Carlos Garza on 9/10/19.
//  Copyright © 2019 Clift. All rights reserved.
//

import Foundation
import UIKit

class PriceRangeTableViewCell: UITableViewCell {
    
    let rangeSlider = RangeSlider(frame: .zero)
    @IBOutlet weak var priceRangeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let margin: CGFloat = 20
        let width = self.bounds.width - 2 * margin
        let height: CGFloat = 30
        
        rangeSlider.frame = CGRect(x: 0,y: 0, width: width, height: height)
        rangeSlider.center = self.center
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)),
                              for: .valueChanged)
        let lowerValue = String(format:"$%.2f",rangeSlider.lowerValue * 10000)
        
        let upperValue = String(format: "$%.2f", rangeSlider.upperValue * 10000)
        self.priceRangeLabel.text = "\(lowerValue) - \(upperValue)"
    }
    
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        let lowerValue = String(format:"$%.2f",rangeSlider.lowerValue * 10000)
        
        let upperValue = String(format: "$%.2f", rangeSlider.upperValue * 10000)
        self.priceRangeLabel.text = "\(lowerValue) - \(upperValue)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(rangeSlider)
    }
}
