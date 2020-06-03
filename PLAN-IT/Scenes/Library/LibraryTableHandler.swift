//
//  LibraryTableHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 24/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
import CoreData
extension LibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LibraryCell.identifier, for: indexPath) as? LibraryCell
        let lessonObj = savedDataArray[indexPath.row]
        cell?.courseNameLabel.text = (lessonObj.overSpentDesc?.count ?? 0) > 0 ? String(format: "Overspent \u{2022} %@", lessonObj.budgetCategory?.categoryName ?? "") : lessonObj.courseName
        cell?.lessonNameLabel.text = (lessonObj.overSpentDesc?.count ?? 0) > 0 ? lessonObj.overSpentDesc?.htmlToString : lessonObj.title
        cell?.lessonCountLabel.text = String(format: "#%d", lessonObj.index ?? 0)
        cell?.separatorLabel.isHidden = savedDataArray.count == (indexPath.row + 1) ? true : false
        cell?.lessonCountLabel.isHidden = (lessonObj.overSpentDesc?.count ?? 0) > 0 ? true : false
        cell?.errorImgIcon.isHidden = (lessonObj.overSpentDesc?.count ?? 0) > 0 ? false : true
        return cell ?? UITableViewCell()
    }
}
extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lessonObj = savedDataArray[indexPath.row]
        if let controller = AppUtils.viewController(with: LessonDetailViewController.identifier, in: .tabbar) as? LessonDetailViewController {
            controller.router?.dataStore?.lessonObj = lessonObj
            controller.courseName = lessonObj.courseName
            controller.overSpentDescription = lessonObj.overSpentDesc
            controller.budgetCategory = lessonObj.budgetCategory
            controller.isFromLibrary = true
            _ = controller.view
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
    }
}
extension LibraryViewController {
    func fetchData() {
        savedDataArray.removeAll()
        let request = NSFetchRequest<DBLesson>(entityName: "DBLesson")
        request.sortDescriptors = [NSSortDescriptor(key: "lessonSavedDate", ascending: false)]
        do {
            if let result = try context?.fetch(request) {
                for data in result {
                    let dict = try JSONSerialization.jsonObject(with: data.lessonValue! as Data, options: [])
                    let modelObj = try? Lesson.objectFrom(json: dict)
                    let budgetDict = try JSONSerialization.jsonObject(with: data.budgetCategory! as Data, options: [])
                    let budgetObj = try? BudgetCategory.objectFrom(json: budgetDict)
                    var lessonObj = Lesson()
                    lessonObj.id = modelObj?.id
                    lessonObj.index = Int(data.index)
                    lessonObj.courseName = data.courseName
                    lessonObj.categoryName = modelObj?.categoryName
                    lessonObj.title = modelObj?.title
                    lessonObj.description = modelObj?.description
                    lessonObj.overSpentDesc = data.overSpentDescription
                    lessonObj.budgetCategory = budgetObj
                    lessonObj.overSpentPercent = data.overSpentPercent
                    lessonObj.lessonVideo = []
                    for lessonVideo in data.lessonToVideo ?? Set<DBLessonVideo>() where lessonVideo.videoStatus == VideoDownloadStatus.downloaded.rawValue {
                        var videoObj = Video()
                        videoObj.id = Int(lessonVideo.videoId)
                        videoObj.video = lessonVideo.video
                        videoObj.urlLink = lessonVideo.videoUrl
                        videoObj.thumbnail = lessonVideo.thumbnailUrl
                        lessonObj.lessonVideo?.append(videoObj)
                    }
                    savedDataArray.append(lessonObj)
                }
                manageTablePlaceholder()
                self.tableView.reloadData()
                self.descLabel.text = savedDataArray.count > 1 ? String(format: .libraryDescsText, savedDataArray.count) :  String(format: .libraryDescText, savedDataArray.count)
            }
        } catch {
            manageTablePlaceholder()
            AppUtils.showBanner(with: "Failed to fetch data.")
        }
    }
}
