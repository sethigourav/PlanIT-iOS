//
//  BaseViewController.swift
//  PLAN-IT
//
//  Created by KiwiTech on 02/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
class BaseViewController: UIViewController, UIGestureRecognizerDelegate, NVActivityIndicatorViewable {
    var shouldRotate = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftBarButton()
        transparentNavigation()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    func showLoader(view: UIView? = nil) {
        let indicatorType = NVActivityIndicatorType.circleStrokeSpin
        startAnimating(type: indicatorType, color: UIColor(name: .defaultColor))
    }
    func hideLoader(view: UIView? = nil) {
        stopAnimating()
    }
    func checkConnectivity() -> Bool {
        if let manager = NetworkReachabilityManager(), manager.isReachable == false {
            let noInternetView = NoNetworkViewController(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            noInternetView.backgroundColor = .white
            noInternetView.tag = .noNetworkViewTag
            noInternetView.descLabel.setLineSpacing(lineSpacing: 5.0, lineHeightMultiple: 0.0, alignment: .center)
            self.view.addSubview(noInternetView)
            self.view.bringSubviewToFront(noInternetView)
            return true
        }
        self.view.viewWithTag(.noNetworkViewTag)?.removeFromSuperview()
        return false
    }
    func transparentNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    private func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func setLeftBarButton() {
        if let navCtrl = self.navigationController, navCtrl.viewControllers.count > 1 {
            let backBtn = UIBarButtonItem(image: UIImage(named: .iconBack), style: UIBarButtonItem.Style.done, target: self, action: #selector(backTapped))
            self.navigationItem.leftBarButtonItem = backBtn
        } else if self.presentingViewController != nil {
            let backBtn = UIBarButtonItem(image: UIImage(named: .iconBack), style: UIBarButtonItem.Style.done, target: self, action: #selector(backTapped))
            self.navigationItem.leftBarButtonItem = backBtn
        }
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    @objc func backTapped() {
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    // MARK: Enable Disable Buton
    func enableButton(btn: UIButton, label: UILabel?) {
        if let lbl = label {
            lbl.alpha = 1.0
        }
        btn.titleLabel?.alpha = 1.0
        btn.isUserInteractionEnabled = true
        btn.alpha = 1.0
    }
    func disableButton(btn: UIButton, label: UILabel?) {
        if let lbl = label {
            lbl.alpha = 0.2
        }
        btn.titleLabel?.alpha = 0.2
        btn.isUserInteractionEnabled = false
        btn.alpha = 1.0
    }
}
extension BaseViewController {
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if shouldRotate {
            return .allButUpsideDown
        } else {
            return .portrait
        }
    }
}
