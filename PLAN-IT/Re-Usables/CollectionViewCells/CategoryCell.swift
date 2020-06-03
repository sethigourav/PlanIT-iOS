//
//  CategoryCell.swift
//  PLAN-IT
//
//  Created by KiwiTech on 11/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var setBudgetView: UIView!
    @IBOutlet weak var budgetView: UIView!
    @IBOutlet weak var budgetPercentLabel: UILabel!
    @IBOutlet weak var progressLabel: UIProgressView!
    @IBOutlet weak var errorImgView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryDescLabel: UILabel!
    @IBOutlet weak var overspentView: UIView!
    @IBOutlet weak var borderView: CustomiseView!
    @IBOutlet weak var shadowView: CustomiseView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var setBudgetLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var setBudgetBtn: UIButton!
    @IBOutlet weak var setBudgetLabel: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderWidth = 1.6
        borderView.layer.borderColor = UIColor(name: .defaultColor).cgColor
        progressLabel.transform = progressLabel.transform.scaledBy(x: 1, y: 1.5)
        progressLabel.layer.cornerRadius = progressLabel.frame.size.height / 2
        progressLabel.clipsToBounds = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.progressLabel.setProgress(0, animated: false)
        borderView.layer.borderColor = UIColor(name: .defaultColor).cgColor
        self.progressLabel.progressTintColor = UIColor(name: .defaultColor)
        self.budgetPercentLabel.textColor = UIColor(name: .defaultColor)
        errorImgView.isHidden = true
        self.budgetPercentLabel.isHidden = false
        leadingConstraint.constant = 0
        self.categoryDescLabel.isHidden = false
        self.categoryDescLabel.text = ""
    }
    func updateUI(data: BudgetCategory, index: Int) {
        self.categoryNameLabel.text = data.categoryName
        let budgetLeft = (data.setBudget ?? 0) - (data.spend ?? 0)
        let progress =  (data.spend ?? 0) / (data.setBudget ?? 0)
        self.progressLabel.setProgress(progress, animated: false)
        self.budgetPercentLabel.text = progress > 1 ? "OVERSPENT" : progress >= 0.0 ? String(format: "%.2f%% SPENT", progress * 100) : ""
        overspentView.isHidden = true
        if (data.setBudget ?? 0) == 0 {
            if (data.nextMonthSetBudget ?? 0.0) > 0.0 {
                setBudgetBtn.isHidden = true
                var dateComponents = DateComponents()
                dateComponents.month = +1
                let minDate = Calendar.current.date(byAdding: dateComponents, to: AppUtils.fetchBudgetDate(fromStr: data.serverDate ?? "")) ?? Date()
                let nextMonth = AppUtils.nexttMonth(date: minDate)
                let title = NSAttributedString(string: String(format: "Budget set for %@", nextMonth), attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor(name: .defaultColor),
                    NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 11) ?? UIFont.systemFont(ofSize: 11.0),
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: UIColor(name: .defaultColor)
                    ])
                setBudgetLabel.setAttributedTitle(title, for: .normal)
                setBudgetLeadingConstraint.constant = 0
            } else {
                let title = NSAttributedString(string: "Set Budget", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor(name: .defaultColor),
                    NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 11) ?? UIFont.systemFont(ofSize: 11.0),
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: UIColor(name: .defaultColor)
                    ])
                setBudgetBtn.isHidden = false
                setBudgetLabel.setAttributedTitle(title, for: .normal)
                setBudgetLeadingConstraint.constant = 31
            }
            setBudgetView.isHidden = false
            budgetView.isHidden = true
            self.categoryDescLabel.text = String(format: .setBudgetText, data.categoryName ?? "")
            shadowView.backgroundColor = UIColor(name: .categoryDefaultColor)
        } else {
            if (progress * 100) > 100 {//overspent
                errorImgView.isHidden = false
                setBudgetView.isHidden = true
                budgetView.isHidden = false
                overspentView.isHidden = false
                self.budgetPercentLabel.isHidden = false
                self.categoryDescLabel.isHidden = true
                borderView.layer.borderColor = UIColor(name: .errorColor).cgColor
                shadowView.backgroundColor = UIColor(name: .categoryOverspentColor)
                self.progressLabel.progressTintColor = UIColor(name: .errorColor)
                self.budgetPercentLabel.textColor = UIColor(name: .errorColor)
                leadingConstraint.constant = 18
            } else if (progress * 100) >= 85 {//red progress
                setBudgetView.isHidden = true
                budgetView.isHidden = false
                self.categoryDescLabel.text = String(format: .budgetText, AppUtils.getCurrencySymbol(forCurrencyCode: data.isoCurrencyCode ?? "", amount: budgetLeft) ?? "$")
                self.progressLabel.progressTintColor = UIColor(name: .errorColor)
                self.budgetPercentLabel.textColor = UIColor(name: .errorColor)
                borderView.layer.borderColor = UIColor(name: .errorColor).cgColor
                shadowView.backgroundColor = UIColor(name: .categoryOverspentColor)
            } else {//green progress
                setBudgetView.isHidden = true
                budgetView.isHidden = false
                self.categoryDescLabel.text = String(format: .budgetText, AppUtils.getCurrencySymbol(forCurrencyCode: data.isoCurrencyCode ?? "", amount: budgetLeft) ?? "$")
                self.progressLabel.progressTintColor = UIColor(name: .defaultColor)
                self.budgetPercentLabel.textColor = UIColor(name: .defaultColor)
                shadowView.backgroundColor = UIColor(name: .categoryDefaultColor)
            }
        }
    }
}
