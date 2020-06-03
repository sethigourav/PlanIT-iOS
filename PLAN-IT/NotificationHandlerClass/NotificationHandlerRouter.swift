//
//  NotificationHandlerRouter.swift
//  Kaster
//
//  Created by KiwiTech on 10/04/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
protocol NotificationHandlerRoutingLogic {
}
class NotificationHandlerRouter: NSObject, NotificationHandlerRoutingLogic {
    weak var viewController: UIViewController?
}
