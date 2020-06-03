//
//  Colors.swift
//  i-Mar
//
//  Created by KiwiTech on 28/06/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    enum ColorName: String {
        case defaultColor,
        errorColor,
        textColor,
        headingColor,
        doneColor,
        selectedCellColor,
        tabbarBackgroundColor,
        lightGreenColor,
        tabbarSelectedColor,
        successColor,
        highlightedText,
        blueCourse,
        brownCourse,
        greenCourse,
        navyCourse,
        peachCourse,
        staticBgColor,
        headingBlurColor,
        searchSelectedCell,
        negitiveValueColor,
        categoryDefaultColor,
        categoryOverspentColor,
        placeHolderColor
    }
    convenience init(name: ColorName) {
        self.init(named: name.rawValue)!
    }
    class func getColorFrom(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(displayP3Red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
