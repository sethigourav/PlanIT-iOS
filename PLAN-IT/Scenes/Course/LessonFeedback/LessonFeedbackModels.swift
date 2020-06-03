//
//  LessonFeedbackModels.swift
//  PLAN-IT
//
//  Created by KiwiTech on 09/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum LessonFeedback {
    // MARK: Use cases
    struct Request: ParameterConvertible {
        var lessonId: Int?
        var isLike: Bool?
        var userID: Int?
        var categoryName: String?
        init(lessonId: Int? = nil, isLike: Bool? = false) {
            self.lessonId = lessonId
            self.isLike = isLike
        }
        init(lessonId: Int? = nil, userID: Int? = nil, categoryName: String? = nil) {
            self.lessonId = lessonId
            self.userID = userID
            self.categoryName = categoryName
        }
    }
    struct Response {
    }
    struct ViewModel {
    }
}
