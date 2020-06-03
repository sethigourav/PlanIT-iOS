//
//  TermsPrivacyApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 07/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class TermsPrivacyApiStore: NSObject {
    func getUrls(completion: @escaping Completion<TermsPolicyResponse>) {
        do {
            let request = try TermsPrivacyApiEndPoint.getUrl.asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
}
enum TermsPrivacyApiEndPoint: APIConfigurable {
    case getUrl
    var type: RequestType {
        return .GET
    }
    var path: String {
        switch self {
        case .getUrl:
            return APIConstants.URLs.termsPrivacy.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .getUrl:
            return [:]
        }
    }
}
