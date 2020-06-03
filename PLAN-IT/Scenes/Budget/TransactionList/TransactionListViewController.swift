//
//  TransactionListViewController.swift
//  PLAN-IT
//
//  Created by KiwiTech on 03/09/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
protocol TransactionListDisplayLogic: class {
    func showAlertFor(text: String)
    func fetchTransaction(data: [Transaction]?)
    func fetchPortfolioTransaction(data: [PortfolioTransaction]?)
}

class TransactionListViewController: BaseViewController, TransactionListDisplayLogic {
    var interactor: TransactionListBusinessLogic?
    var router: (NSObjectProtocol & TransactionListRoutingLogic & TransactionListDataPassing)?
    @IBOutlet weak var tableview: UITableView!
    var transactionArray = [Transaction]()
    var portfoliotransactionArray = [PortfolioTransaction]()
    var titleStr: String = ""
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
        let interactor = TransactionListInteractor()
        let presenter = TransactionListPresenter()
        let router = TransactionListRouter()
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
    }
    func showAlertFor(text: String) {
        hideLoader()
        AppUtils.showBanner(with: text)
        manageTablePlaceholder()
    }
    func fetchTransaction(data: [Transaction]?) {
        hideLoader()
        self.transactionArray = data ?? []
        manageTablePlaceholder()
        self.tableview.reloadData()
    }
    func fetchPortfolioTransaction(data: [PortfolioTransaction]?) {
        hideLoader()
        self.portfoliotransactionArray = data ?? []
        manageTablePlaceholder()
        self.tableview.reloadData()
    }
    func callTransactionListApi(request: TransactionList.Request) {
        showLoader()
        if request.isFromDatePicker ?? false {
            self.interactor?.fetchTransaction(request: request)
        } else {
            self.titleStr == .portfolio ? self.interactor?.fetchPortfolioTransaction(request: request) : self.interactor?.fetchTransaction(request: request)
        }
    }
}
extension TransactionListViewController {
    func manageTablePlaceholder() {
        setPlaceholder(tableView: self.tableview)
    }
    func setPlaceholder(tableView: UITableView) {
        guard self.transactionArray.count > 0 || self.portfoliotransactionArray.count > 0 else {
            tableView.tableFooterView = nil
            let placeholderView = TransactionEmptyView()
            placeholderView.imgView.image = UIImage(named: .transactions)
            placeholderView.descLabel.text = .transactionEmptyText
            tableView.backgroundView = placeholderView
            return
        }
        tableView.backgroundView = nil
        tableView.dataSource = self
        tableView.delegate = self
    }
}
