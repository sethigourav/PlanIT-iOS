//
//  CustomPopUp.swift
//  PLAN-IT
//
//  Created by KiwiTech on 17/10/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
protocol CustomPopUpDelegate: AnyObject {
    func dismissControllerToProceed()
}
class CustomPopUp: BaseViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var customPopUpBtn: UIButton!
    weak var delegate: CustomPopUpDelegate?
    var isForRetry = false
    var isForDeactivate = false
    var isFromLibrary = false
    var isForError = false
    var errorText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.descriptionLabel.setLineSpacing(lineSpacing: 7.0, lineHeightMultiple: 0.0, alignment: .left)
        customPopUpBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        customPopUpBtn.layer.cornerRadius = 8
        customPopUpBtn.layer.masksToBounds = true
        yesBtn.layer.maskedCorners = [.layerMaxXMaxYCorner]
        yesBtn.layer.cornerRadius = 8
        yesBtn.layer.masksToBounds = true
        cancelBtn.layer.maskedCorners = [.layerMinXMaxYCorner]
        cancelBtn.layer.cornerRadius = 8
        cancelBtn.layer.masksToBounds = true
    }
    func setUpUI() {
        if isForRetry || isForError {
            self.titleLabel.text = isForError ? .error : .connectionError
            self.descriptionLabel.text = isForError ? (errorText ?? "") : .connectionErrorDesc
            self.cancelBtn.isHidden = true
            self.yesBtn.isHidden = true
            self.customPopUpBtn.isHidden = false
        } else {
            self.titleLabel.text = isFromLibrary ? .removeLibrary : isForDeactivate ? .removeAccount : .signOut
            self.descriptionLabel.text = isFromLibrary ? .removeThisLesson : isForDeactivate ? .removeAccountText : .signOutDesc
            cancelBtn.setTitle(isFromLibrary ? .noOption : .cancel, for: .normal)
            yesBtn.setTitle(isForDeactivate ? .deactivate : .yesOption, for: .normal)
            self.cancelBtn.isHidden = false
            self.yesBtn.isHidden = false
            self.customPopUpBtn.isHidden = true
        }
    }
    @IBAction func customPopUpBtnAction(_ sender: UIButton) {
        switch sender.tag {
        case 100, 200: //yes Button
            self.delegate?.dismissControllerToProceed()
            self.dismiss(animated: false, completion: nil)
        case 300://cancel Button
            self.dismiss(animated: false, completion: nil)
        default:
            break
        }
    }
}
