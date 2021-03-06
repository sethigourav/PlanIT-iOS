//
//  AddAccountInteractor.swift
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

protocol AddAccountBusinessLogic {
  func sendPlaidToken(request: AddAccount.Request)
}

protocol AddAccountDataStore {
  //var name: String { get set }
}

class AddAccountInteractor: AddAccountBusinessLogic, AddAccountDataStore {
  var presenter: AddAccountPresentationLogic?
  var worker: AddAccountWorker?
  // MARK: Do something
    func sendPlaidToken(request: AddAccount.Request) {
        if worker == nil {
            worker = AddAccountWorker()
        }
        do {
            try worker?.sendPlaidToken(request: request, completion: {[weak self] (response) in
                self?.presenter?.handle(response: response)
            })
        } catch let error {
            handle(exception: error)
        }
    }
    fileprivate func handle(exception: Error) {
        presenter?.showError(text: .somethingWentWrong + "\n" + .tryAgainInTime)
    }
}
