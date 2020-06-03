//
//  LessonListInteractor.swift
//  PLAN-IT
//
//  Created by KiwiTech on 08/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LessonListBusinessLogic {
   func fetchLesson()
   func getLessondetail(lessonId: Int)
   func lessonRead(lessonId: Int)
}

protocol LessonListDataStore {
    var courseObj: Course? { get set }
    var lessons: [Lesson]? { get set }
}

class LessonListInteractor: LessonListBusinessLogic, LessonListDataStore {
    var courseObj: Course?
    var lessons: [Lesson]?
    var presenter: LessonListPresentationLogic?
    var worker: LessonListWorker?
    // MARK: Do something
    func fetchLesson() {
        presenter?.fetchLesson(value: courseObj, lesson: lessons)
    }
    func getLessondetail(lessonId: Int) {
        if worker == nil {
            worker = LessonListWorker()
        }
        do {
            try worker?.getLessonDetail(lessonId: lessonId, completion: {[weak self] (response) in
                self?.presenter?.handle(response: response)
            })
        } catch let error {
            handle(exception: error)
        }
    }
    func lessonRead(lessonId: Int) {
        if worker == nil {
            worker = LessonListWorker()
        }
        do {
            try worker?.lessonRead(lessonId: lessonId, completion: {[weak self] (response) in
                self?.presenter?.handleLessonRead(response: response)
            })
        } catch let error {
            handle(exception: error)
        }
    }
    fileprivate func handle(exception: Error) {
        presenter?.showError(text: .somethingWentWrong + "\n" + .tryAgainInTime)
    }
}