//
//  LessonFeedbackApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 09/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class LessonFeedbackApiStore: NSObject {
    func sendLessonFeedback(request: LessonFeedback.Request, completion: @escaping Completion<UserResponse>) {
        do {
            let request = try FeedbackApiEndPoint.lessonFeedback(request: request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
}
enum FeedbackApiEndPoint: APIConfigurable {
    case lessonFeedback(request: LessonFeedback.Request)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .lessonFeedback:
            return APIConstants.URLs.lessonFeedback.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .lessonFeedback(let request):
            guard let params = try? request.toParams() else {
                return [:]
            }
            return params
        }
    }
}
