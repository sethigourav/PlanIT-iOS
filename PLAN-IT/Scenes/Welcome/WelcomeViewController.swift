//
//  WelcomeViewController.swift
//  PLAN-IT
//
//  Created by KiwiTech on 23/07/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Nantes
import CoreData
protocol WelcomeDisplayLogic: class {
    func showAlertFor(text: String)
    func fetchedAssessment(data: [Category]?)
}

class WelcomeViewController: BaseViewController, WelcomeDisplayLogic {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var interactor: WelcomeBusinessLogic?
    var router: (NSObjectProtocol & WelcomeRoutingLogic & WelcomeDataPassing)?
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
        let interactor = WelcomeInteractor()
        let presenter = WelcomePresenter()
        let router = WelcomeRouter()
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
        retrieveData()
        topConstraint.constant = DeviceType.ISIPHONEXR ? 118 : 80
        self.userNameLabel.text = .hiText + " " + (AppStateManager.shared.user?.firstName ?? "") + "!"
        updateUI()
    }
    func updateUI() {
        let attributedString = NSMutableAttributedString(string: .welcomeDescription, attributes: [
            .font: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 19.0) ?? UIFont.systemFont(ofSize: 19.0),
            .foregroundColor: UIColor(red: 42.0 / 255.0, green: 38.0 / 255.0, blue: 38.0 / 255.0, alpha: 1.0),
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.bold), size: 19.0) ?? UIFont.systemFont(ofSize: 19.0), range: NSRange(location: 118, length: 73))
        descriptionLabel.attributedText = attributedString
        descriptionLabel.setLineSpacing(lineSpacing: 5.0, lineHeightMultiple: 0.0, alignment: .left)
    }
    func showAlertFor(text: String) {
        hideLoader()
        AppUtils.showBanner(with: text)
    }
    func fetchedAssessment(data: [Category]?) {
        hideLoader()
        if (data?.count ?? 0) > 0 {
            saveData(data: data)
            router?.showAssessment(questions: data)
        }
    }
    @IBAction func btnAction(_ sender: Any) {
        showLoader()
        interactor?.getAssessmentQuestions()
    }
}
extension WelcomeViewController {
    func saveData(data: [Category]?) {
        var tempArray = [[String: Any]]()
        for value in data ?? [] {
            if let dict = try? value.toParams() {
                tempArray.append(dict)
            }
        }
        do {
            let value = try NSKeyedArchiver.archivedData(withRootObject: tempArray, requiringSecureCoding: false)
            guard let context = context else {
                return
            }
            guard let entity = NSEntityDescription.entity(forEntityName: "DBAssessments", in: context) else {
                return
            }
            let assessValue = NSManagedObject(entity: entity, insertInto: context) as? DBAssessments
            assessValue?.assessmentValue = value as Data
            do {
                try context.save()
            } catch {
                AppUtils.showBanner(with: "Failed saving!!!!")
            }
        } catch {
            print(error)
        }
    }
    func retrieveData() {
        let request = NSFetchRequest<DBAssessments>(entityName: "DBAssessments")
        if let result = try? context?.fetch(request), result.count > 0 {
            let data = result[0]
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data.assessmentValue ?? Data()) as? [[String: Any]] {
                var tempArray = [Category]()
                for value in array {
                    if let modelObj = try? Category.objectFrom(json: value) {
                        tempArray.append(modelObj)
                    }
                }
                if tempArray.count > 0 {
                    router?.showAssessment(questions: tempArray)
                }
            }
        }
    }
}
