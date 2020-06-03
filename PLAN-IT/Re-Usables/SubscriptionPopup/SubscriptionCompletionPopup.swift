//
//  SubscriptionCompletionPopup.swift
//  PLAN-IT
//
//  Created by KiwiTech on 13/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
protocol SubscriptionPopUpDelegate: AnyObject {
    func dismissSheet()
}
class SubscriptionCompletionPopup: UIViewController {
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var dataLabel: UILabel!
    weak var delegate: SubscriptionPopUpDelegate?
    var isFromSubscription = false
    var popUpView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descLabel.setLineSpacing(lineSpacing: 7.0, lineHeightMultiple: 0.0, alignment: .left)
        okBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        okBtn.layer.cornerRadius = 8
        okBtn.layer.masksToBounds = true
        setUI()
    }
    func setUI() {
        if isFromSubscription {
            self.descLabel.font = UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 15)
            self.descLabel.text = String(format: .descText, AppStateManager.shared.user?.firstName?.capitalizingFirstLetter() ?? "")
            self.dataLabel.text = .dntForget
            self.dataLabel.textColor = UIColor(name: .headingColor)
            self.okBtn.setTitle(.okOption, for: .normal)
        } else {
            self.descLabel.font = UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 11)
            self.descLabel.text = .yayyText
            self.dataLabel.text = String(format: .expireText, AppUtils.changeDateFormat(date: AppStateManager.shared.user?.subscriptionExpiry ?? ""))
            self.dataLabel.textColor = UIColor(name: .defaultColor)
            self.okBtn.setTitle(.soundsGood, for: .normal)
        }
    }
    @IBAction func okBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        delegate?.dismissSheet()
    }
}
