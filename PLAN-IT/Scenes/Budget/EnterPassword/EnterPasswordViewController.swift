//
//  EnterPasswordViewController.swift
//  PLAN-IT
//
//  Created by KiwiTech on 06/09/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EnterPasswordDisplayLogic: class {
    func showAlertFor(text: String)
    func passwordVerified(data: String?)
}

class EnterPasswordViewController: BaseViewController, EnterPasswordDisplayLogic {
    var interactor: EnterPasswordBusinessLogic?
    var router: (NSObjectProtocol & EnterPasswordRoutingLogic & EnterPasswordDataPassing)?
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var passwordField: CustomiseTextField!
    @IBOutlet weak var passwordView: CustomiseView!
    var isFromLibrary = false
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
        let interactor = EnterPasswordInteractor()
        let presenter = EnterPasswordPresenter()
        let router = EnterPasswordRouter()
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
    }
    func displaySomething(viewModel: EnterPassword.ViewModel) {
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func okBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        if let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            self.errorView.isHidden = false
            if password.isEmpty {
                errorLabel.text = .mandatoryFields
                setFieldBorderColor(isError: true, view: passwordView)
            } else {
                self.errorView.isHidden = true
                showLoader()
                interactor?.enterPassword(for: password)
            }
        }
    }
    func showAlertFor(text: String) {
        hideLoader()
        AppUtils.showBanner(with: text)
    }
    func passwordVerified(data: String?) {
        hideLoader()
        if let controller = AppUtils.viewController(with: CreatePinViewController.identifier, in: .tabbar) as? CreatePinViewController {
            controller.isForResetPin = true
            controller.isFromAccount = true
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
extension EnterPasswordViewController {
    func setFieldBorderColor(isError: Bool, view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = isError ? UIColor(name: .errorColor).cgColor : UIColor(name: .defaultColor).cgColor
    }
    func removeBorderColor() {
        passwordView.layer.borderWidth = 0
    }
}
extension EnterPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errorView.isHidden = true
        self.errorLabel.text = ""
        setFieldBorderColor(isError: false, view: passwordView)
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
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        removeBorderColor()
    }
}