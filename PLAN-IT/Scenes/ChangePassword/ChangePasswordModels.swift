//
//  ChangePasswordModels.swift
//  PLAN-IT
//
//  Created by KiwiTech on 27/09/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ChangePassword {
    struct ChangePasswordPostRequest: ParameterConvertible {
        var oldPassword: String?
        var newPassword: String?
        init() {}
    }
}