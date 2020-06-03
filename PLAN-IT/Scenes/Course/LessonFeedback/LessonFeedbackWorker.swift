//
//  LessonFeedbackWorker.swift
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
enum FeedbackErrors: Error {
    case invalidLessonId
}
class LessonFeedbackWorker {
    let apiStore = LessonFeedbackApiStore()
    func sendFeedback(request: LessonFeedback.Request, completion: @escaping Completion<UserResponse>) throws {
        apiStore.sendLessonFeedback(request: request, completion: completion)
    }
}