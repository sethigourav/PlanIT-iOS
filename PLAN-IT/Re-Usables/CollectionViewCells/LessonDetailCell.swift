//
//  LessonDetailCell.swift
//  PLAN-IT
//
//  Created by KiwiTech on 13/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import HCVimeoVideoExtractor
import CoreData
protocol LessonDetailCellDelegate: AnyObject {
    func downloadVideo(videoObj: Video?, index: Int?)
}
class LessonDetailCell: UICollectionViewCell {
    @IBOutlet weak var videoThumbnailImgView: UIImageView!
    @IBOutlet weak var videoCountLabel: UILabel!
    @IBOutlet weak var playVideoBtn: UIButton!
    @IBOutlet weak var downLoadBtn: UIButton!
    weak var delegate: LessonDetailCellDelegate?
    var videoData = Video()
    var youtubeView: UIView = UIView()
    var index = Int()
    var videoArray: [Video]?
    override func awakeFromNib() {
        super.awakeFromNib()
        videoThumbnailImgView.layer.cornerRadius = 8
        videoThumbnailImgView.clipsToBounds = true
        playVideoBtn.isExclusiveTouch = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        downLoadBtn.isHidden = true
        self.videoCountLabel.isHidden = false
        self.videoCountLabel.textColor = UIColor(name: .headingColor)
    }
    func updateUI(videoObj: Video?, index: Int) {
        if let data = videoObj {
            videoData = data
            self.index = index
            updateLabel(videoId: data.id ?? 0)
        }
    }
    func updateLabel(videoId: Int) {
        let request = NSFetchRequest<DBLessonVideo>(entityName: "DBLessonVideo")
        request.predicate = NSPredicate(format: "videoId == %d", videoId)
        if let result = try? context?.fetch(request), result.count > 0 {
            for videoObj in result {
                if videoObj.videoStatus == VideoDownloadStatus.downloading.rawValue {
                    self.videoCountLabel.text = .downloadInProgress
                    self.videoCountLabel.isHidden = false
                    self.videoCountLabel.textColor = UIColor(name: .defaultColor)
                    downLoadBtn.isHidden = true
                } else   if videoObj.videoStatus == VideoDownloadStatus.downloaded.rawValue {
                    self.videoCountLabel.isHidden = videoArray?.count == 1 ? true : false
                    downLoadBtn.isHidden = true
                } else if videoObj.videoStatus == VideoDownloadStatus.failure.rawValue {
                    downLoadBtn.isHidden = false
                    self.videoCountLabel.isHidden = true
                } else {
                    self.videoCountLabel.text = .videoError
                    self.videoCountLabel.isHidden = false
                    self.videoCountLabel.textColor = UIColor(name: .errorColor)
                    downLoadBtn.isHidden = true
                }
            }
        }
    }
    @IBAction func downLoadBtnAction(_ sender: Any) {
        delegate?.downloadVideo(videoObj: videoData, index: index)
    }
}
