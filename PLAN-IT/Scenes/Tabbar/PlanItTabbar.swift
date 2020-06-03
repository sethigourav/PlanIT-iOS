//
//  PlanItTabbar.swift
//  PLAN-IT
//
//  Created by KiwiTech on 19/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit

class PlanItTabbar: UITabBar {
    @IBInspectable var height: CGFloat = 0.0
    @IBInspectable var iPhoneXHeight: CGFloat = 0.0

    override func sizeThatFits(_ size: CGSize) -> CGSize {

        var sizeThatFits = super.sizeThatFits(size)

        if height > 0.0 {

            if UIDevice.isiPhoneXVariant() {
                sizeThatFits.height = iPhoneXHeight
            } else {
                sizeThatFits.height = height
            }
        }
        return sizeThatFits
    }
}
