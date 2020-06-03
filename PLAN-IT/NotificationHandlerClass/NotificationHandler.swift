//
//  NotificationHandler.swift
//  Kaster
//
//  Created by KiwiTech on 08/04/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseMessaging
import FirebaseInstanceID

class NotificationHandler: NSObject, MessagingDelegate {
    static let shared = NotificationHandler()
    fileprivate let apiStore = NotificationHandlerAPIStore()
    fileprivate var router = NotificationHandlerRouter()
    private override init() {}
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        AppStateManager.shared.fcmToken = fcmToken
        registerFCMToken(fcmToken: fcmToken)
    }
    func registerFCMToken(fcmToken: String) {
        guard AppStateManager.shared.hasLoggedIn else {
            return
        }
        if UserDefaults.standard.value(for: .fcmToken) as? String == nil {
            apiStore.registerToken(registrationID: fcmToken) { (response) in
                UserDefaults.standard.set(value: fcmToken, for: .fcmToken)
                print(response.isSuccess)
            }
        }
    }
    func handleNotificationPayload(notificationInfo: [AnyHashable: Any]) {
       //handle response
        if let type = notificationInfo["type"] as? String {
            UIApplication.shared.applicationIconBadgeNumber -= 1
            self.router.viewController = appDelegate?.window?.topViewController()
            let courseId = notificationInfo["id"] as? String
            switch type {
            case "2": //lesson list
                moveToLessonList(courseId: Int(courseId ?? "0") ?? 0)
            case "4", "5": //budget
                moveToBudget()
            default:
                if let root: PlanItTabbarController = appDelegate?.window?.rootViewController as? PlanItTabbarController {
                    if let controller = root.viewControllers?[root.selectedIndex] as? UINavigationController {
                        root.selectedIndex = 0
                        controller.popToRootViewController(animated: true)
                        controller.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    func moveToBudget() {
        if let root: PlanItTabbarController = appDelegate?.window?.rootViewController as? PlanItTabbarController {
            if let controller = root.viewControllers?[root.selectedIndex] as? UINavigationController {
                root.selectedIndex = 1
                controller.popToRootViewController(animated: true)
                controller.dismiss(animated: true, completion: nil)
            }
        }
    }
    func moveToLessonList(courseId: Int) {
        if let courseList = appDelegate?.window?.topViewController(), courseList is CourseListViewController {
            if let controller = courseList as? CourseListViewController {
                controller.interactor?.getCourseList()
                controller.interactor?.getLessonList(courseId: courseId)
                controller.interactor?.checkNewCourse(courseId: courseId)
            }
        } else {
            if let root: PlanItTabbarController = appDelegate?.window?.rootViewController as? PlanItTabbarController {
                if let controller = root.viewControllers?.first as? UINavigationController, let courseList = controller.viewControllers.first as? CourseListViewController {
                    root.selectedIndex = 0
                    controller.popToRootViewController(animated: true)
                    controller.dismiss(animated: true, completion: nil)
                    courseList.interactor?.getLessonList(courseId: courseId)
                    courseList.interactor?.checkNewCourse(courseId: courseId)
                }
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func getCurrentFCMToken(_ completion: @escaping ((String) -> Void)) {
        InstanceID.instanceID().instanceID { (result, _) in
            if let result = result {
                completion(result.token)
            } else {
                completion("")
            }
        }
    }
    func requestNotificationAuthorization(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {isGranted, _ in
            if isGranted {
                Messaging.messaging().delegate = NotificationHandler.shared
                self.getCurrentFCMToken {token in
                    AppStateManager.shared.fcmToken = token
                    NotificationHandler.shared.registerFCMToken(fcmToken: token)
                }
            }
        })
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        print("+++++token = \(token)")
    }
    // iOS10+, called when presenting notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationHandler.shared.handleNotificationPayload(notificationInfo: userInfo)
        completionHandler()
    }
}

extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
