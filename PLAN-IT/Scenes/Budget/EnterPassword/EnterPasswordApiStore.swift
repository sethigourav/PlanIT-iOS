//
//  EnterPasswordApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 06/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class EnterPasswordApiStore: NSObject {
    func enterPassword(password: String, completion: @escaping Completion<Details>) {
        do {
            let request = try EnterPasswordEndPoint.enterPassword(password).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
}
enum EnterPasswordEndPoint: APIConfigurable {
    case enterPassword(String)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .enterPassword:
            return APIConstants.URLs.enterPassword.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .enterPassword(let password):
            return [APIConstants.Keys.password: password]
        }
    }
}
