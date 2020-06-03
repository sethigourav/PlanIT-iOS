//
//  SignUpApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 08/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
class SignUpApiStore {
    func signup(with request: SignUp.Request, completion: @escaping Completion<UserData>) {
        do {
            let urlRequest = try SignUpEndPoint.signUp(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: urlRequest, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
}
enum SignUpEndPoint: APIConfigurable {
    case signUp(SignUp.Request)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .signUp:
            return APIConstants.URLs.signUp.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .signUp(let request):
            guard let params = try? request.toParams() else {
                return [:]
            }
            return params
        }
    }
}
enum SignUpEndPointError: Error {
    case requestConstructFailed
}
