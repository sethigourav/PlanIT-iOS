//
//  LessonDetailRouter.swift
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

@objc protocol LessonDetailRoutingLogic {
}

protocol LessonDetailDataPassing {
  var dataStore: LessonDetailDataStore? { get set }
}

class LessonDetailRouter: NSObject, LessonDetailRoutingLogic, LessonDetailDataPassing {
  weak var viewController: LessonDetailViewController?
  var dataStore: LessonDetailDataStore?
}
