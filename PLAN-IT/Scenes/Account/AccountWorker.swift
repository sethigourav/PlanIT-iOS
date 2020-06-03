//
//  AccountWorker.swift
//  PLAN-IT
//
//  Created by KiwiTech on 07/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class AccountWorker {
    let apiStore = AccountApiStore()
    func deActivateLinkedAccount(request: Account.DeActivatePostRequst, completion: @escaping Completion<UserResponse>) throws {
        apiStore.deActivateLinkedAccount(request: request, completion: completion)
    }
    func changePushStatus(request: Account.ChangePushPostRequst, completion: @escaping Completion<PushResponse>) throws {
        apiStore.changePushStatus(request: request, completion: completion)
    }
    func logout(completion: @escaping Completion<Details>) throws {
        apiStore.logout(completion: completion)
    }
    func validateReferenceCode(request: Account.Request, completion: @escaping Completion<SubscriptionResponse>) throws {
        apiStore.validateReferenceCode(request: request, completion: completion)
    }
}
