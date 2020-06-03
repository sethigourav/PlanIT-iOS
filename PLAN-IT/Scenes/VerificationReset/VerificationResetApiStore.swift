//
//  VerificationResetApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 12/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class VerificationResetApiStore: NSObject {
    func resendEmail(email: String, with completion: @escaping Completion<Details>) {
        do {
            let request = try VerificationResetEndPoint.resend(email).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
}
enum VerificationResetEndPoint: APIConfigurable {
    case resend(String)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .resend:
            return APIConstants.URLs.resend.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .resend(let email):
            return [APIConstants.Mix.email: email]
        }
    }
}
