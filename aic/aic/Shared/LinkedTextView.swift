//
//  LinkedTextView.swift
//  aic
//
//  Created by Filippo Vanucci on 11/8/17.
//  Copyright © 2017 Art Institute of Chicago. All rights reserved.
//

import UIKit

class LinkedTextView : UITextView {
	let linkTapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
	
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		if UIAccessibility.isVoiceOverRunning {
			return
		}
		linkTapGestureRecognizer.cancelsTouchesInView = false
		linkTapGestureRecognizer.delaysTouchesBegan = false
		linkTapGestureRecognizer.delaysTouchesEnded = false
		linkTapGestureRecognizer.addTarget(self, action: #selector(handleLinkTapGestureRecognizer))
		self.addGestureRecognizer(linkTapGestureRecognizer)
	}
	
	@objc func handleLinkTapGestureRecognizer(tapGestureRecognizer: UITapGestureRecognizer) {
		let textView: UITextView = tapGestureRecognizer.view as! UITextView
		let tapLocation = tapGestureRecognizer.location(in: textView)
		
		var textPosition1 = textView.closestPosition(to: tapLocation)
		var textPosition2: UITextPosition? = nil
		if let _ = textPosition1 {
			textPosition2 = textView.position(from: textPosition1!, in: UITextLayoutDirection.right, offset: 1)
			if let _ = textPosition2 {
				textPosition1 = textView.position(from: textPosition1!, in: UITextLayoutDirection.left, offset: 1)
				textPosition2 = textView.position(from: textPosition1!, in: UITextLayoutDirection.right, offset: 1)
			} else  {
				return
			}
		}
		else {
			return
		}
		
		let range = textView.textRange(from: textPosition1!, to: textPosition2!)
		let startOffset = textView.offset(from: textView.beginningOfDocument, to: range!.start)
		let endOffset = textView.offset(from: textView.beginningOfDocument, to: range!.end)
		let offsetRange = NSRange(location: startOffset, length: endOffset - startOffset)
		if offsetRange.location == NSNotFound || offsetRange.length == 0 {
			return
		}
		
		if NSMaxRange(offsetRange) > textView.attributedText.length {
			return
		}
		
		let attributedSubstring = textView.attributedText.attributedSubstring(from: offsetRange)
		var url: URL? = nil
		if let link: String = attributedSubstring.attribute(.link, at: 0, effectiveRange: nil) as? String {
			url = URL(string: link)
		}
		else if let link: URL = attributedSubstring.attribute(.link, at: 0, effectiveRange: nil) as? URL {
			url = link
		}
		
		if let url = url {
			if let delegate = self.delegate {
				if delegate.textView?(self, shouldInteractWith: url, in: offsetRange, interaction: .invokeDefaultAction) == false {
					return
				}
			}
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
}
