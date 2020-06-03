//
//  WelcomeRouter.swift
//  PLAN-IT
//
//  Created by KiwiTech on 23/07/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol WelcomeRoutingLogic {
    func showAssessment(questions: [Category]?)
}

protocol WelcomeDataPassing {
    var dataStore: WelcomeDataStore? { get set }
}

class WelcomeRouter: NSObject, WelcomeRoutingLogic, WelcomeDataPassing {
    weak var viewController: WelcomeViewController?
    var dataStore: WelcomeDataStore?
    func showAssessment(questions: [Category]?) {
        if let controller = AppUtils.viewController(with: AssessmentViewController.identifier) as? AssessmentViewController {
            controller.router?.dataStore?.assessmentQuestions = questions
            appDelegate?.window?.rootViewController = controller
        }
    }
}
