//
//  AnswerCell.swift
//  PLAN-IT
//
//  Created by KiwiTech on 22/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit

class AnswerCell: UITableViewCell {
    @IBOutlet weak var ansLabel: UILabel!
    @IBOutlet weak var ansImgView: UIImageView!
    @IBOutlet weak var backView: UIView!
    var index = IndexPath.init(row: 0, section: 0)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateUI(obj: Question?) {
       ansLabel.text = obj?.options?[index.row].answer
        if let isSelected = obj?.options?[index.row].isSelected, isSelected {
            backView.backgroundColor = UIColor(name: .selectedCellColor)
            ansLabel.textColor = UIColor(name: .defaultColor)
            if let isTicked = obj?.isTick, isTicked {
                ansImgView.image = UIImage(named: .iconGreentick)
            } else {
                switch index.row {
                case 0 :
                    ansImgView.image = UIImage(named: .iconAgreeSel)
                case 1 :
                    ansImgView.image = UIImage(named: .iconAgree2Sel)
                case 2 :
                    ansImgView.image = UIImage(named: .iconNotAgreeSel)
                case 3 :
                    ansImgView.image = UIImage(named: .iconNotAgree2Sel)
                default:
                    ansImgView.image = UIImage(named: .iconGreentick)
                }
            }
        } else {
            backView.backgroundColor = .clear
            ansLabel.textColor = UIColor(name: .headingColor)
            if let isTicked = obj?.isTick, isTicked {
               ansImgView.image = UIImage(named: .iconBlacktick)
            } else {
                switch index.row {
                case 0 :
                    ansImgView.image = UIImage(named: .iconAgree)
                case 1 :
                    ansImgView.image = UIImage(named: .iconAgree2)
                case 2 :
                    ansImgView.image = UIImage(named: .iconNotAgree)
                case 3 :
                    ansImgView.image = UIImage(named: .iconNotAgree2)
                default:
                    ansImgView.image = UIImage(named: .iconBlacktick)
                }
            }
        }
    }
}
