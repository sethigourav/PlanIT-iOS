//
//  CourseApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 05/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class CourseListApiStore: NSObject {
    func getCourselist(completion: @escaping Completion<CourseListResponse>) {
        do {
            let request = try CourseApiEndPoint.courseList.asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
    func getLessonlist(courseId: Int, completion: @escaping Completion<LessonListResponse>) {
        do {
            let request = try CourseApiEndPoint.lessonList(courseId: courseId).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
    func checkNewCourse(courseId: Int, completion: @escaping Completion<StaticMessgaeResponse>) {
        do {
            let request = try CourseApiEndPoint.checkNewCourse(courseId: courseId).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(Response.ResponseError(error: error, statusCode: nil)))
        }
    }
}
enum CourseApiEndPoint: APIConfigurable {
    case courseList,
    lessonList(courseId: Int),
    checkNewCourse(courseId: Int)
    var type: RequestType {
        switch self {
        case .courseList, .lessonList:
             return .GET
        case .checkNewCourse:
            return .PATCH
        }
    }
    var path: String {
        switch self {
        case .courseList:
            return APIConstants.URLs.courseList.completePath
        case .lessonList(let courseId):
            return APIConstants.URLs.lessonList(courseId: courseId).completePath
        case .checkNewCourse(let courseId):
            return APIConstants.URLs.checkNewCourse(courseId: courseId).completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .courseList, .lessonList, .checkNewCourse:
            return [:]
        }
    }
}
