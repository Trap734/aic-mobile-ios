//
//  MapItemCell.swift
//  aic
//
//  Created by Filippo Vanucci on 12/11/17.
//  Copyright © 2017 Art Institute of Chicago. All rights reserved.
//

import UIKit

/// MapItemCell
///
/// MapItemCell for list of Map icons in Search
class MapItemCell: UICollectionViewCell {
	static let reuseIdentifier = "mapItemCell"

	@IBOutlet var iconImageView: AICImageView!

	static let cellHeight: CGFloat = 48.0

	private var defaultImage: UIImage = UIImage()
	private var highlightImage: UIImage?

	override func awakeFromNib() {
		super.awakeFromNib()

		self.backgroundColor = .aicDarkGrayColor

		self.contentView.backgroundColor = .aicDarkGrayColor

		iconImageView.backgroundColor = .clear
		iconImageView.contentMode = .scaleAspectFill
		iconImageView.clipsToBounds = true
		iconImageView.layer.cornerRadius = 24
		iconImageView.layer.borderColor = UIColor.white.cgColor
		iconImageView.layer.borderWidth = 0

		// Accessibility
		self.isAccessibilityElement = true
		self.accessibilityLabel = "Search on the map"
		self.accessibilityTraits = .button
	}

	func setItemIcon(image: UIImage, highlightImage: UIImage? = nil) {
		iconImageView.image = image
		self.defaultImage = image
		self.highlightImage = highlightImage
	}

	var artworkModel: AICObjectModel? = nil {
		didSet {
			guard let artworkModel = self.artworkModel else {
				return
			}

			iconImageView.kf.indicatorType = .activity
			iconImageView.kf.setImage(with: artworkModel.thumbnailUrl, placeholder: nil, options: nil, progressBlock: nil) { (result) in
				if let result = try? result.get() {
					if let cropRect = artworkModel.thumbnailCropRect {
						self.defaultImage = AppDataManager.sharedInstance.getCroppedImage(image: result.image, viewSize: self.iconImageView.frame.size, cropRect: cropRect)
						self.iconImageView.image = self.defaultImage
					} else {
						self.defaultImage = result.image
					}
					self.highlightImage = self.defaultImage.colorized(UIColor(white: 0.75, alpha: 1))
				}
			}
		}
	}

	override var isHighlighted: Bool {
		didSet {
			if let highlightImage = self.highlightImage {
				if isHighlighted == true {
					iconImageView.image = highlightImage
				} else {
					iconImageView.image = defaultImage
				}
			}
		}
	}
}
