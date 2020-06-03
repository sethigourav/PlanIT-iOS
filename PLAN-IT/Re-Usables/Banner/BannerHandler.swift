//
//  BannerHandler.swift
//  demo
//
//  Created by Ayush on 2/2/19.
//  Copyright © 2019 ayush. All rights reserved.
//

import UIKit
enum BannerType {
    case error,
    noInternet,
    done
}
class BannerHandler: NSObject {
    var swipeUP: UISwipeGestureRecognizer! = UISwipeGestureRecognizer ()
    override init() {
        super.init()
        swipeUP = UISwipeGestureRecognizer(target: self, action: #selector(swipedToUP))
        swipeUP.direction = .up
        bannerContainer?.addGestureRecognizer(swipeUP)
    }
    let bannerContainer: BannerContainer? = {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate, let window = appdelegate.window else {
            return nil
        }
        let bannerContainer = BannerContainer()
        let height = CGFloat(Int.notificationBannerHeight) //+ window.safeAreaInsets.top
        let frame = CGRect(x: 0, y: 0, width: window.frame.width, height: height)
        bannerContainer.frame = frame
        bannerContainer.tag = .notificationBannerTag
        bannerContainer.backBannerTop.constant = -height
        bannerContainer.frontBannerTop.constant = -height
        bannerContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        bannerContainer.backgroundColor = .clear
        window.addSubview(bannerContainer)
        return bannerContainer
    }()
    @objc func swipedToUP() {
        reset()
    }
    func showBanner(with text: String, type: BannerType) {
        banner(text: text, type: type)
    }
    fileprivate func banner(text: String, type: BannerType) {
        guard let container = bannerContainer, let appdelegate = UIApplication.shared.delegate as? AppDelegate, let window = appdelegate.window else {
            return
        }
        if window.viewWithTag(.notificationBannerTag) == nil {
            window.addSubview(container)
        }
        //cancel reset
        //back banner at 0 and hidden
        //front banner at -height
        //front banner at 0
        //back banner setup and shown
        //front banner hidden
        //schedule reset
        let height = CGFloat(Int.notificationBannerHeight)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reset), object: nil)
        container.frontBanner.text = text
        container.frontBanner.type = type
        container.layoutIfNeeded()
        container.frontBanner.isHidden = false
        container.frontBannerTop.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            container.layoutIfNeeded()
        }, completion: { _ in
            container.frontBannerTop.constant = -height
            container.layoutIfNeeded()
            container.frontBanner.isHidden = true
            container.backBanner.text = container.frontBanner.text
            container.backBanner.type = container.frontBanner.type
            container.backBannerTop.constant = 0
            self.perform(#selector(self.reset), with: nil, afterDelay: 2)
        })
    }
    @objc fileprivate func reset() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reset), object: nil)
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate, appdelegate.window != nil else {
            return
        }
        let height = CGFloat(Int.notificationBannerHeight)
        self.bannerContainer?.backBannerTop.constant = -height
        UIView.animate(withDuration: 0.5, animations: {
             self.bannerContainer?.layoutIfNeeded()
        }, completion: { _ in
             self.bannerContainer?.removeFromSuperview()
        })
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reset), object: nil)
    }
}
