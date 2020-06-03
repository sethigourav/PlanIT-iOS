//
//  AddAccountApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 04/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class AddAccountApiStore {
    func sendPlaidToken(request: AddAccount.Request, completion: @escaping Completion<UserResponse>) {
        do {
            let request = try AddAccountEndPoint.sendPlaidToken(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
}
enum AddAccountEndPoint: APIConfigurable {
    case sendPlaidToken(AddAccount.Request)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .sendPlaidToken:
            return APIConstants.URLs.sendPlaidToken.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .sendPlaidToken(let request):
            guard let params = try? request.toParams() else {
                return [:]
            }
            return params
        }
    }
}
