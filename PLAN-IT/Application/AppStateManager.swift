//
//  AppStateManager.swift
//  i-Mar
//
//  Created by KiwiTech on 28/06/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
class AppStateManager {
    static let shared = AppStateManager()
    var fcmToken: String?
    var budgetCategoryArray: [BudgetCategory]?

    var hasLoggedIn: Bool {
        get {
            if let value = UserDefaults.standard.value(for: .loggedIn) as? Bool {
                return value
            }
            return false
        }
        set {
            UserDefaults.standard.set(value: newValue, for: .loggedIn)
        }
    }
    var user: UserData? {
        get {
            if let userParams = UserDefaults.standard.value(for: .userDetails) as? [String: Any] {
                do {
                    let user = try UserData.objectFrom(json: userParams)
                    return user
                } catch let error {
                    print(error)
                }
                return nil
            }
            return nil
        }
        set {
            if let userParams = try? newValue?.toParams() {
                UserDefaults.standard.set(value: userParams, for: .userDetails)
            }
        }
    }
    func logoutUser() {
        user = nil
        UserDefaults.standard.removeValue(for: .initialViewController)
        UserDefaults.standard.removeValue(for: .fcmToken)
        hasLoggedIn = false
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        changeRootView(to: rootViewController())
    }
    func rootViewController() -> Controller {
        if let controllerDict = UserDefaults.standard.value(for: .initialViewController) as? [String: Any], let controller = try? Controller.objectFrom(json: controllerDict) {
            return controller
        }
        if hasLoggedIn == false {
            return Controller(identifier: LoginViewController.navIdentifier, storyboard: .main)
        } else {
            if AppStateManager.shared.user?.isFirstLogin ?? false {
                return Controller(identifier: WelcomeViewController.identifier, storyboard: .main)
            } else {
                return Controller(identifier: PlanItTabbarController.identifier, storyboard: .tabbar)
            }
        }
    }
    func handleOnboarding(data: UserData) {
        if let isFirstLogin = data.isFirstLogin, isFirstLogin {
            let controller = Controller(identifier: WelcomeViewController.identifier)
            AppStateManager.shared.changeRootView(to: controller)
        } else {
            let controller = Controller(identifier: PlanItTabbarController.identifier, storyboard: .tabbar)
            AppStateManager.shared.changeRootView(to: controller)
        }
    }
    func changeRootView(to controller: Controller) {
        let viewController = AppUtils.viewController(with: controller.identifier, in: controller.storyboard)
        appDelegate?.window?.rootViewController = viewController
    }
    func checkIfFeedbackPending(_ viewController: UIViewController) {
        if let feedbackDict = UserDefaults.standard.value(for: .userFeedback) as? [String: Any] {
            let userID = feedbackDict["user_id"] as? Int
            if userID == AppStateManager.shared.user?.id {
                if let controller = AppUtils.viewController(with: LessonFeedbackViewController.identifier, in: .tabbar) as? LessonFeedbackViewController {
                    controller.router?.dataStore?.lessonId = feedbackDict["id"] as? Int ?? 0
                    controller.router?.dataStore?.categoryName = feedbackDict["category_name"] as? String ?? ""
                    viewController.present(controller, animated: true, completion: nil)
                }
            }
        }
    }
}
