//
//  WelcomeApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 26/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class WelcomeApiStore: NSObject {
    func getAssessmentQuestions(completion: @escaping Completion<AssesmentResponse>) {
        do {
            let request = try WelcomeEndPoint.getAssessmentQuestions.asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
}
enum WelcomeEndPoint: APIConfigurable {
    case getAssessmentQuestions
    var type: RequestType {
        return .GET
    }
    var path: String {
        switch self {
        case .getAssessmentQuestions:
            return APIConstants.URLs.assessmentQusetions.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .getAssessmentQuestions:
            return [:]
        }
    }
}
