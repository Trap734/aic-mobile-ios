/*
 Abstract:
 Prompt to become a member or log in
 */

import UIKit

class InfoBecomeMemberView: BaseView {
	let titleLabel = UILabel()
	let titleDividerLine = UIView()
	let joinPromptLabel = UILabel()
	let joinTextView = LinkedTextView()
	let accessPromptLabel = UILabel()
	let accessButton = AICButton(isSmall: false)
	let bottomDividerLine = UIView()
	
	let titleLabelHeight: CGFloat = 80
    let joinPromptMarginTop: CGFloat = 16
	let joinTextMarginTop: CGFloat = 5
    let accessPromptMarginTop: CGFloat = 28
    let accessButtonMarginTop: CGFloat = 20
	let accessButtonMarginBottom: CGFloat = 20
    
    var savedMember: AICMemberInfoModel? {
        didSet{
            //Configure view appropriately if a member signs in
            if savedMember != nil{
                titleLabel.text = Common.Info.becomeMemberExistingMemberTitle
                
                if joinPromptLabel.superview != nil {
                    joinPromptLabel.removeFromSuperview()
                }
                if joinTextView.superview != nil {
                    joinTextView.removeFromSuperview()
                }
                if accessPromptLabel.superview != nil {
                    accessPromptLabel.removeFromSuperview()
                }
            } else if joinPromptLabel.superview == nil && joinTextView.superview == nil && accessPromptLabel.superview == nil{
                titleLabel.text = "Member Title".localized(using: "Info")
                addSubview(joinPromptLabel)
                addSubview(joinTextView)
                addSubview(accessPromptLabel)
            }
        }
    }
    
    init() {
        super.init(frame:CGRect.zero)
		
		if savedMember == nil {
			//Prompt user to become a member
			titleLabel.text = "Member Title".localized(using: "Info")
		}else{
			//Welcome back existing members
			titleLabel.text = Common.Info.becomeMemberExistingMemberTitle
		}
		titleLabel.font = .aicTitleFont
		titleLabel.textColor = .aicDarkGrayColor
        titleLabel.textAlignment = NSTextAlignment.center
		
		titleDividerLine.backgroundColor = .aicDividerLineColor
		
        joinPromptLabel.numberOfLines = 0
        joinPromptLabel.text = "Member Join Prompt".localized(using: "Info")
        joinPromptLabel.font = .aicPageTextFont
		joinPromptLabel.textColor = .aicDarkGrayColor
        joinPromptLabel.textAlignment = .center
		
		let joinAttrText = NSMutableAttributedString(string: "Member Join Text".localized(using: "Info"))
		let joinURL = URL(string: AppDataManager.sharedInstance.app.dataSettings[.membershipUrl]!)!
		joinAttrText.addAttributes([.link : joinURL], range: NSRange(location: 0, length: joinAttrText.string.count))
		
		joinTextView.setDefaultsForAICAttributedTextView()
		joinTextView.attributedText = joinAttrText
		joinTextView.linkTextAttributes = [.foregroundColor : UIColor.aicInfoColor]
		joinTextView.textAlignment = NSTextAlignment.center
		joinTextView.font = .aicPageTextFont
		joinTextView.delegate = self
		
		accessPromptLabel.text = "Member Access Prompt".localized(using: "Info")
		accessPromptLabel.font = .aicPageTextFont
		accessPromptLabel.textColor = .aicDarkGrayColor
		accessPromptLabel.textAlignment = NSTextAlignment.center
		
		accessButton.setColorMode(colorMode: AICButton.orangeMode)
		accessButton.setTitle("Member Access Button".localized(using: "Info"), for: .normal)
		
		bottomDividerLine.backgroundColor = .aicDividerLineColor
		
		// Add Subviews
		addSubview(titleLabel)
		addSubview(titleDividerLine)
        
        //Only show join prompts if no member has been saved
		if savedMember == nil {
			addSubview(joinPromptLabel)
			addSubview(joinTextView)
			addSubview(accessPromptLabel)
		}
		
		addSubview(accessButton)
		addSubview(bottomDividerLine)
		
		// Set Delegates
		joinTextView.delegate = self
		
		// Accessibility
		joinTextView.accessibilityTraits = .link
    }
	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func updateConstraints() {
		if didSetupConstraints == false {
			titleLabel.autoSetDimension(.height, toSize: 80)
			titleLabel.autoPinEdge(.top, to: .top, of: self)
			titleLabel.autoPinEdge(.leading, to: .leading, of: self)
			titleLabel.autoPinEdge(.trailing, to: .trailing, of: self)
			
			titleDividerLine.autoPinEdge(.top, to: .bottom, of: titleLabel)
			titleDividerLine.autoSetDimension(.height, toSize: 1)
			titleDividerLine.autoPinEdge(.leading, to: .leading, of: self, withOffset: 16)
			titleDividerLine.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -16)
			
			joinPromptLabel.autoPinEdge(.top, to: .bottom, of: titleDividerLine, withOffset: joinPromptMarginTop)
			joinPromptLabel.autoPinEdge(.leading, to: .leading, of: self)
			joinPromptLabel.autoPinEdge(.trailing, to: .trailing, of: self)
			
			joinTextView.autoPinEdge(.top, to: .bottom, of: joinPromptLabel, withOffset: joinTextMarginTop)
			joinTextView.autoPinEdge(.leading, to: .leading, of: self)
			joinTextView.autoPinEdge(.trailing, to: .trailing, of: self)
			
			accessPromptLabel.autoPinEdge(.top, to: .bottom, of: joinTextView, withOffset: accessPromptMarginTop)
			accessPromptLabel.autoPinEdge(.leading, to: .leading, of: self)
			accessPromptLabel.autoPinEdge(.trailing, to: .trailing, of: self)
			
			accessButton.autoAlignAxis(.vertical, toSameAxisOf: self)
			accessButton.autoPinEdge(.top, to: .bottom, of: accessPromptLabel, withOffset: accessButtonMarginTop)
			
			bottomDividerLine.autoPinEdge(.top, to: .bottom, of: accessButton, withOffset: accessButtonMarginBottom)
			bottomDividerLine.autoSetDimension(.height, toSize: 1)
			bottomDividerLine.autoPinEdge(.leading, to: .leading, of: self, withOffset: 16)
			bottomDividerLine.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -16)
			
			self.autoPinEdge(.bottom, to: .bottom, of: bottomDividerLine)
			
			didSetupConstraints = true
		}
		
		super.updateConstraints()
	}
}


// Observe links for passing analytics
extension InfoBecomeMemberView  : UITextViewDelegate {
	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		// Log Analytics
		AICAnalytics.sendMiscLinkTappedEvent(link: AICAnalytics.MiscLink.MemberJoin)
		
		return true
	}
}
