//
//  AppUtillsExtended.swift
//  PLAN-IT
//
//  Created by KiwiTech on 26/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
public extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
            self.layer.mask = maskLayer
        }
    }
}
extension UIButton {
    func makeUnderLineText(
        font: UIFont?,
        colorName: UIColor.ColorName,
        text: String) {
        if let unwrapeFont = font {
            let underLineAttributes: [NSAttributedString.Key: Any] = [
                .font: unwrapeFont,
                .foregroundColor: UIColor(name: colorName),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            let attribute = NSAttributedString(string: text, attributes: underLineAttributes)
            self.setAttributedTitle(attribute, for: .normal)
        }
    }
}
public extension UIViewController {
    func showAsPopUp(controller: UIViewController) {
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(controller, animated: false, completion: nil)
    }
}
extension UIView {
    func setFieldBorderColor(isError: Bool) {
        self.layer.borderWidth = 1
        self.layer.borderColor = isError ? UIColor(name: .errorColor).cgColor : UIColor(name: .defaultColor).cgColor
    }
    func removeBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    var isYoutubeURL: Bool {
        let regexStr = "^(https?\\:\\/\\/)?(www\\.)?(youtube\\.com|youtu\\.?be|YouTube\\.com)\\/.+$"
        guard let regex = try? NSRegularExpression(
            pattern: regexStr,
            options: NSRegularExpression.Options.caseInsensitive) else { return false }
        return !(regex.matches(
            in: self,
            options: NSRegularExpression.MatchingOptions(rawValue: 0),
            range: NSRange(location: 0, length: self.count)).isEmpty)
    }
    var isVimeoURL: Bool {
        let regex = "(http|https)?:\\/\\/(www\\.)?vimeo.com\\/(?:channels\\/(?:\\w+\\/)?|groups\\/([^\\/]*)\\/videos\\/|)(\\d+)(?:|\\/\\?)"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
extension UILabel {
    func setLineSpacing(
        lineSpacing: CGFloat = 0.0,
        lineHeightMultiple: CGFloat = 0.0,
        alignment: NSTextAlignment,
        minimumLineHeight: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        if minimumLineHeight > 0 {
            paragraphStyle.minimumLineHeight = minimumLineHeight
        }
        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}
extension URL {
    var isYoutubeURL: Bool {
        let regexStr = "^(https?\\:\\/\\/)?(www\\.)?(youtube\\.com|youtu\\.?be|YouTube\\.com)\\/.+$"
        guard let regex = try? NSRegularExpression(
            pattern: regexStr,
            options: NSRegularExpression.Options.caseInsensitive) else { return false }
        return !(regex.matches(
            in: absoluteString,
            options: NSRegularExpression.MatchingOptions(rawValue: 0),
            range: NSRange(location: 0, length: absoluteString.count)).isEmpty)
    }
}
