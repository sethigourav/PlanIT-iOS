//
//  NumberConstants.swift
//  i-Mar
//
//  Created by KiwiTech on 28/06/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    static let notificationBannerHeight = 106
    static let notificationBannerTag = 100001
    static let noNetworkViewTag = 10000001
    static let fieldTag = 100
    static let lastNameFieldTag = 101
    static let yearBirthFieldTag = 102
    static let emailFieldTag = 103
    static let passwordFieldTag = 104
    static let constantTag = 900
    static let maxYear = 70
    static let minYear = 4
    static let minPassword = 8
    static let transactionTag = -100
    static let transactionMonths = 6
}
extension Float {
    func formatNumber(code: String) -> String {
        let num = abs(Float(self))
        let sign = (self < 0) ? "-" : ""
        switch num {
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            return "\(sign)\(formatted.truncate(code: code))B"
        case 1_000_000...:
            let formatted = num / 1_000_000
            return "\(sign)\(formatted.truncate(code: code))M"
        case 1_000...:
            let formatted = num / 1_000
            return "\(sign)\(formatted.truncate(code: code))K"
        case 0...:
            return "\(AppUtils.getCurrencySymbol(forCurrencyCode: code, amount: self) ?? "")"
        default:
            return "\(sign)\(AppUtils.getCurrencySymbol(forCurrencyCode: code, amount: self) ?? "")"
        }
    }
    func truncate(code: String) -> String {
        let oneDecimalFormatter = NumberFormatter()
        oneDecimalFormatter.numberStyle = .decimal
        oneDecimalFormatter.minimumFractionDigits = 0
        oneDecimalFormatter.maximumFractionDigits = 1
        oneDecimalFormatter.numberStyle = .currency
        let symbol = NSLocale(localeIdentifier: code).displayName(forKey: .currencySymbol, value: code)
        oneDecimalFormatter.currencySymbol = symbol
        return oneDecimalFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
