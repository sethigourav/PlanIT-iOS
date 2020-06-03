//
//  BannerView.swift
//  demo
//
//  Created by Ayush on 2/2/19.
//  Copyright © 2019 ayush. All rights reserved.
//

import UIKit
class BannerView: XIBView {
    var text: String? {
        get {
            return textLabel.text
        }
        set {
            textLabel.text = newValue
        }
    }
    var type: BannerType? {
        didSet {
            guard let type = type else {
                return
            }
            switch type {
            case .error:
                image.image = UIImage(named: .iconError)
                backView.backgroundColor = UIColor(name: .errorColor)
            case .done:
                image.image = UIImage(named: .iconSuccess)
                backView.backgroundColor = UIColor(name: .successColor)
            case .noInternet:
                image.image = UIImage(named: .network)
                backView.backgroundColor = UIColor(name: .errorColor)
            }
        }
    }
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var image: UIImageView!
    @IBOutlet var backView: UIView!
}
