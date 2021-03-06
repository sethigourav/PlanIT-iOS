//
//  AccountInteractor.swift
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

protocol AccountBusinessLogic {
    func deActivateLinkedAccount()
    func changePushStatus(postRequest: Account.ChangePushPostRequst)
    func sendPlaidToken(request: AddAccount.Request)
    func logout()
    func validateReferenceCode(request: Account.Request)
}

protocol AccountDataStore {
    //var name: String { get set }
}

class AccountInteractor: AccountBusinessLogic, AccountDataStore {
    var presenter: AccountPresentationLogic?
    var worker: AccountWorker?
    func deActivateLinkedAccount() {
        if self.worker == nil {
            worker = AccountWorker()
        }
        do {
            try  self.worker?.deActivateLinkedAccount(request: Account.DeActivatePostRequst(), completion: { (response) in
                self.presenter?.presentHandleDeActivateAccount(response: response)
            })
        } catch let error {
            handle(exception: error)
        }
    }
    fileprivate func handle(exception: Error) {
        self.presenter?.showError(text: .somethingWentWrong + "\n" + .tryAgainInTime)
    }
    func changePushStatus(postRequest: Account.ChangePushPostRequst) {
        if self.worker == nil {
            worker = AccountWorker()
        }
        do {
            try  self.worker?.changePushStatus(request: postRequest, completion: { (response) in
                self.presenter?.presentHandlePushStatus(response: response)
            })
        } catch let error {
            handle(exception: error)
        }
    }
    func sendPlaidToken(request: AddAccount.Request) {
        let addAccountWorker = AddAccountWorker()
        do {
            try addAccountWorker.sendPlaidToken(request: request, completion: {[weak self] (response) in
                self?.presenter?.handle(response: response)
            })
        } catch let error {
            handle(exception: error)
        }
    }
    func logout() {
        if self.worker == nil {
            worker = AccountWorker()
        }
        do {
            try self.worker?.logout(completion: { (response) in
                self.presenter?.handleLogout(response: response)
            })
        } catch let error {
            handle(exception: error)
        }
    }
    func validateReferenceCode(request: Account.Request) {
        if self.worker == nil {
            worker = AccountWorker()
        }
        do {
            try self.worker?.validateReferenceCode(request: request, completion: { (response) in
                self.presenter?.handleReferenceCode(response: response)
            })
        } catch let error {
            handle(exception: error)
        }
    }
}
