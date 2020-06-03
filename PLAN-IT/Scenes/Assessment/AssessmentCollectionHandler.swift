//
//  AssessmentCollectionHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 19/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit

extension AssessmentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        var rect = cell.frame
        rect.origin.y = 0
        cell.frame = rect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            var rect = cell.frame
            rect.origin.y = 0
            cell.frame = rect
            if let cell = cell as? AssessmentCell {
                cell.layoutIfNeeded()
                cell.superview?.layoutIfNeeded()
                if cell.answerTableView.frame.maxY > self.colectionViewHeightConstraint.constant {
                    self.colectionViewHeightConstraint.constant = cell.answerTableView.frame.maxY
                }
                self.view.layoutIfNeeded()
                cell.layoutIfNeeded()
                cell.superview?.layoutIfNeeded()
            }
        }
    }
}

extension AssessmentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assessments?[categoryIndex].question?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssessmentCell.identifier, for: indexPath) as? AssessmentCell {
            if let data = assessments?[categoryIndex].question {
                if categoryIndex == 2 && indexPath.item == 2 {
                    let attributedString = NSMutableAttributedString(string: data[indexPath.item].question ?? "", attributes: [
                        .font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 19.0) ?? UIFont.systemFont(ofSize: 19.0),
                        .foregroundColor: UIColor(red: 42.0 / 255.0, green: 38.0 / 255.0, blue: 38.0 / 255.0, alpha: 1.0),
                        .kern: 0.0
                        ])
                    attributedString.addAttribute(.backgroundColor, value: UIColor(name: .highlightedText), range: NSRange(location: 21, length: 15))
                    cell.questionLabel.attributedText = attributedString
                    let view = AnswerFooterView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 148))
                    view.descriptionLabel.setLineSpacing(lineSpacing: 5.0, lineHeightMultiple: 0.0, alignment: .left)
                    cell.answerTableView.tableFooterView = view
                } else {
                    cell.answerTableView.tableFooterView = nil
                    cell.questionLabel.text = data[indexPath.item].question
                }
            }
            cell.questionLabel.setLineSpacing(lineSpacing: 5.0, lineHeightMultiple: 0.0, alignment: .left)
            cell.answerTableView.tag = indexPath.item
            cell.answerTableView.delegate = self
            cell.answerTableView.dataSource = self
            cell.answerTableView.estimatedRowHeight = 85
            DispatchQueue.main.async {
                cell.answerTableView.frame.size.height = cell.answerTableView.contentSize.height
            }
            cell.answerTableView.reloadData()
            return cell
        }
        return UICollectionViewCell()
    }
}
extension AssessmentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var tblheight = CGFloat()
        var cellHeight = CGFloat()
        if let answers = assessments?[categoryIndex].question?[indexPath.item].options {
            for obj in answers {
                let labelHeight = heightForLabel(text: obj.answer ?? "", font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 16) ?? UIFont.systemFont(ofSize: 16.0), width: UIScreen.main.bounds.width - 82, isFromQues: false)
                tblheight += labelHeight + 60
            }
        }
        let ques = assessments?[categoryIndex].question?[indexPath.item]
        let quesHeight = heightForLabel(text: ques?.question ?? "", font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 19) ?? UIFont.systemFont(ofSize: 19.0), width: UIScreen.main.bounds.width - 40, isFromQues: true)
        if categoryIndex == 2 && indexPath.item == 2 {
            cellHeight = quesHeight + (tblheight + 148) + 40
        } else {
            cellHeight = quesHeight + tblheight + 40
        }
        return CGSize(width: UIScreen.main.bounds.width, height: cellHeight)
    }
}
extension AssessmentViewController {
    func heightForLabel(text: String, font: UIFont, width: CGFloat, isFromQues: Bool) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        if isFromQues {
            label.setLineSpacing(lineSpacing: 5.0, lineHeightMultiple: 0.0, alignment: .left)
        }
        label.sizeToFit()
        return label.frame.height
    }
}
extension AssessmentViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView)
        let midX: CGFloat = scrollView.bounds.midX
        let midY: CGFloat = scrollView.bounds.midY
        let point: CGPoint = CGPoint(x: midX, y: midY)
        guard let indexPath: IndexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        if actualPosition.x > 0 {
            self.isRightSwipe = true
            self.prgLabel.text = "\(self.questionIndex.item + 1)" + "/" + String(format: "%d questions", self.assessments?[self.categoryIndex].question?.count ?? 0)
            scrollView.isDirectionalLockEnabled = false
            if indexPath.row == 0 && categoryIndex > 0 && collectionView.indexPathsForVisibleItems.first?.row == 0 {
                self.categoryIndex -= 1
                moveToPreviousScreen()
            } else {
                questionIndex = indexPath
                let cell = collectionView.cellForItem(at: questionIndex) as? AssessmentCell
                cell?.answerTableView.reloadData()
                self.collectionView.reloadData()
            }
        } else {
            let obj = self.assessments?[self.categoryIndex].question?[self.questionIndex.item]
            var isSelected = Bool()
            for value in obj?.options ?? [] where value.isSelected ?? false {
                isSelected = true
                break
            }
            if !isSelected {
                self.isRightSwipe = false
            }
            self.prgLabel.text = "\(self.questionIndex.item + 1)" + "/" + String(format: "%d questions", self.assessments?[self.categoryIndex].question?.count ?? 0)
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.panGestureRecognizer.isEnabled = true
            questionIndex = indexPath
            let cell = collectionView.cellForItem(at: questionIndex) as? AssessmentCell
            cell?.answerTableView.reloadData()
            self.collectionView.reloadData()
        }
    }
}
extension AssessmentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let obj = assessments?[categoryIndex].question?[questionIndex.item].options
        return obj?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.identifier, for: indexPath) as? AnswerCell
        cell?.index = indexPath
        let ques = assessments?[categoryIndex].question?[tableView.tag]
        cell?.updateUI(obj: ques)
        return cell ?? UITableViewCell()
    }
}
extension AssessmentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var obj = self.assessments?[self.categoryIndex].question?[self.questionIndex.item]
        for (index, value) in obj?.options?.enumerated() ?? [].enumerated() {
            var ansObj = value
            ansObj.isSelected = false
            obj?.options?[index] = ansObj
        }
        obj?.options?[indexPath.row].isSelected = true
        self.assessments?[self.categoryIndex].question?[self.questionIndex.item] = obj ?? Question()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.collectionView.reloadData()
            self.scrollView.setContentOffset(CGPoint.init(x: self.scrollView.contentOffset.x, y: 0), animated: true)
        })
        if (questionIndex.item + 1) == assessments?[categoryIndex].question?.count {
            if (categoryIndex + 1) == assessments?.count {
                self.getScore(assessment: assessments)
                if !scoreArray.isEmpty {
                    self.showLoader()
                    interactor?.sendAssessmentscore(request: Assessment.Request(category1: scoreArray[0], category2: scoreArray[1], category3: scoreArray[2]))
                }
            } else {
                questionIndex = IndexPath.init(item: 0, section: 0)
                let percentProgress = Float(Float(100/(self.assessments?[self.categoryIndex].question?.count ?? 0)) / 100)
                var model: Category = self.assessments?[self.categoryIndex] ?? Category()
                model.progress = (model.progress ?? 0) + percentProgress
                self.assessments?[self.categoryIndex] = model
                self.categoryIndex += 1
                self.saveData(data: self.assessments)
                self.moveToNextScreen()
            }
        } else {
            let index = IndexPath(item: questionIndex.item + 1, section: 0)
            collectionView.scrollToItem(at: index, at: .right, animated: true)
            DispatchQueue.main.async {
                var isSelected = Bool()
                for value in obj?.options ?? [] where value.isSelected ?? false {
                    isSelected = true
                    break
                }
                if isSelected && self.isRightSwipe { return } else {
                    let percentProgress = Float(Float(100/(self.assessments?[self.categoryIndex].question?.count ?? 0)) / 100)
                    var model: Category = self.assessments?[self.categoryIndex] ?? Category()
                    model.progress = (model.progress ?? 0) + percentProgress
                    self.assessments?[self.categoryIndex] = model
                    self.saveData(data: self.assessments)
                    self.prgView.setProgress(model.progress ?? 0, animated: true)
                    return
                }
            }
        }
    }
}
extension AssessmentViewController {
    func screenShotMethod() -> UIImage? {
        //Create the UIImage
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
extension AssessmentViewController {
    func moveToNextScreen() {
        DispatchQueue.main.async {
            if let image = self.screenShotMethod() {
                let imageView = UIImageView.init(frame: UIScreen.main.bounds)
                imageView.backgroundColor = .white
                imageView.image = image
                (self.navigationController?.view ?? self.view).addSubview(imageView)
                self.scrollViewLeadingConstraint.constant = self.view.frame.width
                self.scrollViewTrailingConstraint.constant = self.view.frame.width
                self.view.layoutIfNeeded()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                    self.scrollViewLeadingConstraint.constant = 0
                    self.scrollViewTrailingConstraint.constant = 0
                    UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
                        imageView.alpha = 0
                        self.scrollView.alpha = 1
                        var rect = imageView.frame
                        rect.origin.x = -UIScreen.main.bounds.width
                        imageView.frame = rect
                        self.updateUI()
                        let model: Category = self.assessments?[self.categoryIndex] ?? Category()
                        self.prgView.setProgress(model.progress ?? 0, animated: false)
                         DispatchQueue.main.async {
                            self.collectionView.scrollToItem(at: self.questionIndex, at: UICollectionView.ScrollPosition(rawValue: 0), animated: false)
                        }
                    }, completion: { (_) in
                        imageView.removeFromSuperview()
                    })
                })
            }
        }
    }
    func moveToPreviousScreen() {
        DispatchQueue.main.async {
            if let image = self.screenShotMethod() {
                let cell = self.collectionView.cellForItem(at: IndexPath.init(item: (self.assessments?[self.categoryIndex].question?.count ?? 0) - 1, section: 0)) as? AssessmentCell
                cell?.answerTableView.reloadData()
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath.init(item: (self.assessments?[self.categoryIndex].question?.count ?? 0) - 1, section: 0), at: .right, animated: false)
                let imageView = UIImageView.init(frame: UIScreen.main.bounds)
                imageView.backgroundColor = .white
                imageView.image = image
                (self.navigationController?.view ?? self.view).addSubview(imageView)
                self.scrollViewLeadingConstraint.constant = -self.view.frame.width
                self.scrollViewTrailingConstraint.constant = -self.view.frame.width
                self.view.layoutIfNeeded()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                    self.scrollViewLeadingConstraint.constant = 0
                    self.scrollViewTrailingConstraint.constant = 0
                    UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
                        imageView.alpha = 0
                        self.scrollView.alpha = 1
                        var rect = imageView.frame
                        rect.origin.x = UIScreen.main.bounds.width
                        imageView.frame = rect
                        self.updateUI()
                        DispatchQueue.main.async {
                            self.prgView.setProgress( self.assessments?[self.categoryIndex].progress ?? 0, animated: false)
                            self.questionIndex = IndexPath.init(item: (self.assessments?[self.categoryIndex].question?.count ?? 0) - 1, section: 0)
                            self.collectionView.scrollToItem(at: self.questionIndex, at: .right, animated: false)
                        }
                    }, completion: { (_) in
                        imageView.removeFromSuperview()
                    })
                })
            }
        }
    }
}
