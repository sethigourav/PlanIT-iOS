//
//  AddAccountPresenter.swift
//  PLAN-IT
//
//  Created by KiwiTech on 28/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
protocol AddAccountPresentationLogic {
    func showError(text: String)
    func handle(response: Response<UserResponse>)
}

class AddAccountPresenter: AddAccountPresentationLogic {
    weak var viewController: AddAccountDisplayLogic?
    func showError(text: String) {
        viewController?.showAlertFor(text: text)
    }
    func handle(response: Response<UserResponse>) {
        if response.isSuccess, let value = response.value {
            AppStateManager.shared.user?.isAccount = value.data?.isAccount
            viewController?.tokenSend()
        } else {
            let msg = NetworkManager.shared.errorString(from: response)
            viewController?.showAlertFor(text: msg ?? .failedTo(.proceed) + "\n" + .tryAgainInTime)
        }
    }
}