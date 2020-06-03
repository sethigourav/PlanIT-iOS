//
//  ForgotPresenter.swift
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
protocol ForgotPresentationLogic {
    func showError(text: String)
    func handle(response: Response<Details>)
}

class ForgotPresenter: ForgotPresentationLogic {
    weak var viewController: ForgotDisplayLogic?
    func showError(text: String) {
        viewController?.showAlertFor(text: text)
    }
    func handle(response: Response<Details>) {
        if response.isSuccess, let value = response.value {
            viewController?.emailSent(with: value.detail ?? .emailSent)
        } else {
            let msg = NetworkManager.shared.errorString(from: response)
            viewController?.showAlertFor(text: msg ?? .failedTo(.proceed) + "\n" + .tryAgainInTime)
        }
    }
}