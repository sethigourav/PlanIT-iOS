//
//  SearchCourseModels.swift
//  PLAN-IT
//
//  Created by KiwiTech on 19/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
enum SearchCourse {
    // MARK: Use cases
    struct Request: ParameterConvertible {
        var search: String?
        var limit: Int?
        var offset: Int?
        init(query: String? = nil, limit: Int? = nil, offset: Int? = nil) {
            self.search = query
            self.limit = limit
            self.offset = offset
        }
    }
    struct Response {
    }
    struct ViewModel {
    }
}