//
//  AllTransactionCell.swift
//  PLAN-IT
//
//  Created by KiwiTech on 02/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
class AllTransactionCell: UITableViewCell {

    @IBOutlet weak var transactionStatus: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    @IBOutlet weak var transactionTitle: UILabel!
    @IBOutlet weak var transactionAmount: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    var title: String!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        transactionTitle.text = ""
        transactionDate.text = ""
        transactionAmount.text = ""
        transactionStatus.text = ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func updateUI(data: Transaction) {
        transactionTitle.text = data.name
        transactionDate.text = AppUtils.transDateConversion(strDate: data.date ?? "")
        transactionAmount.text = data.amount?.formatNumber(code: data.isoCurrencyCode ?? "")
        transactionStatus.text = (data.pending ?? true) ? .pending : .cleared
    }
    func updatePortfolioUI(data: PortfolioTransaction) {
        transactionTitle.text = data.name
        let attributedString = NSMutableAttributedString(string: "Basis Price \(data.costBasis?.formatNumber(code: data.isoCurrencyCode ?? "") ?? ""),", attributes: [
            NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 11) ?? UIFont.systemFont(ofSize: 11.0)
            ])
        let attributedStringTwo = NSMutableAttributedString(string: String(format: " Qty %.2f", data.quantity ?? 0.0), attributes: [
            NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 11) ?? UIFont.systemFont(ofSize: 11.0)
            ])
        let boldFontAttribute = [
            NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 11) ?? UIFont.systemFont(ofSize: 11.0)
        ]
        attributedString.addAttributes(boldFontAttribute, range: NSRange(location: 12, length: ("\(data.costBasis?.formatNumber(code: data.isoCurrencyCode ?? "") ?? "")").count))
        attributedStringTwo.addAttributes(boldFontAttribute, range: NSRange(location: 5, length: String(format: "%.2f", data.quantity ?? 0.0).count))
        let combination = NSMutableAttributedString()
        combination.append(attributedString)
        combination.append(attributedStringTwo)
        transactionDate.attributedText = combination
        transactionAmount.text = data.institutionValue?.formatNumber(code: data.isoCurrencyCode ?? "") ?? ""
        if let costBasis = data.costBasis, let insPrice = data.institutionPrice {
            let diffAmount = insPrice - costBasis
            let amountPercent = diffAmount / 100
            transactionStatus.textColor = diffAmount >= 0 ? UIColor(name: .successColor) : UIColor(name: .negitiveValueColor)
            transactionStatus.text = String(format: "%.2f%%   %.2f", abs(amountPercent), abs(diffAmount))
        }
    }
}
