//
//  LessonDetailApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 14/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class LessonDetailApiStore: NSObject {
    func completeLesson(request: LessonDetail.Request, completion: @escaping Completion<StaticMessgaeResponse>) {
        do {
            let request = try LessonDetailApiEndPoint.lessonCompleted(request: request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
}
enum LessonDetailApiEndPoint: APIConfigurable {
    case lessonCompleted(request: LessonDetail.Request)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .lessonCompleted:
            return APIConstants.URLs.lessonCompleted.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .lessonCompleted(let request):
            guard let params = try? request.toParams() else {
                return [:]
            }
            return params
        }
    }
}
