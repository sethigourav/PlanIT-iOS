//
//  SearchCourseApiStore.swift
//  PLAN-IT
//
//  Created by KiwiTech on 20/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class SearchCourseApiStore: NSObject {
    var searchAPITask: URLSessionTask?

    func searchCourseFromServer(request: SearchCourse.Request, completion: @escaping Completion<SearchListResponse>) {
        do {
            if self.searchAPITask != nil {
                self.searchAPITask?.cancel()
                self.searchAPITask = nil
            }
            let request = try SearchCourseApiEndPoint.searchCourse(query: request.search ?? "", limit: request.limit ?? 0, offset: request.offset ?? 0).asURLRequest()
            searchAPITask = NetworkManager.shared.hitRequest(urlRequest: request, completion: { (response: Response<SearchListResponse>) in
                self.searchAPITask = nil
                completion(response)
            })
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
}
enum SearchCourseApiEndPoint: APIConfigurable {
    case searchCourse(query: String, limit: Int, offset: Int)

    var type: RequestType {
        return .GET
    }
    var path: String {
        switch self {
        case .searchCourse(let query, let limit, let offset):
           return APIConstants.URLs.searchCourse(query: query, limit: limit, offset: offset).completePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .searchCourse:
            return [:]
        }
    }
}
