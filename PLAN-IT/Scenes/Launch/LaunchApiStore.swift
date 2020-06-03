//
//  LaunchApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 29/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class LaunchApiStore: NSObject {
    func getUserData(completion: @escaping Completion<UserResponse>) {
        do {
            let request = try LaunchApiEndPoint.getUserData.asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
}
enum LaunchApiEndPoint: APIConfigurable {
    case getUserData
    var type: RequestType {
        return .GET
    }
    var path: String {
        switch self {
        case .getUserData:
            return APIConstants.URLs.getUserData.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .getUserData:
            return [:]
        }
    }
}
