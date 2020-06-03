//
//  CourseListCell.swift
//  PLAN-IT
//
//  Created by KiwiTech on 02/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
class CourseListCell: UICollectionViewCell {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lessonCountLabel: UILabel!
    @IBOutlet weak var prgressView: UIProgressView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseDescriptionLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    let colors = [UIColor(name: .navyCourse), UIColor(name: .greenCourse), UIColor(name: .peachCourse), UIColor(name: .blueCourse), UIColor(name: .brownCourse)]
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        prgressView.transform = prgressView.transform.scaledBy(x: 1, y: 2)
        prgressView.layer.cornerRadius = prgressView.frame.size.height / 2
        prgressView.clipsToBounds = true
        bottomConstraint.constant = DeviceType.IsIPhone5 ? 10 : 29
        topConstraint.constant = DeviceType.IsIPhone5 ? 10 : 20
        courseNameLabel.font = courseNameLabel.font.withSize(DeviceType.IsIPhone5 ? 20 : 44)
        self.newLabel.layer.cornerRadius = 3
        self.newLabel.layer.borderWidth = 1
        self.newLabel.layer.borderColor = UIColor.white.cgColor
    }
    override func prepareForReuse() {
         super.prepareForReuse()
         self.prgressView.setProgress(0, animated: false)
    }
    func updateUI(index: Int, courses: [Course]?) {
        self.backgroundColor = colors[index % colors.count]
        if let data = courses?[index] {
            self.newLabel.isHidden = checkForNewCourse(data: data) && (data.isNewCourse ?? false) ? false : true
            self.courseNameLabel.text = data.title
            self.courseDescriptionLabel.text = data.description
            if let readlesson = data.readLessonCount, let totalLesson = data.totalLessonCount, readlesson > 0, totalLesson > 0 {
                let percentProgress = Float(Float(readlesson)/Float(totalLesson))
                self.prgressView.setProgress(percentProgress, animated: false)
            }
            if (data.readLessonCount ?? 0) > 0 {
                self.lessonCountLabel.text = (data.totalLessonCount ?? 0) > 1 ? String(format: "%d/%d  LESSONS", data.readLessonCount ?? 0, data.totalLessonCount ?? 0) :  String(format: "%d/%d LESSON", data.readLessonCount ?? 0, data.totalLessonCount ?? 0)
            } else {
                self.lessonCountLabel.text = (data.totalLessonCount ?? 0) > 1 ? String(format: "%d LESSONS", data.totalLessonCount ?? 0) :  String(format: "%d LESSON", data.totalLessonCount ?? 0)
            }
            self.imgView.sd_setImage(with: URL(string: (data.courseThumbnail ?? ""))) { (image, _, _, _) in
                self.imgView.image = image
            }
        }
    }
    func setfont (size: CGFloat) -> UIFont {
        return UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: size) ?? UIFont.systemFont(ofSize: size)
    }
    func checkForNewCourse(data: Course) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        var userCreated = Date()
        var courseCreated = Date()
        if let createdDate = formatter.date(from: AppStateManager.shared.user?.createdAt ?? ""), let modifiedDate = formatter.date(from: data.updatedAt ?? "") {
            userCreated = createdDate
            courseCreated = modifiedDate
        }
        if userCreated > courseCreated {
            return false
        } else {
            return true
        }
    }
}
