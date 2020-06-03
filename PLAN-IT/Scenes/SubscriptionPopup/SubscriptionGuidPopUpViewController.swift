//
//  SubscriptionGuidPopUpViewController.swift
//  PLAN-IT
//
//  Created by KiwiTech on 26/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation

class SubscriptionGuidPopUpViewController: BaseViewController, AppInfo {
    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var pointListStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpLineHeightOfEachLabel()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gotItButton.roundCorners([.bottomLeft, .bottomRight], radius: 7)
    }
    private func setUpLineHeightOfEachLabel() {
        self.pointListStackView.subviews.forEach { (subViewObj) in
            if let lbl = subViewObj as? UILabel {
                var setAppName = lbl.text ?? ""
                if setAppName.contains(String.appName) {
                    let currentAppName = appDisplayName ?? ""
                    setAppName = setAppName.replacingOccurrences(of: String.appName, with: currentAppName)
                    lbl.text = setAppName
                }
                lbl.setLineSpacing(alignment: .left, minimumLineHeight: 24.0)
            }
        }
    }
    @IBAction func gotItAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
