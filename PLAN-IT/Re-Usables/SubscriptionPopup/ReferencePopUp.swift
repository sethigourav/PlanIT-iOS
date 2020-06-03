//
//  ReferencePopUp.swift
//  PLAN-IT
//
//  Created by KiwiTech on 16/12/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
protocol ReferencePopUpDelegate: AnyObject {
    func dismissControllerToProceed(name: String?, referenceCode: String?)
}
class ReferencePopUp: UIViewController {
    @IBOutlet weak var referenceView: CustomiseView!
    @IBOutlet weak var nameView: CustomiseView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var referenceField: CustomiseTextField!
    @IBOutlet weak var nameField: CustomiseTextField!
    @IBOutlet weak var submitBtn: UIButton!
    weak var delegate: ReferencePopUpDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        submitBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        submitBtn.layer.cornerRadius = 8
        submitBtn.layer.masksToBounds = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
                   target: self,
                   action: #selector(dismissController))
        self.view.addGestureRecognizer(tap)
    }
    @objc func dismissController() {
          self.dismiss(animated: false, completion: nil)
    }
    @IBAction func submitBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        removeBorderColor()
        if isValid() {
            delegate?.dismissControllerToProceed(name: nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), referenceCode: referenceField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
}
extension ReferencePopUp {
    func setFieldBorderColor(isError: Bool, view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = isError ? UIColor(name: .errorColor).cgColor : UIColor(name: .defaultColor).cgColor
    }
    func removeBorderColor() {
        referenceView.layer.borderWidth = 0
        nameView.layer.borderWidth = 0
    }
}
extension ReferencePopUp {
    func isValid() -> Bool {
        var isValid = false
        var isAnyFieldEmpty = false
        if let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let reference = referenceField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            self.errorView.isHidden = false
            if name.isEmpty && reference.isEmpty {
                alertLabel.text = .mandatoryFields
                setFieldBorderColor(isError: true, view: nameView)
                setFieldBorderColor(isError: true, view: referenceView)
            } else {
                if name.isEmpty {
                    setFieldBorderColor(isError: true, view: nameView)
                    isAnyFieldEmpty = true
                }
                if reference.isEmpty {
                    setFieldBorderColor(isError: true, view: referenceView)
                    isAnyFieldEmpty = true
                }
                if isAnyFieldEmpty {
                    isValid = false
                    errorView.isHidden = false
                    alertLabel.text = .mandatoryFields
                } else {
                    isValid = true
                    errorView.isHidden = true
                }
            }
        }
        return isValid
    }
}
extension ReferencePopUp: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errorView.isHidden = true
        self.alertLabel.text = ""
        if textField.tag == .fieldTag {
            setFieldBorderColor(isError: false, view: nameView)
            referenceView.layer.borderWidth = 0
        } else {
            setFieldBorderColor(isError: false, view: referenceView)
            nameView.layer.borderWidth = 0
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.textInputMode?.primaryLanguage == .emoji || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        guard string != " " else {
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            referenceField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        removeBorderColor()
    }
}
