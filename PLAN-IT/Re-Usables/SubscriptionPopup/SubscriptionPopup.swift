//
//  SubscriptionPopup.swift
//  PLAN-IT
//
//  Created by KiwiTech on 12/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
import Nantes
import StoreKit
protocol DismissDelegate: AnyObject {
    func dismissSheet()
}
class SubscriptionPopup: BaseViewController {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: NantesLabel!
    @IBOutlet weak var scrollview: UIScrollView!
    weak var delegate: DismissDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        getProductInfo()
        scrollview.contentInsetAdjustmentBehavior = .never
        setUpUI()
    }
    func getProductInfo () {
        var price = "$9.99"
        if let productPrice = appDelegate?.product {
            price = productPrice.localizedPrice
        }
        let attributedString = NSMutableAttributedString(string: price + "/month", attributes: [
            .font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 13.0) ?? UIFont.systemFont(ofSize: 13.0),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 20.0) ?? UIFont.systemFont(ofSize: 20.0), range: NSRange(location: 0, length: 5))
        self.subscribeBtn.setAttributedTitle(attributedString, for: .normal)
    }
    func setUpUI() {
        subscribeBtn.layer.borderWidth = 1
        subscribeBtn.layer.borderColor = UIColor.white.cgColor
        subscribeBtn.layer.cornerRadius = 3
        titleLabel.setLineSpacing(lineSpacing: 5.0, lineHeightMultiple: 0.0, alignment: .center)
        descLabel.delegate = self
        let text = String(format: .subscriptionText, appDelegate?.product?.localizedPrice ?? "$9.99")
        self.descLabel.text = text
        self.descLabel.linkAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 11) ?? UIFont.systemFont(ofSize: 11.0),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: UIColor.white
        ]
        self.descLabel.setLineSpacing(lineSpacing: 3.0, lineHeightMultiple: 0.0, alignment: .center)
        self.descLabel.addLink(to: URL(string: .termsLink)!, withRange: (text as NSString).range(of: .term))
        self.descLabel.addLink(to: URL(string: .policyLink)!, withRange: (text as NSString).range(of: .policies))
    }
    @IBAction func subscribeBtnAction(_ sender: Any) {
        if appDelegate?.product == nil {
            return
        }
        showLoader()
        appDelegate?.helper.buyProduct(product: appDelegate?.product ?? SKProduct()) { (success, text) in
            self.hideLoader()
            if success {
                DispatchQueue.main.async {
                    if let controller = AppUtils.viewController(with: SubscriptionCompletionPopup.identifier, in: .tabbar) as? SubscriptionCompletionPopup {
                        controller.delegate = self
                        controller.isFromSubscription = true
                        controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                        controller.modalPresentationStyle = .overFullScreen
                        self.navigationController?.present(controller, animated: false, completion: nil)
                    }
                }
            } else {
                AppUtils.showBanner(with: text)
            }
        }
    }
}
extension SubscriptionPopup: SubscriptionPopUpDelegate {
    func dismissSheet() {
        delegate?.dismissSheet()
    }
}
extension SubscriptionPopup: NantesLabelDelegate {
    func attributedLabel(_ label: NantesLabel, didSelectAddress addressComponents: [NSTextCheckingKey: String]) {
        print("Tapped address: \(addressComponents)")
    }
    func attributedLabel(_ label: NantesLabel, didSelectDate date: Date, timeZone: TimeZone, duration: TimeInterval) {
        print("Tapped Date: \(date), in time zone: \(timeZone), with duration: \(duration)")
    }
    func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
        if let controller = AppUtils.viewController(with: TermsPrivacyViewController.identifier) as? TermsPrivacyViewController {
            if link.absoluteString == .policyLink {
                controller.isFromTerms = false
            } else {
                controller.isFromTerms = true
            }
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    func attributedLabel(_ label: NantesLabel, didSelectPhoneNumber phoneNumber: String) {
        print("Tapped phone number: \(phoneNumber)")
    }
    func attributedLabel(_ label: NantesLabel, didSelectTransitInfo transitInfo: [NSTextCheckingKey: String]) {
        print("Tapped transit info: \(transitInfo)")
    }
}
