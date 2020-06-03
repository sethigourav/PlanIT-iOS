//
//  AccountPresenter.swift
//  PLAN-IT
//
//  Created by KiwiTech on 07/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AccountPresentationLogic {
    func presentHandleDeActivateAccount(response: Response<UserResponse>)
    func presentHandlePushStatus(response: Response<PushResponse>)
    func showError(text: String)
    func handle(response: Response<UserResponse>)
    func handleLogout(response: Response<Details>)
    func handleReferenceCode(response: Response<SubscriptionResponse>)
}

class AccountPresenter: AccountPresentationLogic {
    weak var viewController: AccountDisplayLogic?
    func presentHandleDeActivateAccount(response: Response<UserResponse>) {
        if response.isSuccess, let value = response.value {
            self.viewController?.deActivateLinkedAccountSuccess(detail: value.detail)
        } else {
            let msg = NetworkManager.shared.errorString(from: response)
            self.viewController?.showAlertFor(text: msg ?? .failedTo(.proceed) + "\n" + .tryAgainInTime)
        }
    }
    func showError(text: String) {
        self.viewController?.showAlertFor(text: text)
    }
    func presentHandlePushStatus(response: Response<PushResponse>) {
        if response.isSuccess, let value = response.value {
            self.viewController?.changePushStatusSuccess(pushStatus: value.data)
        } else {
            let msg = NetworkManager.shared.errorString(from: response)
            self.viewController?.showAlertFor(text: msg ?? .failedTo(.proceed) + "\n" + .tryAgainInTime)
        }
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
    func handleLogout(response: Response<Details>) {
        if response.isSuccess {
            viewController?.logout()
        } else {
            let msg = NetworkManager.shared.errorString(from: response)
            viewController?.showAlertFor(text: msg ?? .failedTo(.proceed) + "\n" + .tryAgainInTime)
        }
    }
    func handleReferenceCode(response: Response<SubscriptionResponse>) {
        if response.isSuccess, let value = response.value {
            viewController?.validateReferenceCode(data: value.data)
        } else {
            let msg = NetworkManager.shared.errorString(from: response)
            viewController?.showAlertFor(text: msg ?? .failedTo(.proceed) + "\n" + .tryAgainInTime)
        }
    }
}