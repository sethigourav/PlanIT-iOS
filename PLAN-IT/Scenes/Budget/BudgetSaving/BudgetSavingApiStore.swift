//
//  BudgetSavingApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 13/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class BudgetSavingApiStore {
    func fetchBudgetCategory(completion: @escaping Completion<BudgetCategoryResponse>) {
        do {
            let request = try BudgetSavingEndPoint.fetchBudgetCategory.asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
    func fetchBudgetCategoryDetail(request: BudgetSaving.Request, completion: @escaping Completion<StaticMessgaeResponse>) {
        do {
            let request = try BudgetSavingEndPoint.fetchBudgetCategoryDetail(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
}
enum BudgetSavingEndPoint: APIConfigurable {
    case fetchBudgetCategory
    case fetchBudgetCategoryDetail(BudgetSaving.Request)
    var type: RequestType {
        switch self {
        case .fetchBudgetCategory:
            return .GET
        case .fetchBudgetCategoryDetail:
            return .POST
        }
    }
    var path: String {
        switch self {
        case .fetchBudgetCategory:
            return APIConstants.URLs.budgetCategory.completePath
        case .fetchBudgetCategoryDetail:
            return APIConstants.URLs.budgetCategoryDetail.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .fetchBudgetCategory:
            return [:]
        case .fetchBudgetCategoryDetail(let request):
            guard let params = try? request.toParams() else {
                return [:]
            }
            return params
        }
    }
}
