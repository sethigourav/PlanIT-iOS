//
//  NotificationHandlerAPIStore.swift
//  Kaster
//
//  Created by KiwiTech on 10/04/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
class NotificationHandlerAPIStore: NSObject {
    func registerToken(registrationID: String, completion: @escaping Completion<Details>) {
        do {
            let request = try NotificationHandlerEndpoints.registerToken(registrationID: registrationID).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch let error {
            completion(.failed(APIError(error: error)))
        }
    }
}
enum NotificationHandlerEndpoints: APIConfigurable {
    case registerToken(registrationID: String)
    var type: RequestType {
        switch self {
        case .registerToken:
            return .POST
        }
    }
    var path: String {
        switch self {
        case .registerToken:
            return APIConstants.URLs.registerDeviceToken.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .registerToken(let registrationID):
            return ["registration_id": registrationID, "type": "ios"]
        }
    }
}
