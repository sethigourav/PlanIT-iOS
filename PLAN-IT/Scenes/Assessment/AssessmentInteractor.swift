//
//  AssessmentInteractor.swift
//  PLAN-IT
//
//  Created by KiwiTech on 19/07/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
protocol AssessmentBusinessLogic {
    func getAssessmentQuestions()
    func sendAssessmentscore(request: Assessment.Request)
}

protocol AssessmentDataStore {
    var assessmentQuestions: [Category]? { get set }
}

class AssessmentInteractor: AssessmentBusinessLogic, AssessmentDataStore {
    var assessmentQuestions: [Category]?
    var presenter: AssessmentPresentationLogic?
    var worker: AssessmentWorker?
    func getAssessmentQuestions() {
        presenter?.presentAssessmentQuestion(question: assessmentQuestions)
    }
    func sendAssessmentscore(request: Assessment.Request) {
        if worker == nil {
            worker = AssessmentWorker()
        }
        do {
            try worker?.sendAssessmentScore(request: request, completion: {[weak self] (response) in
                self?.presenter?.handle(response: response)
            })
        } catch let error {
            handle(exception: error)
        }
    }
    fileprivate func handle(exception: Error) {
        presenter?.showError(text: .somethingWentWrong + "\n" + .tryAgainInTime)
    }
}
