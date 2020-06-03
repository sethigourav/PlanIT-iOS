//
//  BudgetSavingHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 11/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
import Charts
extension BudgetSavingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppStateManager.shared.budgetCategoryArray?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell {
            if let data = AppStateManager.shared.budgetCategoryArray?[indexPath.row] {
                cell.updateUI(data: data, index: indexPath.row)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
extension BudgetSavingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showLoader()
        self.collectionView.isUserInteractionEnabled = false
        self.index = indexPath.row
        let budgetCategory = AppStateManager.shared.budgetCategoryArray?[self.index ?? 0]
        let progress = (budgetCategory?.setBudget ?? 0) > 0 ? (budgetCategory?.spend ?? 0) / (budgetCategory?.setBudget ?? 0) : 0
        interactor?.fetchBudgetCategoryDetail(request: BudgetSaving.Request(categoryId: budgetCategory?.categoryId, percentage: progress >= 0 ? (progress * 100) : 0))
    }
}
extension BudgetSavingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 112, height: collectionView.frame.size.height)
    }
}
extension BudgetSavingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let midX: CGFloat = scrollView.bounds.midX
            let midY: CGFloat = scrollView.bounds.midY
            let point: CGPoint = CGPoint(x: midX, y: midY)
            guard let indexPath: IndexPath = collectionView.indexPathForItem(at: point) else {
                if let index = collectionView.indexPathForItem(at: CGPoint(x: midX - 3, y: midY)) {
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
                if let index = collectionView.indexPathForItem(at: CGPoint(x: midX - 3, y: midY)) {
                    self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                }
                return
            }
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}
