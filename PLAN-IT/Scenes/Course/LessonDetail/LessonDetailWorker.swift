//
//  LessonDetailWorker.swift
//  PLAN-IT
//
//  Created by KiwiTech on 13/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
class LessonDetailWorker {
    let apiStore = LessonDetailApiStore()
    func completeLesson(request: LessonDetail.Request, completion: @escaping Completion<StaticMessgaeResponse>) throws {
        apiStore.completeLesson(request: request, completion: completion)
    }
}
