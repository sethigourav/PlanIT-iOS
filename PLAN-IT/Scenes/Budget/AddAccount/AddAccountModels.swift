//
//  AddAccountModels.swift
//  PLAN-IT
//
//  Created by KiwiTech on 28/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
enum AddAccount {
  // MARK: Use cases
    struct Request: ParameterConvertible {
        var token: String?
        init(token: String? = nil) {
            self.token = token
        }
    }
    struct Response {
    }
    struct ViewModel {
    }
}