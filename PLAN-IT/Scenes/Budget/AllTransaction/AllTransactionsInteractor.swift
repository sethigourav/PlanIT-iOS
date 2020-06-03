//
//  AllTransactionsInteractor.swift
//  PLAN-IT
//
//  Created by KiwiTech on 30/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AllTransactionsBusinessLogic {
  func doSomething(request: AllTransactions.Request)
}

protocol AllTransactionsDataStore {
  //var name: String { get set }
}

class AllTransactionsInteractor: AllTransactionsBusinessLogic, AllTransactionsDataStore {
  var presenter: AllTransactionsPresentationLogic?
  var worker: AllTransactionsWorker?
  // MARK: Do something
  func doSomething(request: AllTransactions.Request) {
    worker = AllTransactionsWorker()
    worker?.doSomeWork()
    let response = AllTransactions.Response()
    presenter?.presentSomething(response: response)
  }
}
