//
//  SummaryTableView.swift
//  clift_iOS
//
//  Created by David Mar on 5/18/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation
import UIKit

class SummaryTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
       return self.contentSize
     }

     override var contentSize: CGSize {
       didSet {
           self.invalidateIntrinsicContentSize()
       }
     }
    
}
