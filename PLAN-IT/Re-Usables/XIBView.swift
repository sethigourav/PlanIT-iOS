//
//  XIBView.swift
//  AmericanEsports-iOS
//
//  Created by KiwiTech on 14/01/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit

@objc class XIBView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    private func xibSetup() {
        guard let view = self.loadViewFromXib() else {
            return
        }
        view.frame = bounds
        view.backgroundColor = UIColor.clear
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    private func loadViewFromXib() -> UIView? {
        let bundle = Bundle.main
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
}
