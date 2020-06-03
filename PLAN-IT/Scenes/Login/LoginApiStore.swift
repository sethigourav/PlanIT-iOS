//
//  LoginApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 02/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
class LoginApiStore {
    func login(request: Login.Request, completion: @escaping Completion<UserResponse>) {
        do {
            let request = try LoginEndPoint.login(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
}
enum LoginEndPoint: APIConfigurable {
    case login(Login.Request)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .login:
            return APIConstants.URLs.login.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .login(let request):
            guard let params = try? request.toParams() else {
                return [:]
            }
        return params
        }
    }
    var headers: [String: String]? {
        return nil
    }
}
