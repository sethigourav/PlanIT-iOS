//
//  SearchCourseCell.swift
//  PLAN-IT
//
//  Created by KiwiTech on 20/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit

class SearchCourseCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var separatorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
