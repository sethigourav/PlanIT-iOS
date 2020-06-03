//
//  SearchCourseDataHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 19/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
extension SearchCourseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCourseCell.identifier, for: indexPath) as? SearchCourseCell
        self.updateUI(indexPath, cell: cell)
        return cell ?? UITableViewCell()
    }

    func updateUI(_ index: IndexPath, cell: SearchCourseCell?) {
        if let resultArray = resultArray {
            let course = resultArray[index.row]
            cell?.labelTitle.text = course.title
            cell?.labelDescription.text = course.description
            cell?.labelDescription.setLineSpacing(lineSpacing: 3.0, lineHeightMultiple: 0.0, alignment: .left)
            if (index.row + 1) == resultArray.count {
                cell?.separatorView.isHidden = true
            } else {
                cell?.separatorView.isHidden = false
            }
        }
    }
}
extension SearchCourseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isCourseSelected {
            self.isCourseSelected = true
            selectedIndex = indexPath.row
            previousIndex = selectedIndex
            let course = resultArray?[indexPath.row]
            interactor?.getLessonList(courseId: course?.id ?? 0)
        }
    }
    func checkNearEnd(for indexPath: IndexPath) {
        if let resultArray = resultArray {
            if indexPath.row + 1 >= resultArray.count {
                self.loadMoreSearchList()
            }
        }
    }
}
