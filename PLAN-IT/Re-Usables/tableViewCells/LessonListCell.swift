//
//  LessonListCell.swift
//  PLAN-IT
//
//  Created by KiwiTech on 08/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit

class LessonListCell: UITableViewCell {
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var lessonNumberLabel: UILabel!
    @IBOutlet weak var lessonNameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var contentTypeLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    var isPlaying = false
    var isCompleted = false
    var index = Int()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagLabel.layer.cornerRadius = 3
        tagLabel.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let isSubscribed = AppStateManager.shared.user?.isSubscribed ?? false || AppStateManager.shared.user?.isPromoSubscribed ?? false
        if isSubscribed {
            if isPlaying || isCompleted {
                lessonNumberLabel.textColor = UIColor(name: .headingColor)
                lessonNameLabel.textColor = UIColor(name: .headingColor)
                contentTypeLabel.textColor = UIColor(name: .headingColor)
            } else {
                lessonNumberLabel.textColor = UIColor(name: .headingBlurColor)
                lessonNameLabel.textColor = UIColor(name: .headingBlurColor)
                contentTypeLabel.textColor = UIColor(name: .headingBlurColor)
            }
        } else {
            if isCompleted || self.index == 0 {
                lessonNumberLabel.textColor = UIColor(name: .headingColor)
                lessonNameLabel.textColor = UIColor(name: .headingColor)
                contentTypeLabel.textColor = UIColor(name: .headingColor)
            } else {
                lessonNumberLabel.textColor = UIColor(name: .headingBlurColor)
                lessonNameLabel.textColor = UIColor(name: .headingBlurColor)
                contentTypeLabel.textColor = UIColor(name: .headingBlurColor)
            }
        }
    }
    func updateUI(data: [Lesson]?, index: Int) {
        self.index = index
        var count = 0
        self.separatorLabel.isHidden = (index + 1) == (data?.count ?? 0) ? true : false
        var playingRow = Int()
        for (row, value) in data?.enumerated() ?? [].enumerated() where !(value.isCompleted ?? true) {
            playingRow = row - 1
            break
        }
        if let lessonObj = data?[index] {
            if let isRead = lessonObj.isCompleted {
                for value in data ?? [] where (value.isCompleted ?? true) {
                    count += 1
                }
                if index == 0 {
                    tagLabel.isHidden = isRead ? true : false
                    leadingConstraint.constant = 18
                    imgView.image = isRead ? UIImage(named: .iconTick) : UIImage(named: .iconPlay)
                    let isNotSubscribed = !(AppStateManager.shared.user?.isSubscribed ?? true) && !(AppStateManager.shared.user?.isPromoSubscribed ?? true)
                    self.contentView.backgroundColor = isRead ? (data?.count == 1 ? UIColor(name: .selectedCellColor) : (count == 1 && isNotSubscribed) ? UIColor(name: .selectedCellColor) : .white) : UIColor(name: .selectedCellColor)
                } else {
                    tagLabel.isHidden = true
                    if AppStateManager.shared.user?.isSubscribed ?? false || AppStateManager.shared.user?.isPromoSubscribed ?? false {
                        if lessonObj.isPlaying ?? false && !isRead {
                            leadingConstraint.constant = 18
                            imgView.image = UIImage(named: .iconPlay)
                            self.contentView.backgroundColor = UIColor(name: .selectedCellColor)
                        } else {
                            leadingConstraint.constant = isRead ? 18 : 0
                            imgView.image = isRead ? UIImage(named: .iconTick) : nil
                            self.contentView.backgroundColor = isRead ? (data?.count == (index + 1) ? UIColor(name: .selectedCellColor) : .white) : .white
                        }
                    } else {
                        leadingConstraint.constant = 18
                        imgView.image = isRead ? UIImage(named: .iconTick) : UIImage(named: .iconLock)
                        self.contentView.backgroundColor = (playingRow == index) ? UIColor(name: .selectedCellColor) : data?.count == (index + 1) && isRead ? UIColor(name: .selectedCellColor) : .white
                    }
                }
            }
            isPlaying = lessonObj.isPlaying ?? false
            isCompleted = lessonObj.isCompleted ?? false
            lessonNumberLabel.text = String(format: "Lesson %d", index + 1)
            lessonNameLabel.text = lessonObj.title
            contentTypeLabel.text = (lessonObj.lessonVideo?.count ?? 0) > 0  ? .readVideo : .read
        }
    }
}
