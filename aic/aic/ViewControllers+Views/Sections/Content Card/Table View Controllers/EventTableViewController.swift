//
//  EventTableViewController.swift
//  aic
//
//  Created by Filippo Vanucci on 1/15/18.
//  Copyright © 2018 Art Institute of Chicago. All rights reserved.
//

import UIKit
import Localize_Swift

class EventTableViewController : UITableViewController {
	let eventModel: AICEventModel
	
	init(event: AICEventModel) {
		eventModel = event
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = .clear
		
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		
		self.tableView.backgroundColor = .aicDarkGrayColor
		self.tableView.separatorStyle = .none
		self.tableView.rowHeight = UITableView.automaticDimension // Necessary for AutoLayout of cells
		self.tableView.estimatedRowHeight = 200
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
		self.tableView.register(UINib(nibName: "EventContentCell", bundle: Bundle.main), forCellReuseIdentifier: EventContentCell.reuseIdentifier)
		self.tableView.register(CardTitleView.self, forHeaderFooterViewReuseIdentifier: CardTitleView.reuseIdentifier)
		
		// Language
		NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
	}
	
	@objc private func updateLanguage() {
		self.tableView.reloadData()
	}
	
	// MARK: Button Events
	
	@objc func buyTicketsButtonPressed(button: UIButton) {
		// Log analytics
		AICAnalytics.sendEventRegisterLinkEvent(event: eventModel)
		
		UIApplication.shared.open(eventModel.eventUrl!, options: [:], completionHandler: nil)
	}
}

// MARK: Data Source
extension EventTableViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// tour intro + first stop (overview) + list of stops
		return 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: EventContentCell.reuseIdentifier, for: indexPath) as! EventContentCell
			cell.eventModel = eventModel
			cell.buyTicketsButton.addTarget(self, action: #selector(buyTicketsButtonPressed(button:)), for: .touchUpInside)
			return cell
		}
		return UITableViewCell()
	}
}

// MARK: Layout
extension EventTableViewController {
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let titleView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CardTitleView.reuseIdentifier) as! CardTitleView
		titleView.titleLabel.text = eventModel.title
		return titleView
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 80
	}
}

// MARK: Scroll Delegate
extension EventTableViewController {
    /// Avoid bouncing at the top of the TableView
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		scrollView.bounces = (scrollView.contentOffset.y > 20)
    }
}

// MARK: Interaction
extension EventTableViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}
