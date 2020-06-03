//
//  LessonIncompletePopup.swift
//  PLAN-IT
//
//  Created by KiwiTech on 12/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit

class LessonIncompletePopup: UIViewController {
    @IBOutlet weak var popUpView: CustomiseView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descLabel.setLineSpacing(lineSpacing: 7.0, lineHeightMultiple: 0.0, alignment: .left)
        okBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        okBtn.layer.cornerRadius = 8
        okBtn.layer.masksToBounds = true
    }
    @IBAction func okBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
