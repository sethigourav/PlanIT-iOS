//
//  CourseListCollectionHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 02/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
extension CourseListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseArray?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCell.identifier, for: indexPath) as? CourseListCell {
            cell.updateUI(index: indexPath.item, courses: courseArray)
            return cell
        }
        return UICollectionViewCell()
    }
}
extension CourseListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showLoader()
        index = indexPath.item
        let course = courseArray?[index]
        interactor?.getLessonList(courseId: course?.id ?? 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? CourseListCell, let courseObj = course, let isNewCourse = course?.isNewCourse {
            if cell.checkForNewCourse(data: courseObj) && isNewCourse {
                interactor?.checkNewCourse(courseId: courseObj.id ?? 0)
            }
        }
    }
}
extension CourseListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 && courseArray?.count == 1 {
            return CGSize(width: collectionView.frame.size.width - 40, height: collectionView.frame.size.height)
        }
        return CGSize(width: collectionView.frame.size.width - 60, height: collectionView.frame.size.height)
    }
}
extension CourseListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == courseCollectionView {
            let midX: CGFloat = scrollView.bounds.midX
            let midY: CGFloat = scrollView.bounds.midY
            let point: CGPoint = CGPoint(x: midX, y: midY)
            guard let indexPath: IndexPath = courseCollectionView.indexPathForItem(at: point) else {
                if let index = courseCollectionView.indexPathForItem(at: CGPoint(x: midX - 12, y: midY)) {
                    self.courseCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                }
                return
            }
            DispatchQueue.main.async {
                self.courseCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else {
            return
        }
        if scrollView == courseCollectionView {
            let midX: CGFloat = scrollView.bounds.midX
            let midY: CGFloat = scrollView.bounds.midY
            let point: CGPoint = CGPoint(x: midX, y: midY)
            guard let indexPath: IndexPath = courseCollectionView.indexPathForItem(at: point) else {
                if let index = courseCollectionView.indexPathForItem(at: CGPoint(x: midX - 12, y: midY)) {
                    self.courseCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                }
                return
            }
            self.courseCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}
