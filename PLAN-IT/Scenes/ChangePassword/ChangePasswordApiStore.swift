//
//  ChangePasswordApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 27/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation

class ChangePasswordApiStore {
    func changePassword(postRequest: ChangePassword.ChangePasswordPostRequest, completion: @escaping Completion<UserResponse>) {
        do {
            let request = try ChangePasswordEndPoint.changePassword(postRequest).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
}
enum ChangePasswordEndPoint: APIConfigurable {
    case changePassword(ChangePassword.ChangePasswordPostRequest)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .changePassword:
            return APIConstants.URLs.changePassword.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .changePassword(let changePasswordPostRequest):
            guard let params = try? changePasswordPostRequest.toParams() else {
                return [:]
            }
            return params
        }
    }
}
