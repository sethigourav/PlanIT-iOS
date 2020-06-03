//
//  OfflineReadPopup.swift
//  PLAN-IT
//
//  Created by KiwiTech on 27/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
protocol OfflineReadDelegate: AnyObject {
    func dismissControllerToSaveData(isSaveToLibraryTapped: Bool, isVideoAdded: Bool)
}
class OfflineReadPopup: BaseViewController {
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var switchBtn: UIButton!
    @IBOutlet weak var saveToLibraryBtn: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var popUpView: CustomiseView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var includeVideoLabel: UILabel!
    weak var delegate: OfflineReadDelegate?
    var isVideoAdded = true
    var lessonObj = Lesson()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descLabel.setLineSpacing(lineSpacing: 5.0, lineHeightMultiple: 0.0, alignment: .left)
        saveToLibraryBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        saveToLibraryBtn.layer.cornerRadius = 8
        saveToLibraryBtn.layer.masksToBounds = true
        switchBtn.isSelected = true
        switchBtn.setImage(UIImage(named: .radioSelected), for: .selected)
        switchBtn.setImage(UIImage(named: .radioGray), for: .normal)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissController))
        containerView.addGestureRecognizer(tap)
        if lessonObj.lessonVideo?.count ?? 0 > 0 {
            topConstraint.constant = 71
            includeVideoLabel.isHidden = false
            switchBtn.isHidden = false
        } else {
            topConstraint.constant = 25
            includeVideoLabel.isHidden = true
            switchBtn.isHidden = true
        }
    }
    @objc func dismissController() {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func saveToLibrarayBtnAction(_ sender: UIButton) {
        delegate?.dismissControllerToSaveData(isSaveToLibraryTapped: !sender.isSelected ? true : false, isVideoAdded: isVideoAdded)
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func switchBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isVideoAdded = sender.isSelected ? true : false
    }
}
