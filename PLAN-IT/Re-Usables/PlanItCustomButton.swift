//
//  PlanItCustomButton.swift
//  SAFE
//
//  Created by KiwiTech on 28/03/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit

enum CustomButtonType {
    case primaryButton
    case secondaryButton
    case tertiaryButton
    case quarterButton
}

@IBDesignable
class PlanItCustomButton: UIButton {
    let kPrimary 			= "primary"
    let kSecondary 			= "secondary"
    let KTertiary           = "tertiary"
    let kquarter             = "quarter"
    private var customButtonType: CustomButtonType = CustomButtonType.primaryButton
    // set primary in setbuttonStyle if you need filled background property
    @IBInspectable var setButtonType: String? {
		didSet {
			guard let buttonType = setButtonType, buttonType.count > 0 else { return }
			checkForButtonType(buttonType: buttonType)
		}
    }
    func buttonWithStyle(buttonType: CustomButtonType) {
        self.customButtonType = buttonType
        applyStyle()
    }
	func checkForButtonType(buttonType: String) {
		if caseInsensitiveCompare(buttonType, compareString: kPrimary) {
			customButtonType = .primaryButton
        } else if caseInsensitiveCompare(buttonType, compareString: kSecondary) {
			customButtonType = .secondaryButton
        } else if caseInsensitiveCompare(buttonType, compareString: KTertiary) {
            customButtonType = .tertiaryButton
        } else if caseInsensitiveCompare(buttonType, compareString: kquarter) {
            customButtonType = .quarterButton
        }
	}
	func caseInsensitiveCompare(_ buttonType: String, compareString: String) -> Bool {
		return	(buttonType.caseInsensitiveCompare(compareString) ==
			ComparisonResult.orderedSame)
	}
    override func awakeFromNib() {
        super.awakeFromNib()
		applyStyle()
    }
	func applyStyle() {
        switch customButtonType {
        case .primaryButton:
           updatePrimaryButtonStyle()
        case .secondaryButton:
            updateSecondaryButtonStyle()
        case .tertiaryButton:
            updatetertiaryButtonStyle()
        case .quarterButton:
            updateQuarterButtonStyle()
        }
	}
    func updatePrimaryButtonStyle() {
        self.layer.borderColor = UIColor.init(name: .defaultColor).cgColor
        self.backgroundColor = UIColor.init(name: .defaultColor)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 17)
    }
    func updateSecondaryButtonStyle() {
    }
    func updatetertiaryButtonStyle() {
    }
    func updateQuarterButtonStyle() {
    }
}
