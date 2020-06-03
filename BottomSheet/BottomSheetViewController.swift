//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Kiwitech on 15/02/19.
//  Copyright © 2019 The Safe Group, Inc. All rights reserved.
//

import UIKit

protocol TopViewAnimateDelegate: UIView {
    func animateForLocationPercentage(percentage: CGFloat)
}
protocol BottomSheetDelegate: class {
    func didDismiss(bottomSheet: BottomSheetViewController)
}
protocol BottomSheetChildDelegate: class {
    var bottomSheet: BottomSheetViewController? { get set }
}
class BottomSheetViewController: UIViewController {
    private weak var trackingScrollView: UIScrollView?
    var maxOffset: CGFloat = CGFloat(Int(UIScreen.main.bounds.height * 0.23))
    var midOffset: CGFloat = CGFloat(Int(UIScreen.main.bounds.height * 0.82))
    var minOffset: CGFloat = CGFloat(Int(UIScreen.main.bounds.height * 0.82))
    private let childTopOffset: CGFloat = 0
    private let animationOffset: CGFloat = 0
    private let defaultAnimationDuration: CGFloat = 0.4
    private let backViewAlpha: CGFloat = 1.0
    private var shouldDismissOnBackViewTap = true
    private var shouldShowOnMax = false
    weak var delegate: BottomSheetDelegate?
    weak var topViewAnimateDelegate: TopViewAnimateDelegate?
    private var gesture: UIPanGestureRecognizer?
    private weak var parentVC: UIViewController!
    private weak var childVC: UIViewController!
    private let backView = UIView()

    convenience init(parentViewController: UIViewController, childViewController: UIViewController, trackingScrollView: UIScrollView?, shouldDismissOnBackViewTap: Bool, topViewAnimateDelegateObj: TopViewAnimateDelegate? = nil, maxOffsetOfSheet: CGFloat? = nil, midOffsetOfSheet: CGFloat? = nil, minOffsetOfSheet: CGFloat? = nil, shouldShowOnMax: Bool) {
        self.init()
        self.shouldShowOnMax = shouldShowOnMax
        if let maxOffsetOfSheet = maxOffsetOfSheet {
            self.maxOffset = maxOffsetOfSheet
        }
        if let midOffsetOfSheet = midOffsetOfSheet {
            self.midOffset = midOffsetOfSheet
        }
        if let minOffsetOfSheet = minOffsetOfSheet {
            self.minOffset = minOffsetOfSheet
        }
        self.parentVC = parentViewController
        self.childVC = childViewController
        if let childVCasBottomSheet = childVC as? BottomSheetChildDelegate {
            childVCasBottomSheet.bottomSheet = self
        }
        self.topViewAnimateDelegate = topViewAnimateDelegateObj
        self.shouldDismissOnBackViewTap = shouldDismissOnBackViewTap
        if #available(iOS 11.0, *) {
            if !(minOffset == midOffset && midOffset == maxOffset) {
                let window = UIApplication.shared.keyWindow
                if let topPadding = window?.safeAreaInsets.top {
                    self.maxOffset += topPadding
                }
                if let bottomPadding = window?.safeAreaInsets.bottom {
                    self.midOffset -= bottomPadding
                    self.minOffset -= bottomPadding
                }
            }
        }
        if let trackingScrollView = trackingScrollView {
            self.trackingScrollView = trackingScrollView
            gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
            gesture?.delegate = self
            view.addGestureRecognizer(gesture!)
        }
        self.willMove(toParent: parentViewController)
        parentViewController.view.addSubview(self.view)
        parentViewController.addChild(self)
        self.didMove(toParent: parentViewController)
        let offset: CGFloat = self.midOffset
        self.view.frame = CGRect(x: 0, y: self.getScreenHeight(), width: UIScreen.main.bounds.size.width, height: self.getScreenHeight() - offset)
        self.view.layoutIfNeeded()
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 0
        if #available(iOS 11.0, *) {
            self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        childViewController.willMove(toParent: self)
        self.view.addSubview(childViewController.view)
        self.addChild(childViewController)
        childViewController.didMove(toParent: self)
        childViewController.view.frame = CGRect(x: 0, y: childTopOffset, width: self.view.frame.width, height: self.view.frame.height - childTopOffset)
        childViewController.view.layoutIfNeeded()
        if trackingScrollView == nil {
            childViewController.view.translatesAutoresizingMaskIntoConstraints = false
            childViewController.view.addConstraint(NSLayoutConstraint(
                item: childViewController.view ?? UIView(),
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: self.view.frame.width))
            childViewController.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
            childViewController.view.addConstraint(NSLayoutConstraint(
                item: childViewController.view ?? UIView(),
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: childViewController.view.frame.height))
            self.view.addConstraint(NSLayoutConstraint(
                item: self.view ?? UIView(),
                attribute: .leading,
                relatedBy: .equal,
                toItem: childViewController.view,
                attribute: .leading,
                multiplier: 1.0,
                constant: 0))
            self.view.addConstraint(NSLayoutConstraint(
                item: self.view ?? UIView(),
                attribute: .top,
                relatedBy: .equal,
                toItem: childViewController.view,
                attribute: .top,
                multiplier: 1.0,
                constant: -self.childTopOffset))
            childViewController.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
            childViewController.view.frame = CGRect(x: 0, y: childTopOffset, width: self.view.frame.width, height: childViewController.view.frame.height)
            var rect = self.view.frame
            rect.size.height = childViewController.view.frame.height + childTopOffset
            self.view.frame = rect
        }
//        self.shouldShowOnMax ? initializeBackView() : nil
        self.showOnParent()
    }
    class func initialize(
        parentViewController: UIViewController,
        childViewController: UIViewController,
        trackingScrollView: UIScrollView?,
        shouldDismissOnBackViewTap: Bool = true,
        topViewAnimateDelegateObj: TopViewAnimateDelegate? = nil, maxOffsetOfSheet: CGFloat? = nil, midOffsetOfSheet: CGFloat? = nil, minOffsetOfSheet: CGFloat? = nil, shouldShowOnMax: Bool = false) -> BottomSheetViewController {
        let min = minOffsetOfSheet
        let mid = midOffsetOfSheet
        let max = maxOffsetOfSheet
        let scroll = trackingScrollView
        let dismiss = shouldDismissOnBackViewTap
        let delegate = topViewAnimateDelegateObj
        let sheet = BottomSheetViewController.init(parentViewController: parentViewController, childViewController: childViewController, trackingScrollView: scroll, shouldDismissOnBackViewTap: dismiss, topViewAnimateDelegateObj: delegate, maxOffsetOfSheet: max, midOffsetOfSheet: mid, minOffsetOfSheet: min, shouldShowOnMax: shouldShowOnMax)
        sheet.maxOffset = sheet.midOffset
        return sheet
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if trackingScrollView != nil {
//            registerKeyboardNotifications()
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        unregisterKeyboardNotifications()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animateBackView()
    }
    private func initializeBackView() {
        backView.frame = CGRect(x: 0, y: 0, width: self.parentVC.view.frame.width, height: self.parentVC.view.frame.height)
        backView.alpha = 0
        backView.backgroundColor = .black
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.backViewTapped))
        backView.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.backViewTapped))
        swipeGesture.direction = .down
        backView.addGestureRecognizer(swipeGesture)
        swipeGesture.require(toFail: tapGesture)
        self.parentVC.view.insertSubview(backView, belowSubview: self.view)
        if let topViewAnimateDelegate = topViewAnimateDelegate {
            self.parentVC.view.insertSubview(topViewAnimateDelegate, belowSubview: self.view)
        }
    }
    private func animateBackView() {
        let minAlpha: CGFloat = 0.0
        let maxAlpha: CGFloat = 0.8
        if self.view.frame.minY >= self.midOffset && self.view.frame.minY != self.maxOffset {
            if trackingScrollView != nil {
                self.backView.isUserInteractionEnabled = false
            } else {
                self.backView.isUserInteractionEnabled = true
            }
            self.backView.alpha = maxAlpha
            if let topViewAnimateDelegate = topViewAnimateDelegate {
                topViewAnimateDelegate.animateForLocationPercentage(percentage: 100)
            }
        } else if self.view.frame.minY <= self.maxOffset {
            self.backView.isUserInteractionEnabled = true
            self.backView.alpha = maxAlpha
            if let topViewAnimateDelegate = topViewAnimateDelegate {
                topViewAnimateDelegate.animateForLocationPercentage(percentage: 0)
            }
        } else {
            self.backView.isUserInteractionEnabled = true
            let alphaDif = maxAlpha - minAlpha
            let diff: CGFloat = midOffset - maxOffset
            let perc = (self.view.frame.minY - maxOffset) / diff * 100
            self.backView.alpha = (maxAlpha + minAlpha) - ((alphaDif * perc / 100) + minAlpha)
            if let topViewAnimateDelegate = topViewAnimateDelegate {
                topViewAnimateDelegate.animateForLocationPercentage(percentage: perc)
            }
        }
        if let topViewAnimateDelegate = topViewAnimateDelegate {
            topViewAnimateDelegate.frame = CGRect.init(x: 0, y: self.view.frame.minY - topViewAnimateDelegate.frame.height, width: topViewAnimateDelegate.frame.width, height: topViewAnimateDelegate.frame.height)
        }
    }
    private func showOnParent() {
        if trackingScrollView != nil {
            //backView.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                let offset: CGFloat = self.shouldShowOnMax ? self.maxOffset : self.minOffset
                self.view.frame = CGRect(x: 0, y: offset, width: UIScreen.main.bounds.size.width, height: self.getScreenHeight() - offset)
                if let topViewAnimateDelegate = self.topViewAnimateDelegate {
                    topViewAnimateDelegate.frame = CGRect.init(x: 0, y: offset - topViewAnimateDelegate.frame.height, width: topViewAnimateDelegate.frame.width, height: topViewAnimateDelegate.frame.height)
                }
                self.backView.alpha = self.backViewAlpha
            }, completion: { (_) in
                self.backView.isHidden = false
                self.animateBackView()
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.backView.alpha = self.backViewAlpha
                let yyy = self.getScreenHeight() - self.view.frame.height
                self.view.frame = CGRect(x: 0, y: yyy, width: UIScreen.main.bounds.size.width, height: self.view.frame.height)
                if let topViewAnimateDelegate = self.topViewAnimateDelegate {
                    topViewAnimateDelegate.frame = CGRect.init(x: 0, y: yyy - topViewAnimateDelegate.frame.height, width: topViewAnimateDelegate.frame.width, height: topViewAnimateDelegate.frame.height)
                }
            }, completion: { (_) in
            })
        }
    }
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BottomSheetViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        self.goToTop(direction: 0)
    }
    @objc func backViewTapped(recognizer: UIGestureRecognizer) {
        if shouldDismissOnBackViewTap == false { // || self.view.frame.minY <= self.maxOffset {
            return
        }
        self.removeBottomSheet()
    }
    func removeBottomSheet() {
        goToExtremeDown()
        UIView.animate(withDuration: TimeInterval(self.defaultAnimationDuration), animations: {
            self.backView.alpha = 0
        }, completion: { (_) in
            self.delegate?.didDismiss(bottomSheet: self)
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.backView.removeFromSuperview()
        })
    }
    private func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height - self.parentVC.view.frame.origin.y
    }
    public func isOnMax() -> Bool {
        return self.view.frame.minY == self.maxOffset
    }
    public func isOnMid() -> Bool {
        return self.view.frame.minY == self.midOffset
    }
    public func isOnMin() -> Bool {
        return self.view.frame.minY == self.minOffset
    }
    public func goToTop(direction: CGFloat? = nil) {
        self.goTo(yPosition: direction ?? self.maxOffset, direction: direction ?? 0, isMovingUp: true)
        trackingScrollView?.isScrollEnabled = true
    }
    public func goToMid(direction: CGFloat? = nil) {
        if direction != nil {
            self.goTo(yPosition: self.midOffset, direction: direction ?? 0, isMovingUp: self.view.frame.minY > self.midOffset)
        } else {
            self.goTo(yPosition: self.midOffset, direction: direction ?? 0)
        }
        trackingScrollView?.isScrollEnabled = false
    }
    public func goToExtremeDown() {
        UIView.animate(withDuration: TimeInterval(self.defaultAnimationDuration), animations: {
            var rect = self.view.frame
            rect.origin.y = self.getScreenHeight()
            self.view.frame = rect
            self.view.layoutIfNeeded()
        }, completion: { (_) in

        })
    }
    private func goTo(yPosition: CGFloat, direction: CGFloat, isMovingUp: Bool? = nil) {
        if self.view.frame.minY == yPosition {
            return
        }
        if isMovingUp == nil {
            var rect = self.view.frame
            UIView.animate(withDuration: TimeInterval(self.defaultAnimationDuration), animations: {
                rect.origin.y = yPosition
                rect.size.height = self.getScreenHeight() - yPosition
                self.view.frame = rect
                self.view.layoutIfNeeded()
            }, completion: { (_) in
            })
            return
        }
        let yPoints = (self.view.frame.origin.y - yPosition) > 0 ? self.view.frame.origin.y - yPosition : (self.view.frame.origin.y - yPosition) * -1
        var velocity = direction != 0 ? yPoints / direction : defaultAnimationDuration
        velocity < 0 ? velocity *= -1 : ()
        var rect = self.view.frame
        let animatedY = isMovingUp ?? false ? yPosition - animationOffset : yPosition + animationOffset
        var shouldUseCurrentAnimationSpeed = false
        if velocity <= defaultAnimationDuration {
            shouldUseCurrentAnimationSpeed = true
        } else {
            velocity = defaultAnimationDuration
        }
        UIView.animateKeyframes(withDuration: TimeInterval(velocity), delay: 0, options: shouldUseCurrentAnimationSpeed ? .beginFromCurrentState : .allowUserInteraction, animations: {
            rect.origin.y = animatedY
            rect.size.height = self.getScreenHeight() - animatedY
            self.view.frame = rect
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            UIView.animate(withDuration: TimeInterval(self.defaultAnimationDuration), animations: {
                rect.origin.y = yPosition
                rect.size.height = self.getScreenHeight() - yPosition
                self.view.frame = rect
                self.view.layoutIfNeeded()
            }, completion: { (_) in
            })
        })
    }
}
extension BottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("shouldRecognizeSimultaneouslyWith")
        let gesture = (gestureRecognizer as? UIPanGestureRecognizer)
        guard gesture?.state != .some(.failed), !(otherGestureRecognizer.view is UITextField) else {
            return false
        }
        let direction = gesture?.velocity(in: view).y
        let ymin = view.frame.minY
        if let trackingScrollView = trackingScrollView {
            if (ymin == self.maxOffset && trackingScrollView.contentOffset.y == 0 && direction ?? CGFloat(0) >= CGFloat(0)) || (ymin <= self.minOffset && ymin != self.maxOffset) {
                self.view.endEditing(true)
                trackingScrollView.isScrollEnabled = false
                print("isScrollEnabled = false")
            } else {
                trackingScrollView.isScrollEnabled = true
                print("isScrollEnabled = true")
            }
        }
        return false
    }
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        print("panGesture(recognizer")
        guard let trackingScrollView = trackingScrollView else {
            return
        }

        if minOffset == midOffset && midOffset == maxOffset {
            return
        }

        let translation = recognizer.translation(in: self.view)
        let y11 = self.view.frame.minY
        var frame = CGRect.init(x: 0, y: y11 + translation.y, width: self.view.frame.width, height: self.view.frame.height + translation.y * -1)
        let maxY = self.maxOffset - animationOffset
        let minY = self.minOffset + animationOffset
        if frame.origin.y < maxY {
            frame.origin.y = maxY
            frame.size.height = self.getScreenHeight() - maxY
        } else if frame.origin.y > minY {
            frame.origin.y = minY
            frame.size.height = self.getScreenHeight() - minY
        }
        self.view.frame = frame
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        if recognizer.state == .ended {
            let y12 = self.view.frame.minY
            let direction = recognizer.velocity(in: view).y
            if y12 < self.maxOffset {
                self.goTo(yPosition: self.maxOffset, direction: direction)
                trackingScrollView.isScrollEnabled = true
            } else if y12 > self.minOffset {
                self.goTo(yPosition: self.minOffset, direction: direction)
            } else {
                if direction > 0 {
                    if y12 > self.midOffset {
                        self.goTo(yPosition: self.minOffset, direction: direction, isMovingUp: false)
                    } else {
                        self.goTo(yPosition: self.midOffset, direction: direction, isMovingUp: false)
                    }
                } else {
                    if y12 < self.midOffset {
                        self.goTo(yPosition: self.maxOffset, direction: direction, isMovingUp: true)
                        trackingScrollView.isScrollEnabled = true
                    } else {
                        self.goTo(yPosition: self.midOffset, direction: direction, isMovingUp: true)
                    }
                }
            }
        }
    }
}
