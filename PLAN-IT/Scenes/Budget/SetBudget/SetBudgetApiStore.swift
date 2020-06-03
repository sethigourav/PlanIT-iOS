//
//  SetBudgetApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 13/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class SetBudgetApiStore {
    func setBudget(request: SetBudget.Request, completion: @escaping Completion<UserResponse>) {
        do {
            let request = try SetBudgetEndPoint.setBudget(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
}
enum SetBudgetEndPoint: APIConfigurable {
    case setBudget(SetBudget.Request)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .setBudget:
            return APIConstants.URLs.setBudget.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .setBudget(let request):
            guard let params = try? request.toParams() else {
                return [:]
            }
            return params
        }
    }
}
