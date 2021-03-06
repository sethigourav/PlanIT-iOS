//
//  LaunchRouter.swift
//  PLAN-IT
//
//  Created by KiwiTech on 29/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol LaunchRoutingLogic {
}

protocol LaunchDataPassing {
  var dataStore: LaunchDataStore? { get }
}

class LaunchRouter: NSObject, LaunchRoutingLogic, LaunchDataPassing {
  weak var viewController: LaunchViewController?
  var dataStore: LaunchDataStore?
}
