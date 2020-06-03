//
//  ChangePasswordViewController.swift
//  PLAN-IT
//
//  Created by KiwiTech on 27/09/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
protocol ChangePasswordDisplayLogic: class {
    func showAlertFor(text: String)
    func changePasswordSuccess(detail: String?)
}
class ChangePasswordViewController: BaseViewController {
    var interactor: ChangePasswordBusinessLogic?
    var router: (NSObjectProtocol & ChangePasswordRoutingLogic & ChangePasswordDataPassing)?
    // MARK: IBOutlets
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorIcon: UIImageView!
    @IBOutlet weak var screenDetailsLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveButton: CustomiseButton!
    @IBOutlet weak var showHidePasswordButton: UIButton!
    @IBOutlet weak var newPasswordTextField: CustomiseTextField!
    @IBOutlet weak var newPasswordView: CustomiseView!
    @IBOutlet weak var oldPasswordTextField: CustomiseTextField!
    @IBOutlet weak var oldPasswordView: CustomiseView!
    private var fieldsInArray: [UIView] = []
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = ChangePasswordInteractor()
        let presenter = ChangePasswordPresenter()
        let router = ChangePasswordRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    private func setupUI() {
        self.fieldsInArray = [self.oldPasswordView, newPasswordView]
        self.screenDetailsLabel.setLineSpacing(alignment: .left, minimumLineHeight: 19.0)
    }
    @IBAction func multipleButtonActions(_ sender: UIButton) {
        switch sender {
        case self.saveButton:
            // save button pressed
            self.saveAction()
        case self.showHidePasswordButton:
            self.showHidePassword()
        default:
            //Back Button
            self.navigationController?.popViewController(animated: true)
        }
    }
    private func saveAction() {
        self.view.endEditing(true)
        var postRequest = ChangePassword.ChangePasswordPostRequest()
        postRequest.oldPassword = self.oldPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        postRequest.newPassword = self.newPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if self.validation(model: postRequest) {
            if !checkConnectivity() {
                showLoader()
                self.interactor?.changePassword(postRequest: postRequest)
            }
        }
    }
    @discardableResult
    private func validation(model: ChangePassword.ChangePasswordPostRequest) -> Bool {
        let oldPassword = model.oldPassword ?? ""
        let newPassword = model.newPassword ?? ""
        var isValid = false
        var isAnyFieldEmpty = false
        var isPasswordInvalid = false
        if oldPassword.isEmpty && newPassword.isEmpty {
            self.showError(isError: true, text: .mandatoryFields)
            self.fieldsInArray.forEach {
                $0.setFieldBorderColor(isError: true)
            }
        } else {
            if oldPassword.isEmpty {
                self.oldPasswordView.setFieldBorderColor(isError: true)
                isAnyFieldEmpty = true
            }
            if newPassword.isEmpty {
                self.newPasswordView.setFieldBorderColor(isError: true)
                isAnyFieldEmpty = true
            }
            if oldPassword.count < .minPassword {
                self.oldPasswordView.setFieldBorderColor(isError: true)
                isPasswordInvalid = true
            }
            if newPassword.count < .minPassword {
                self.newPasswordView.setFieldBorderColor(isError: true)
                isPasswordInvalid = true
            }
            if isAnyFieldEmpty || isPasswordInvalid {
                let errorText: String = isAnyFieldEmpty ? .mandatoryFields : .passwordInvalid
                self.showError(isError: true, text: errorText)
            } else {
                isValid = true
                self.fieldsInArray.forEach {$0.removeBorder()}
                self.hideErrorView()
            }
        }
         return isValid
    }
    func showError(isError: Bool, text: String) {
        self.errorView.isHidden = !isError
        self.errorLabel.text = text
    }
    private func showHidePassword() {
        self.showHidePasswordButton.isSelected = !self.showHidePasswordButton.isSelected
        self.newPasswordTextField.isSecureTextEntry = showHidePasswordButton.isSelected ? false : true
    }
    private func hideErrorView() {
        self.errorView.isHidden = true
        self.errorLabel.text = ""
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.fieldsInArray.forEach {$0.removeBorder()}
        self.hideErrorView()
        if textField == self.newPasswordTextField {
            self.newPasswordView.setFieldBorderColor(isError: false)
        } else {
            self.oldPasswordView.setFieldBorderColor(isError: false)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.oldPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.hideErrorView()
        self.fieldsInArray.forEach {$0.removeBorder()}
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        if textField.textInputMode?.primaryLanguage == .emoji || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        guard string != " " else {
            return false
        }
        if textField == self.newPasswordTextField {
            let length =  newString.count
            textField.clearButtonMode = .never
            if length == 0 {
                self.showHidePasswordButton.isSelected = false
            }
            self.showHidePasswordButton.isHidden = (length == 0)
            textField.isSecureTextEntry = length == 0 ? true : textField.isSecureTextEntry
            if textField.isSecureTextEntry {
                let ogText = self.newPasswordTextField.text
                self.newPasswordTextField.deleteBackward()
                self.newPasswordTextField.text = ""
                self.newPasswordTextField.insertText(ogText ?? "")
            }
        }
        return true
    }
}
extension ChangePasswordViewController: ChangePasswordDisplayLogic {
    func showAlertFor(text: String) {
        hideLoader()
        AppUtils.showBanner(with: text)
    }
    func changePasswordSuccess(detail: String?) {
        hideLoader()
        AppUtils.showBanner(with: detail ?? "", type: .done)
        self.navigationController?.popViewController(animated: true)
    }
}