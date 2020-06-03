//
//  BudgetSavingWorker.swift
//  PLAN-IT
//
//  Created by KiwiTech on 29/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
class BudgetSavingWorker {
    let apiStore = BudgetSavingApiStore()
    func fetchBudgetCategory(completion: @escaping Completion<BudgetCategoryResponse>) throws {
        apiStore.fetchBudgetCategory(completion: completion)
    }
    func fetchBudgetCategoryDetail(request: BudgetSaving.Request, completion: @escaping Completion<StaticMessgaeResponse>) throws {
        apiStore.fetchBudgetCategoryDetail(request: request, completion: completion)
    }
}