//
//  AccountApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 27/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class AccountApiStore {
    func deActivateLinkedAccount(request: Account.DeActivatePostRequst, completion: @escaping Completion<UserResponse>) {
        do {
            let request = try AccountEndPoint.deActiveAccount(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
    func changePushStatus(request: Account.ChangePushPostRequst, completion: @escaping Completion<PushResponse>) {
        do {
            let request = try AccountEndPoint.changePushStatus(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
    func logout(completion: @escaping Completion<Details>) {
        do {
            let request = try AccountEndPoint.logout.asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
    func validateReferenceCode(request: Account.Request, completion: @escaping Completion<SubscriptionResponse>) {
        do {
            let request = try AccountEndPoint.validateReferenceCode(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
}
enum AccountEndPoint: APIConfigurable {
    case deActiveAccount(Account.DeActivatePostRequst),
         changePushStatus(Account.ChangePushPostRequst),
         logout,
         validateReferenceCode(Account.Request)
    var type: RequestType {
        switch self {
        case .deActiveAccount:
            return .DELETE
        case .changePushStatus, .validateReferenceCode:
            return .PATCH
        case .logout:
            return .GET
        }
    }
    var path: String {
        switch self {
        case .deActiveAccount(let request):
            return APIConstants.URLs.budgetAccountDelete.completePath + "\(request.id)"
        case .changePushStatus(let request):
            return APIConstants.URLs.budgetAccountDelete.completePath + "\(request.id)"
        case .logout:
            return APIConstants.URLs.logout.completePath
        case .validateReferenceCode(let request):
            return APIConstants.URLs.validateReferenceCode(code: request.promoCode ?? "").completePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .deActiveAccount, .logout, .validateReferenceCode:
            return [:]
        case .changePushStatus(let request):
            guard let params = try? request.pushStatus?.toParams() else {
                return [:]
            }
            return params
        }
    }
}
