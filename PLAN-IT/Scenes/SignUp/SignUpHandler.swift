//
//  SignUpHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 16/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
import Nantes

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func fetchYearsToDisplay() {
        let yearComponents = Calendar.current.dateComponents([.year], from: Date())
        if let currentYear = yearComponents.year {
            for currentdata in (currentYear - .maxYear)..<(currentYear - .minYear) {
                pickerData.append(String(currentdata))
            }
        }
        if pickerData.count > 0 {
            pickerData.reverse()
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentValueInt = row
        pickerView.reloadAllComponents()
        yearBirthField.text =  pickerData[row]
        for (index, value) in pickerData.enumerated() where value == yearBirthField.text {
            picker.selectRow(index, inComponent: component, animated: true)
            break
        }
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100.0
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let picker = view != nil ? view: UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: pickerView.frame.width, height: 45))  else {
            return UIView()
        }
        var lbl: UILabel? = picker.viewWithTag(10) as? UILabel
        if lbl == nil {
            lbl = UILabel.init(frame: CGRect.init(x: 0.0, y: 0.0, width: pickerView.frame.width, height: 45))
        }
        if pickerView.view(forRow: row, forComponent: 0) != nil {
            lbl?.textColor = .gray
            lbl?.font = UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 16) ?? UIFont.systemFont(ofSize: 16.0)
        } else {
            lbl?.textColor = UIColor(name: .defaultColor)
            lbl?.font = UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 18) ?? UIFont.systemFont(ofSize: 18.0)
        }
        lbl?.tag = 10
        lbl?.text = pickerData[row]
        lbl?.textAlignment = .center
        lbl?.backgroundColor = .clear
        if let labell = lbl {
            picker.addSubview(labell)
        }
        return picker
    }
}
extension SignUpViewController: NantesLabelDelegate {
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
extension SignUpViewController {
    func isValid () -> Bool {
        var isValid = false
        var isAnyFieldEmpty = false
        var isInvalidFormat = false
        var isPasswordInvalid = false
        self.errorView.isHidden = false
        if userObj.email?.isEmpty ?? true && userObj.password?.isEmpty ?? true && userObj.firstName?.isEmpty ?? true && userObj.lastName?.isEmpty ?? true && userObj.dob?.isEmpty ?? true {
            errorLabel.text = .mandatoryFields
            for fields in SignUpFields.allCases {
                if let view = self.view.viewWithTag(fields.rawValue) {
                    setFieldBorderColor(isError: true, view: view)
                }
            }
        } else {
            if userObj.firstName?.isEmpty ?? true {
                setFieldBorderColor(isError: true, view: firstNameView)
                isAnyFieldEmpty = true
            }
            if userObj.lastName?.isEmpty ?? true {
                setFieldBorderColor(isError: true, view: lastNameView)
                isAnyFieldEmpty = true
            }
            if userObj.dob?.isEmpty ?? true {
                setFieldBorderColor(isError: true, view: yearBirthView)
                isAnyFieldEmpty = true
            }
            if userObj.email?.isEmpty ?? true {
                setFieldBorderColor(isError: true, view: emailView)
                isAnyFieldEmpty = true
            }
            if userObj.password?.isEmpty ?? true {
                setFieldBorderColor(isError: true, view: passwordView)
                isAnyFieldEmpty = true
            }
            if (userObj.email?.count ?? 0) > 0 && !ValidationUtils.validateEmail(emailID: userObj.email ?? "") {
                setFieldBorderColor(isError: true, view: emailView)
                isInvalidFormat = true
            }
            if (userObj.password?.count ?? 0) < .minPassword {
                setFieldBorderColor(isError: true, view: passwordView)
                isPasswordInvalid = true
            }
            if isAnyFieldEmpty || isInvalidFormat || isPasswordInvalid {
                errorView.isHidden = false
                errorLabel.text =  isAnyFieldEmpty ? .mandatoryFields : ( isInvalidFormat ? .invalidFormat : .passwordInvalid )
            } else {
                isValid = true
                errorView.isHidden = true
            }
        }
        return isValid
    }
}
extension SignUpViewController {
    func setFieldBorderColor(isError: Bool, view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = isError ? UIColor(name: .errorColor).cgColor : UIColor(name: .defaultColor).cgColor
    }
    func removeBorderColor() {
        for fields in SignUpFields.allCases {
            if let view = self.view.viewWithTag(fields.rawValue) {
                view.layer.borderWidth = 0
            }
        }
    }
}
