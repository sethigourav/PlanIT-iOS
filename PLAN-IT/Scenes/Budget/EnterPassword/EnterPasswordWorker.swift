//
//  EnterPasswordWorker.swift
//  PLAN-IT
//
//  Created by KiwiTech on 06/09/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
class EnterPasswordWorker {
    let apiStore = EnterPasswordApiStore()
    func enterPassword(password: String, completion: @escaping Completion<Details>) throws {
        apiStore.enterPassword(password: password, completion: completion)
    }
}