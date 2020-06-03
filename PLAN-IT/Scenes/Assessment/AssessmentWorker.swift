//
//  AssessmentWorker.swift
//  PLAN-IT
//
//  Created by KiwiTech on 19/07/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
class AssessmentWorker {
    let apiStore = AssessmentApiStore()
    func sendAssessmentScore(request: Assessment.Request, completion: @escaping Completion<UserResponse>) throws {
        apiStore.sendAssessmentScore(request: request, completion: completion)
    }
}
