//
//  EventGiftListViewController.swift
//  clift_iOS
//
//  Created by Juan Pablo Ramos on 29/11/20.
//  Copyright © 2020 Clift. All rights reserved.
//

import UIKit

class EventGiftListViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.delegate = self
			tableView.dataSource = self
			tableView.separatorStyle = .none
		}
	}
	
	var currentEvent = Event()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.tintColor = .black
	}
}

// MARK: Table View Delegate and Data Source
extension EventGiftListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventHeaderCell") as? EventHeaderCell else {
				return UITableViewCell()
			}
			
			cell.setup(event: currentEvent)
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 215
		}
		return 0
	}
	
}
