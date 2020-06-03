//
//  CreatePinApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 04/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class CreatePinApiStore {
    func createPin(request: CreatePin.Request, completion: @escaping Completion<UserResponse>) {
        do {
            let request = try CreatePinEndPoint.createPin(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
    func verifyPin(request: CreatePin.Request, completion: @escaping Completion<StaticMessgaeResponse>) {
        do {
            let request = try CreatePinEndPoint.verifyPin(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
}
enum CreatePinEndPoint: APIConfigurable {
    case createPin(CreatePin.Request)
    case verifyPin(CreatePin.Request)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .createPin:
            return APIConstants.URLs.createPin.completePath
        case .verifyPin:
            return APIConstants.URLs.verifyPin.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .createPin(let request), .verifyPin(let request):
            guard let params = try? request.toParams() else {
                return [:]
            }
            return params
        }
    }
}
