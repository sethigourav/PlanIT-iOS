//
//  LoginRouter.swift
//  i-Mar
//
//  Created by KiwiTech on 01/07/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol LoginRoutingLogic {
    func showVerificationScreen(email: String?)
}
protocol LoginDataPassing {
  var dataStore: LoginDataStore? { get }
}

class LoginRouter: NSObject, LoginRoutingLogic, LoginDataPassing {
  weak var viewController: LoginViewController?
  var dataStore: LoginDataStore?

    func showVerificationScreen(email: String?) {
       viewController?.hideLoader()
        if let verificationVC = AppUtils.viewController(with: VerificationResetViewController.identifier) as? VerificationResetViewController {
            verificationVC.router?.dataStore?.modelObj = VerificationReset.ViewModel(email: email, isFromSignUp: true)
            viewController?.navigationController?.pushViewController(verificationVC, animated: true)
        }
    }
}
