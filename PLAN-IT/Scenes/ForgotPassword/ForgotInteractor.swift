//
//  ForgotInteractor.swift
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

protocol ForgotBusinessLogic {
    func forgotPassword(for email: String?)
}

protocol ForgotDataStore {
  //var name: String { get set }
}

class ForgotInteractor: ForgotBusinessLogic, ForgotDataStore {
  var presenter: ForgotPresentationLogic?
  var worker: ForgotWorker?
    func forgotPassword(for email: String?) {
        if worker == nil {
            worker = ForgotWorker()
        }
        do {
            try worker?.forgotPassword(for: email, completion: { [weak self] (response) in
                self?.presenter?.handle(response: response)
            })
        } catch let exception {
            handle(exception: exception)
        }
    }
    fileprivate func handle(exception: Error) {
        switch exception {
        case LoginErrors.invalidEmail:
            presenter?.showError(text: .incorrectEmail)
        default:
            presenter?.showError(text: .somethingWentWrong + "\n" + .tryAgainInTime)
        }
    }
}
