//
//  ScoreViewController.swift
//  PLAN-IT
//
//  Created by KiwiTech on 01/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ScoreDisplayLogic: class {
    func getScore(assessmentScore: [Int]?)
}

class ScoreViewController: BaseViewController, ScoreDisplayLogic {
    @IBOutlet weak var financialDescLabel: UILabel!
    @IBOutlet weak var savingDesclabel: UILabel!
    @IBOutlet weak var entreDescLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var financialScoreLabel: UILabel!
    @IBOutlet weak var savingScoreLabel: UILabel!
    @IBOutlet weak var entrepreneurScoreLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var interactor: ScoreBusinessLogic?
    var router: (NSObjectProtocol & ScoreRoutingLogic & ScoreDataPassing)?
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = ScoreInteractor()
        let presenter = ScorePresenter()
        let router = ScoreRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topConstraint.constant = DeviceType.ISIPHONEXR ? 140 : 80
        self.userNameLabel.text = (AppStateManager.shared.user?.firstName ?? "") + "!"
        interactor?.getScore()
    }
    // MARK: Do something
    func getScore(assessmentScore: [Int]?) {
        if let scoreArray = assessmentScore {
            self.financialScoreLabel.text = String(format: "%d", scoreArray[0])
            self.financialDescLabel.text = setTextAccordingToScore(score: scoreArray[0])
            self.savingScoreLabel.text = String(format: "%d", scoreArray[1])
            self.savingDesclabel.text = setTextAccordingToScore(score: scoreArray[1])
            self.entrepreneurScoreLabel.text = String(format: "%d", scoreArray[2])
            self.entreDescLabel.text = setTextAccordingToScore(score: scoreArray[2])
        }
    }
    @IBAction func seeCoursesBtnAction(_ sender: Any) {
        let controller = AppUtils.viewController(with: PlanItTabbarController.identifier, in: .tabbar)
        appDelegate?.window?.rootViewController = controller
    }
}
extension ScoreViewController {
    func setTextAccordingToScore(score: Int) -> String {
        if score == 5 || score <= 10 {
            return .fiveToTenText
        } else if score == 11 || score <= 15 {
            return.elevenToFifteenText
        } else if score == 16 || score <= 20 {
            return .sixteenToTwentyText
        }
        return ""
    }
}
