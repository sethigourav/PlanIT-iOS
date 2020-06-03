//
//  LessonListTableHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 09/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
extension LessonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LessonListCell.identifier, for: indexPath) as? LessonListCell
        cell?.updateUI(data: lessons, index: indexPath.row)
        return cell ?? UITableViewCell()
    }
}
extension LessonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        let obj = lessons?[indexPath.row]
        let isSubscribed = AppStateManager.shared.user?.isSubscribed ?? false || AppStateManager.shared.user?.isPromoSubscribed ?? false
        if let isPlaying = obj?.isPlaying, let isCompleted = obj?.isCompleted, (isPlaying && isSubscribed) || indexPath.item == 0 || isCompleted {
           showLoader()
           interactor?.getLessondetail(lessonId: obj?.id ?? 0)
        } else {
            if let isSubscribed = AppStateManager.shared.user?.isSubscribed, let isPromoSubscribed = AppStateManager.shared.user?.isPromoSubscribed, !isSubscribed && !isPromoSubscribed {
                if let controller = AppUtils.viewController(with: SubscriptionPopup.identifier, in: .tabbar) as? SubscriptionPopup {
                    _ = controller.view
                    let height = UIScreen.main.bounds.height - controller.heightConstraint.constant
                    if isCellSelected {
                        bottomSheet?.goToTop(direction: height)
                        shake()
                    } else {
                        isCellSelected = true
                        bottomSheet?.goToTop(direction: height)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if let controller = AppUtils.viewController(with: LessonIncompletePopup.identifier, in: .tabbar) as? LessonIncompletePopup {
                        controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                        controller.modalPresentationStyle = .overFullScreen
                        self.navigationController?.present(controller, animated: false, completion: nil)
                    }
                }
            }
        }
    }
}
extension LessonListViewController {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.3
        animation.values = [25.0, 10.0, 25.0, 10.0, 0.0]
        self.bottomSheet?.view.layer.add(animation, forKey: "shake")
    }
}
