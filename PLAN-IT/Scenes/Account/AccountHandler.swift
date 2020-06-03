//
//  AccountHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 19/11/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
import MessageUI
extension AccountViewController: CustomPopUpDelegate {
    func dismissControllerToProceed() {
        if !checkConnectivity() {
            self.showLoader()
            self.isForDeactivate ? interactor?.deActivateLinkedAccount() : interactor?.logout()
        }
    }
}
extension AccountViewController: MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([supportEmail])
        mailComposerVC.setSubject(.supportSubject)
        return mailComposerVC
    }
    func showSendMailErrorAlert() {
        print("Could Not Send Email!!!")
    }
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
extension AccountViewController: ReferencePopUpDelegate {
    func dismissControllerToProceed(name: String?, referenceCode: String?) {
        showLoader()
        interactor?.validateReferenceCode(request: Account.Request.init(promoCode: referenceCode))
    }
}
