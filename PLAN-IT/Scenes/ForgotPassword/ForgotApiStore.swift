//
//  ForgotApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 12/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class ForgotApiStore: NSObject {
    func forgotPassword(email: String, completion: @escaping Completion<Details>) {
        do {
            let request = try ForgotPasswordEndPoint.forgotPassword(email).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
}
enum ForgotPasswordEndPoint: APIConfigurable {
    case forgotPassword(String)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .forgotPassword:
            return APIConstants.URLs.forgotPassword.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .forgotPassword(let email):
            return [APIConstants.Mix.email: email]
        }
    }
}
