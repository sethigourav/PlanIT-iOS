//
//  EnterPasswordRouter.swift
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

@objc protocol EnterPasswordRoutingLogic {
}

protocol EnterPasswordDataPassing {
  var dataStore: EnterPasswordDataStore? { get }
}

class EnterPasswordRouter: NSObject, EnterPasswordRoutingLogic, EnterPasswordDataPassing {
  weak var viewController: EnterPasswordViewController?
  var dataStore: EnterPasswordDataStore?
}