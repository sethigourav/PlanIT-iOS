//
//  ForgotViewController.swift
//  PLAN-IT
//
//  Created by KiwiTech on 12/07/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ForgotDisplayLogic: class {
    func showAlertFor(text: String)
    func emailSent(with message: String)
}

class ForgotViewController: BaseViewController, ForgotDisplayLogic {
    var interactor: ForgotBusinessLogic?
    var router: (NSObjectProtocol & ForgotRoutingLogic & ForgotDataPassing)?
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailview: CustomiseView!
    @IBOutlet weak var emailfield: CustomiseTextField!
    @IBOutlet weak var descriptionLabel: UILabel!
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
        let interactor = ForgotInteractor()
        let presenter = ForgotPresenter()
        let router = ForgotRouter()
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
        descriptionLabel.setLineSpacing(lineSpacing: 5.0, lineHeightMultiple: 0.0, alignment: .left)
    }
    func emailSent(with message: String) {
        hideLoader()
        router?.showVerificationScreen(email: emailfield.text?.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    func showAlertFor(text: String) {
        hideLoader()
        AppUtils.showBanner(with: text)
    }
    @IBAction func sendLinkBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        if let email = emailfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            self.errorView.isHidden = false
            if email.isEmpty {
                errorLabel.text = .mandatoryFields
                setFieldBorderColor(isError: true, view: emailview)
            } else if email.count > 0 && !ValidationUtils.validateEmail(emailID: email) {
                setFieldBorderColor(isError: true, view: emailview)
                errorLabel.text = .invalidFormat
            } else {
                self.errorView.isHidden = true
                showLoader()
                self.interactor?.forgotPassword(for: email)
            }
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
extension ForgotViewController {
    func setFieldBorderColor(isError: Bool, view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = isError ? UIColor(name: .errorColor).cgColor : UIColor(name: .defaultColor).cgColor
    }
    func removeBorderColor() {
        emailview.layer.borderWidth = 0
    }
}
extension ForgotViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.errorView.isHidden = true
        self.errorLabel.text = ""
        setFieldBorderColor(isError: false, view: emailview)
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
