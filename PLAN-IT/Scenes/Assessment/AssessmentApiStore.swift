//
//  AssessmentApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 19/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class AssessmentApiStore: NSObject {
    func sendAssessmentScore(request: Assessment.Request, completion: @escaping Completion<UserResponse>) {
        do {
            let request = try AssessmentApiEndPoint.assessmentScore(request: request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
}
enum AssessmentApiEndPoint: APIConfigurable {
    case assessmentScore(request: Assessment.Request)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .assessmentScore:
            return APIConstants.URLs.assessmentScore.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .assessmentScore(let request):
            guard let params = try? request.toParams() else {
                return [:]
            }
            return params
        }
    }
}
