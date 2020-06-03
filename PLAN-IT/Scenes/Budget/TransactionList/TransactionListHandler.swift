//
//  TransactionListHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 03/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
extension TransactionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleStr == .portfolio ? self.portfoliotransactionArray.count : self.transactionArray.count
    }
}
extension TransactionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllTransactionCell.identifier, for: indexPath) as? AllTransactionCell
        titleStr == .portfolio ? cell?.updatePortfolioUI(data: portfoliotransactionArray[indexPath.row]) : cell?.updateUI(data: transactionArray[indexPath.row])
        cell?.separatorLabel.isHidden = transactionArray.count == (indexPath.row + 1) ? true : false
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}
