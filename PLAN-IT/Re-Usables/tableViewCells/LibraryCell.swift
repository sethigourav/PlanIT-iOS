//
//  LibraryCell.swift
//  PLAN-IT
//
//  Created by KiwiTech on 24/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit

class LibraryCell: UITableViewCell {
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var errorImgIcon: UIImageView!
    @IBOutlet weak var lessonCountLabel: UILabel!
    @IBOutlet weak var lessonNameLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
