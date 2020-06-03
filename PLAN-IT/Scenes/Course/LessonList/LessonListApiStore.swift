//
//  LessonListApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 08/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class LessonListApiStore: NSObject {
    func getLessonDetail(lessonId: Int, completion: @escaping Completion<LessonDetailResponse>) {
        do {
            let request = try LessonListApiEndPoint.lessonDetail(lessonId: lessonId).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
    func lessonRead(lessonId: Int, completion: @escaping Completion<StaticMessgaeResponse>) {
        do {
            let request = try LessonListApiEndPoint.lessonRead(lessonId: lessonId).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
}
enum LessonListApiEndPoint: APIConfigurable {
    case lessonDetail(lessonId: Int),
    lessonRead(lessonId: Int)
    var type: RequestType {
        switch self {
        case .lessonDetail:
            return .GET
        case .lessonRead:
            return .PATCH
        }
    }
    var path: String {
        switch self {
        case .lessonDetail(let lessonId):
            return APIConstants.URLs.lessonDetail(lessonId: lessonId).completePath
        case .lessonRead(let lessonId):
            return APIConstants.URLs.lessonRead(lessonId: lessonId).completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .lessonDetail, .lessonRead:
            return [:]
        }
    }
}
