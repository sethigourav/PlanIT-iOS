//
//  VerificationResetRouter.swift
//  PLAN-IT
//
//  Created by KiwiTech on 12/07/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol VerificationResetRoutingLogic {
}

protocol VerificationResetDataPassing {
  var dataStore: VerificationResetDataStore? { get set }
}

class VerificationResetRouter: NSObject, VerificationResetRoutingLogic, VerificationResetDataPassing {
  weak var viewController: VerificationResetViewController?
  var dataStore: VerificationResetDataStore?
}
