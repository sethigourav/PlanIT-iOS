//
//  CreatePinRouter.swift
//  PLAN-IT
//
//  Created by KiwiTech on 04/09/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol CreatePinRoutingLogic {
}

protocol CreatePinDataPassing {
  var dataStore: CreatePinDataStore? { get }
}

class CreatePinRouter: NSObject, CreatePinRoutingLogic, CreatePinDataPassing {
  weak var viewController: CreatePinViewController?
  var dataStore: CreatePinDataStore?
}
