//
//  SetAnnualIncomeApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 17/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class SetAnnualIncomeApiStore {
    func setAnnualIncome(request: SetAnnualIncome.Request, completion: @escaping Completion<UserResponse>) {
        do {
            let request = try SetAnnualIncomeEndPoint.setAnnualIncome(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
}
enum SetAnnualIncomeEndPoint: APIConfigurable {
    case setAnnualIncome(SetAnnualIncome.Request)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .setAnnualIncome:
            return APIConstants.URLs.setAnnualIncome.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .setAnnualIncome(let request):
            guard let params = try? request.toParams() else {
                return [:]
            }
            return params
        }
    }
}
