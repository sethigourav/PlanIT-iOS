//
//  AllTransactionsHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 02/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
extension AllTransactionsViewController {
    func initPicker() {
        picker.backgroundColor = .white
        picker.contentMode = .center
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -6
        let minDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        picker.minimumDate = minDate
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        picker.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - self.picker.bounds.size.height, width: UIScreen.main.bounds.size.width, height: self.picker.bounds.size.height)
    }
    func createToolbar() {
        toolbar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: (UIScreen.main.bounds.size.height - self.picker.bounds.size.height) - 30, width: UIScreen.main.bounds.size.width, height: 60))
        toolbar.sizeToFit()
        toolbar.tintColor = .black
        toolbar.backgroundColor = .white
        let doneButton = UIBarButtonItem(title: .done, style: .plain, target: self, action: #selector(startDonePicker))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 12) ?? UIFont.systemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: UIColor(name: .doneColor)], for: .normal)
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 12) ?? UIFont.systemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: UIColor(name: .doneColor)], for: .selected)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let navTitle = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: toolbar.frame.size.height))
        navTitle.text = .select
        navTitle.font = UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 19)
        navTitle.textColor = UIColor(name: .headingColor)
        let titleItem = UIBarButtonItem.init(customView: navTitle)
        toolbar.setItems([spaceButton, titleItem, spaceButton, doneButton], animated: false)
    }
    @objc func startDonePicker() {
        self.isFromDatePicker = false
        var fromDate = AppUtils.fetchDate(fromStr: self.fromDate ?? "")
        var toDate = AppUtils.fetchDate(fromStr: self.toDate ?? "")
        if fromDate > toDate {
            fromDate = AppUtils.fetchDate(fromStr: self.startDate ?? "")
            toDate =  AppUtils.fetchDate(fromStr: self.endDate ?? "")
            AppUtils.showBanner(with: .startEndError)
        } else {
            if picker.tag == .transactionTag {
                self.startDate = self.fromDate
                fromTransactionLabel.text = self.startDate
            } else {
                self.endDate = self.toDate
                toTransactionLabel.text = self.endDate
            }
            self.isFromDatePicker = true
            swipeMenu.reloadData()
            swipeMenu.reloadInputViews()
        }
        self.toolbar.removeFromSuperview()
        self.picker.removeFromSuperview()
    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = AppUtils.fetchDateStr(fromDate: sender.date)
        if sender.tag == .transactionTag {
            fromDate = selectedDate
        } else {
            toDate = selectedDate
        }
    }
}
