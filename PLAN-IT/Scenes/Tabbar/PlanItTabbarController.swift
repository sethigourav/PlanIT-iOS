//
//  PlanItTabbarController.swift
//  PLAN-IT
//
//  Created by KiwiTech on 19/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAnalytics
class PlanItTabbarController: UITabBarController {
    @IBOutlet var tabbar: PlanItTabbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setUpTabBarProperties()
        if let tabBarItems = self.tabBar.items, tabBarItems.count > 2 {
            let tabbarItem: UITabBarItem = tabBarItems[3]
            tabbarItem.image = self.setNameAsTabBarItem(AppStateManager.shared.user?.firstName ?? "", AppStateManager.shared.user?.lastName ?? "")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBackgroundImageOfSelectedItem()
        if (viewControllers?.count ?? 0) > 2,
            let navVC = viewControllers?[1] {
            setBudgetScreen(viewController: navVC)
        }
    }
    func setBackgroundImageOfSelectedItem() {
        let numberOfItems = CGFloat(self.tabBar.items!.count)
        let tabBarItemSize = CGSize(width: self.tabBar.frame.width / numberOfItems, height: tabBar.frame.height + tabBar.safeAreaInsets.top + tabBar.safeAreaInsets.bottom)
        self.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor(name: .tabbarSelectedColor), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        self.tabBar.clipsToBounds = true
        self.tabBar.layoutIfNeeded()
    }
    func setUpTabBarProperties() {
        if !UIDevice.isiPhoneXVariant() {
            if let tabBarItems = self.tabBar.items {
                for item in tabBarItems {
                    item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -8.0)
                    item.imageInsets = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
                }
            }
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 11) ?? UIFont.systemFont(ofSize: 11.0)], for: .normal)
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }
    func setNameAsTabBarItem(_ firstName: String, _ lastName: String) -> UIImage? {
        let getTextBlock : () -> String = {
            var strText = ""
            if !firstName.isEmpty {
                strText += String(firstName.first!)
            }
            if !lastName.isEmpty {
                strText += String(lastName.first!)
            }
            return strText
        }
        let backgroundView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 25))
        let coloredView = UIView.init(frame: CGRect.init(x: 0, y: 5, width: 20, height: 20))
        coloredView.backgroundColor = UIColor.init(name: .lightGreenColor)
        coloredView.layer.cornerRadius = 10
        backgroundView.addSubview(coloredView)
        let nameLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: coloredView.frame.width, height: coloredView.frame.height))
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.font =  UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 11)
        nameLabel.text = getTextBlock().uppercased()
        coloredView.addSubview(nameLabel)
        let img = backgroundView.asImage()
        return img.withRenderingMode(.alwaysOriginal)
    }
}
extension PlanItTabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let navController = viewController as? UINavigationController, navController.viewControllers.first is CourseListViewController {
            return true
        } else if let navController = viewController as? UINavigationController, navController.viewControllers.first is LibraryViewController {
            return true
        }
        return true
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = tabBarController.selectedIndex
        switch index {
        case 0:
            Analytics.logEvent(.coursesTabbed, parameters: [.userName: AppStateManager.shared.user?.fullName ?? "",
                                                                 .userId: AppStateManager.shared.user?.id ?? 0])
        case 1:
            setBudgetScreen(viewController: viewController)
            Analytics.logEvent(.budgetTabbed, parameters: [.userName: AppStateManager.shared.user?.fullName ?? "",
                                                                 .userId: AppStateManager.shared.user?.id ?? 0])
        case 2:
            Analytics.logEvent(.libraryTabbed, parameters: [.userName: AppStateManager.shared.user?.fullName ?? "",
                                                                 .userId: AppStateManager.shared.user?.id ?? 0])
        case 3:
            Analytics.logEvent(.accountTabbed, parameters: [.userName: AppStateManager.shared.user?.fullName ?? "",
                                                                 .userId: AppStateManager.shared.user?.id ?? 0])
        default:
            Analytics.logEvent(AnalyticsEventLogin, parameters: [.userName: AppStateManager.shared.user?.fullName ?? "",
                                                                 .userId: AppStateManager.shared.user?.id ?? 0])
        }
    }
    func setBudgetScreen(viewController: UIViewController) {
        if let navVC = viewController as? UINavigationController {
            if AppStateManager.shared.user?.isAccount ?? true, let controller = AppUtils.viewController(with: BudgetSavingViewController.identifier, in: .tabbar) as? BudgetSavingViewController {
                if !(navVC.viewControllers[0] is BudgetSavingViewController) {
                    navVC.viewControllers = [controller]
                }
            } else {
                if let controller = AppUtils.viewController(with: AddAccountViewController.identifier, in: .tabbar) as? AddAccountViewController {
                    if !(navVC.viewControllers[0] is AddAccountViewController) {
                        navVC.viewControllers = [controller]
                    }
                }
            }
        }
    }
}
