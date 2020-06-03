//
//  LessonDetailCollectionHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 13/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import HCVimeoVideoExtractor
import CoreData
extension LessonDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessonObj.lessonVideo?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LessonDetailCell.identifier, for: indexPath) as? LessonDetailCell {
            cell.delegate = self
            cell.videoArray = lessonObj.lessonVideo
            let obj = lessonObj.lessonVideo?[indexPath.item]
            cell.videoCountLabel.text = String(format: "Video %d", indexPath.row + 1)
            cell.videoCountLabel.isHidden = (lessonObj.lessonVideo?.count ?? 0) > 1 ? false : true
            if isFromLibrary {
                cell.videoThumbnailImgView.image = AppUtils.image(name: URL(string: obj?.thumbnail ?? "")?.lastPathComponent ?? "" )
            } else {
                cell.updateUI(videoObj: obj, index: indexPath.row)
                cell.videoThumbnailImgView.sd_setImage(with: URL(string: obj?.thumbnail ?? "")) { (image, _, _, _) in
                    cell.videoThumbnailImgView.image = image
                }
            }
            cell.playVideoBtn.tag = indexPath.item
            cell.playVideoBtn.removeTarget(self, action: #selector(playVideoBtnAction), for: .touchUpInside)
            cell.playVideoBtn.addTarget(self, action: #selector(playVideoBtnAction), for: .touchUpInside)
            return cell
        }
        return UICollectionViewCell()
    }
    @objc func playVideoBtnAction(_ sender: UIButton) {
        removePlayer()
        sender.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            sender.isUserInteractionEnabled = true
        }
        let obj = lessonObj.lessonVideo?[sender.tag]
        let index = IndexPath.init(item: sender.tag, section: 0)
        if let cell = collectionView.cellForItem(at: index) as? LessonDetailCell {
            if let videoURL = URL(string: obj?.urlLink ?? "") {
                if videoURL.isYoutubeURL {
                    self.player.showYoutube(from: cell.contentView, videoId: AppUtils.youtubeId(from: obj?.urlLink ?? "") ?? "", statusUpdates: {[weak self] status in
                        switch status {
                        case .stopped:
                            self?.hideLoader()
                            self?.player.removePlayer()
                        case .buffering:
                            self?.showLoader()
                        case .playing:
                            self?.hideLoader()
                        }
                    })
                } else if videoURL.host == "vimeo.com" {
                    VideoExtractor.main.getVimeoDownloadURL(with: obj?.urlLink ?? "") { (url, error) in
                        if let err = error {
                            print("Error = \(err.localizedDescription)")
                            return
                        }
                        self.playAVplayer(url: url!)
                    }
                } else {
                    if let video = obj?.video, video.count > 0 {
                        playAVplayer(url: URL(string: video)!)
                    } else {
                        playAVplayer(url: videoURL)
                    }
                }
            }
        }
    }
    func playAVplayer(url: URL) {
        let documentsFolder = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let videoURL = documentsFolder?.appendingPathComponent(url.lastPathComponent)
        self.avPlayer = AVPlayer(url: isFromLibrary ? videoURL! : url)
        self.avplayerController.allowsPictureInPicturePlayback = false
        self.avplayerController.delegate = self
        DispatchQueue.main.async {
            self.avplayerController.player = self.avPlayer
            if self.navigationController?.presentedViewController == nil {
                self.navigationController?.present(self.avplayerController, animated: true, completion: {
                    self.avplayerController.player?.play()
                })
            }
        }
    }
}
extension LessonDetailViewController: AVPlayerViewControllerDelegate {
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.avplayerController.dismiss(animated: true, completion: nil)
    }
}
extension LessonDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 && lessonObj.lessonVideo?.count == 1 {
            return CGSize(width: collectionView.frame.size.width - 40, height: collectionView.frame.size.height)
        }
        return CGSize(width: collectionView.frame.size.width - 60, height: collectionView.frame.size.height)
    }
}
extension LessonDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let midX: CGFloat = scrollView.bounds.midX
            let midY: CGFloat = scrollView.bounds.midY
            let point: CGPoint = CGPoint(x: midX, y: midY)
            guard let indexPath: IndexPath = collectionView.indexPathForItem(at: point) else {
                if let index = collectionView.indexPathForItem(at: CGPoint(x: midX - 12, y: midY)) {
                    self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                }
                return
            }
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else {
            return
        }
        if scrollView == collectionView {
            let midX: CGFloat = scrollView.bounds.midX
            let midY: CGFloat = scrollView.bounds.midY
            let point: CGPoint = CGPoint(x: midX, y: midY)
            guard let indexPath: IndexPath = collectionView.indexPathForItem(at: point) else {
                if let index = collectionView.indexPathForItem(at: CGPoint(x: midX - 12, y: midY)) {
                    self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                }
                return
            }
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
extension LessonDetailViewController {
    func retrieveData() {
        let request = NSFetchRequest<DBLesson>(entityName: "DBLesson")
        if overSpentDescription?.count ?? 0 > 0 {
            request.predicate = NSPredicate(format: "budgetCategoryId == %d", budgetCategory?.categoryId ?? 0)
        } else {
            request.predicate = NSPredicate(format: "lessonId == %d", lessonObj.id ?? 0)
        }
        if let result = try? context?.fetch(request) {
            if result.count > 0 {
                for data in result {
                    if (overSpentDescription?.count ?? 0) > 0 {
                        let dict = try? JSONSerialization.jsonObject(with: data.budgetCategory! as Data, options: [])
                        let modelObj = (try? BudgetCategory.objectFrom(json: dict ?? [])) ?? BudgetCategory()
                        let overSpent = data.overSpentPercent
                        if checkForUpdatedBudget(data: modelObj) || ((overSpentPercent ?? 0) > 125.0 && overSpent <= 125.0 || (overSpentPercent ?? 0) <= 125.0 && overSpent > 125.0 ) {
                            isLessonUpdated = true
                            savedBtn.isHidden = true
                            saveToLibraryBtn.isHidden = false
                        } else {
                            isLessonUpdated = false
                            savedBtn.isHidden = false
                            saveToLibraryBtn.isHidden = true
                        }
                    } else {
                        let dict = try? JSONSerialization.jsonObject(with: data.lessonValue! as Data, options: [])
                        let modelObj = (try? Lesson.objectFrom(json: dict ?? [])) ?? Lesson()
                        if checkForUpdatedLesson(data: modelObj) {
                            isLessonUpdated = true
                            savedBtn.isHidden = true
                            saveToLibraryBtn.isHidden = false
                        } else {
                            isLessonUpdated = false
                            savedBtn.isHidden = false
                            saveToLibraryBtn.isHidden = true
                        }
                    }
                }
            } else {
                savedBtn.isHidden = true
                saveToLibraryBtn.isHidden = false
            }
        }
    }
    func saveData() {
        if let value = try? JSONSerialization.data(withJSONObject: lessonObj.toParams() ?? [String: Any](), options: .prettyPrinted), let budgetValue = try? JSONSerialization.data(withJSONObject: budgetCategory?.toParams() ?? [String: Any](), options: .prettyPrinted) {
            guard let context = context else {
                return
            }
            guard let entity = NSEntityDescription.entity(forEntityName: "DBLesson", in: context), let videoEntity = NSEntityDescription.entity(forEntityName: "DBLessonVideo", in: context) else {
                return
            }
            let lessonValue = NSManagedObject(entity: entity, insertInto: context) as? DBLesson
            lessonValue?.index = Int64(self.lessonId ?? 0)
            lessonValue?.lessonId = Int64(lessonObj.id ?? 0)
            lessonValue?.lessonValue = value as NSData
            lessonValue?.courseName = courseName ?? ""
            lessonValue?.overSpentDescription = overSpentDescription ?? ""
            lessonValue?.budgetCategory = budgetValue as NSData
            lessonValue?.budgetCategoryId = Int64(budgetCategory?.categoryId ?? 0)
            lessonValue?.overSpentPercent = overSpentPercent ?? 0
            lessonValue?.lessonSavedDate = Date()
            if self.isVideoAdded {
                for videoObj in lessonObj.lessonVideo ?? [] {
                    let videoValue = NSManagedObject(entity: videoEntity, insertInto: context) as? DBLessonVideo
                    videoValue?.videoId = Int64(videoObj.id ?? 0)
                    videoValue?.videoUrl = ""
                    videoValue?.video = ""
                    videoValue?.videoStatus = VideoDownloadStatus.downloading.rawValue
                    videoValue?.originalUrl = (videoObj.urlLink?.count ?? 0 > 0 ? videoObj.urlLink ?? "" : videoObj.video ?? "")
                    videoValue?.videoToLesson = lessonValue
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            do {
                try context.save()
                AppUtils.showBanner(with: "The lesson was saved to the library.", type: .done)
            } catch {
                AppUtils.showBanner(with: "The lesson could not be saved because of an error.")
            }
        }
    }
    func updateData() {
        if let value = try? JSONSerialization.data(withJSONObject: lessonObj.toParams() ?? [String: Any](), options: .prettyPrinted), let budgetValue = try? JSONSerialization.data(withJSONObject: budgetCategory?.toParams() ?? [String: Any](), options: .prettyPrinted) {
            let request = NSFetchRequest<DBLesson>(entityName: "DBLesson")
            if overSpentDescription?.count ?? 0 > 0 {
                request.predicate = NSPredicate(format: "budgetCategoryId == %d", budgetCategory?.categoryId ?? 0)
            } else {
                request.predicate = NSPredicate(format: "lessonId == %d", lessonObj.id ?? 0)
            }
            let result = try? context?.fetch(request)
            let objectUpdate = result?[0]
            objectUpdate?.index = Int64(self.lessonId ?? 0)
            objectUpdate?.lessonId = Int64(lessonObj.id ?? 0)
            objectUpdate?.lessonValue = value as NSData
            objectUpdate?.courseName = courseName ?? ""
            objectUpdate?.overSpentDescription = overSpentDescription ?? ""
            objectUpdate?.budgetCategory = budgetValue as NSData
            objectUpdate?.budgetCategoryId = Int64(budgetCategory?.categoryId ?? 0)
            objectUpdate?.overSpentPercent = overSpentPercent ?? 0
            objectUpdate?.lessonSavedDate = Date()
            //insert video
            for videoObj in lessonObj.lessonVideo ?? [] {
                let videoExist = objectUpdate?.lessonToVideo?.filter {$0.videoId == Int64(videoObj.id ?? 0)}
                if  !(videoExist?.isEmpty ?? true) {
                    print("exist")
                } else {
                    if isVideoAdded {
                       saveVideo(videoObj: videoObj, objectUpdate: objectUpdate)
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            //delete or replace video
            for videoDelete in objectUpdate?.lessonToVideo ?? [] {
                let videoExist = lessonObj.lessonVideo?.filter {$0.id == Int(videoDelete.videoId)}
                if  !(videoExist?.isEmpty ?? true) {
                    print("exist")
                } else {
                    let request = NSFetchRequest<DBLessonVideo>(entityName: "DBLessonVideo")
                    request.predicate = NSPredicate(format: "videoId == %d", videoDelete.videoId)
                    if let result = try? context?.fetch(request) {
                        let objectToDelete = result[0]
                        if let videoUrl = (objectToDelete.videoUrl?.count ?? 0) > 0 ?  objectToDelete.videoUrl : objectToDelete.video, let thumbnail = objectToDelete.thumbnailUrl {
                            try? AppUtils.remove(file: URL(string: videoUrl)!)
                            try? AppUtils.remove(file: URL(string: thumbnail)!)
                        }
                        context?.delete(objectToDelete)
                        do {
                            try context?.save()
                        } catch {
                            AppUtils.showBanner(with: "The lesson could not be deleted because of some error.")
                        }
                    }
                }
            }
            do {
                try context?.save()
                AppUtils.showBanner(with: "The lesson was updated to the library.", type: .done)
            } catch {
                AppUtils.showBanner(with: "The lesson could not be updated because of an error.")
            }
        }
    }
    func saveVideo(videoObj: Video, objectUpdate: DBLesson?) {
        guard let context = context else {
            return
        }
        guard let videoEntity = NSEntityDescription.entity(forEntityName: "DBLessonVideo", in: context) else {
            return
        }
        let videoValue = NSManagedObject(entity: videoEntity, insertInto: context) as? DBLessonVideo
        let videoURL = URL(string: videoObj.urlLink ?? "")
        if !(videoURL?.isYoutubeURL ?? false || videoURL?.host == "vimeo.com") {
            videoValue?.videoId = Int64(videoObj.id ?? 0)
            videoValue?.videoUrl = videoURL?.isYoutubeURL ?? false || videoURL?.host == "vimeo.com" || videoURL?.host == "fichannels.com" ? videoObj.urlLink :  ""
            videoValue?.video = ""
            videoValue?.videoStatus = VideoDownloadStatus.downloading.rawValue
            videoValue?.originalUrl = (videoObj.urlLink?.count ?? 0 > 0 ? videoObj.urlLink ?? "" : videoObj.video ?? "")
            videoValue?.videoToLesson = objectUpdate
        }
    }
    func removeData() {
        let request = NSFetchRequest<DBLesson>(entityName: "DBLesson")
        if overSpentDescription?.count ?? 0 > 0 {
            request.predicate = NSPredicate(format: "budgetCategoryId == %d", budgetCategory?.categoryId ?? 0)
        } else {
            request.predicate = NSPredicate(format: "lessonId == %d", lessonObj.id ?? 0)
        }
        if let result = try? context?.fetch(request), result.count > 0 {
            let objectToDelete = result[0]
                for videoObj in objectToDelete.lessonToVideo ?? [] {
                    if let videoUrl = (videoObj.videoUrl?.count ?? 0) > 0 ?  videoObj.videoUrl : videoObj.video, let thumbnail = videoObj.thumbnailUrl {
                        try? AppUtils.remove(file: URL(string: videoUrl)!)
                        try? AppUtils.remove(file: URL(string: thumbnail)!)
                    }
                }
                context?.delete(objectToDelete)
            do {
                try context?.save()
                AppUtils.showBanner(with: "Lesson was removed from the library.", type: .done)
                self.navigationController?.popViewController(animated: true)
            } catch {
                AppUtils.showBanner(with: "The lesson could not be removed because of an error.")
            }
        }
    }
    func checkForUpdatedLesson(data: Lesson) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        var serverUpdatedAt = Date()
        var localUpdatedAt = Date()
        if let serverDate = formatter.date(from: lessonObj.updatedAt ?? ""), let localDate = formatter.date(from: data.updatedAt ?? "") {
            serverUpdatedAt = serverDate
            localUpdatedAt = localDate
        }
        return serverUpdatedAt > localUpdatedAt ? true : false
    }
    func checkForUpdatedBudget(data: BudgetCategory) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        var serverUpdatedAt = Date()
        var localUpdatedAt = Date()
        if let serverDate = formatter.date(from: budgetCategory?.categoryUpdatedAt ?? ""), let localDate = formatter.date(from: data.categoryUpdatedAt ?? "") {
            serverUpdatedAt = serverDate
            localUpdatedAt = localDate
        }
        return serverUpdatedAt > localUpdatedAt ? true : false
    }
}
extension LessonDetailViewController: LessonDetailCellDelegate {
    func downloadVideo(videoObj: Video?, index: Int?) {
        let request = NSFetchRequest<DBLessonVideo>(entityName: "DBLessonVideo")
        request.predicate = NSPredicate(format: "videoId == %d", videoObj?.id ?? 0)
        if let result = try? context?.fetch(request), result.count > 0 {
            for video in result where video.videoStatus == VideoDownloadStatus.failure.rawValue {
                video.videoId = Int64(videoObj?.id ?? 0)
                video.videoUrl = ""
                video.video = ""
                video.videoStatus = VideoDownloadStatus.downloading.rawValue
                video.originalUrl = (videoObj?.urlLink?.count ?? 0 > 0 ? videoObj?.urlLink ?? "" : videoObj?.video ?? "")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                do {
                    try context?.save()
                } catch {
                    AppUtils.showBanner(with: "Failed saving!!!!")
                }
            }
        }
        VideoExtractor.main.getDownloadURL(for: videoObj?.urlLink ?? "") {[weak self] (url, error) in
            guard error == nil else {
                let request = NSFetchRequest<DBLessonVideo>(entityName: "DBLessonVideo")
                request.predicate = NSPredicate(format: "videoId == %d", videoObj?.id ?? 0)
                guard let result = try? context?.fetch(request), result.count > 0 else {
                    return
                }
                let objectUpdate = result[0]
                objectUpdate.videoStatus = VideoDownloadStatus.error.rawValue
                try? context!.save()
                DispatchQueue.main.async {
                    AppUtils.showBanner(with: String(format: "Video %d format cannot be downloaded.", (index ?? 0) + 1))
                    self?.collectionView.reloadData()
                }
                return
            }
            self?.downloadVideoLinkAndCreateAsset(Int64(videoObj?.id ?? 0), (url?.absoluteString.count ?? 0 > 0 ? url?.absoluteString ?? "" : videoObj?.video) ?? "") { (filePath, videoId, success) in
                let request = NSFetchRequest<DBLessonVideo>(entityName: "DBLessonVideo")
                request.predicate = NSPredicate(format: "videoId == %d", videoId)
                guard let result = try? context?.fetch(request), result.count > 0 else {
                    return
                }
                let objectUpdate = result[0]
                if success {
                    objectUpdate.video = videoObj?.video?.count ?? 0 > 0 ? filePath?.absoluteString.replacingOccurrences(of: " ", with: "%20") : ""
                    objectUpdate.videoUrl = videoObj?.urlLink?.count ?? 0 > 0 ? filePath?.absoluteString.replacingOccurrences(of: " ", with: "%20") : ""
                    objectUpdate.videoStatus = success ? VideoDownloadStatus.downloaded.rawValue : VideoDownloadStatus.failure.rawValue
                    let ext = ((filePath?.lastPathComponent ?? "").components(separatedBy: ".").first ?? "")
                    let fileName = ext + ".jpg"
                    self?.dowloadImageFromServer(url: URL(string: videoObj?.thumbnail ?? "")!, completion: { (image) in
                        if let thumbnail = image {
                            objectUpdate.thumbnailUrl = try? AppUtils.saveImageInTemp(image: thumbnail, name: fileName).absoluteString
                        }
                    })
                } else {
                    objectUpdate.videoStatus = VideoDownloadStatus.failure.rawValue
                }
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                do {
                    try context!.save()
                } catch {
                    objectUpdate.videoStatus = VideoDownloadStatus.error.rawValue
                    try? context!.save()
                    AppUtils.showBanner(with: String(format: "Video %d format cannot be downloaded.", (index ?? 0) + 1))
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
    }
}
