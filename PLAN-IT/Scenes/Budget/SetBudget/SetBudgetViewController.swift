//
//  SetBudgetViewController.swift
//  PLAN-IT
//
//  Created by KiwiTech on 27/08/19.
//  Copyright (c) 2019 KiwiTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import WebKit
import FirebaseAnalytics
protocol SetBudgetDisplayLogic: class {
    func showAlertFor(text: String)
    func setBudget(data: String?)
    func setAnnualIncome(data: UserData?)
    func fetchCategoryDescription(data: String?, category: BudgetCategory?)
}

class SetBudgetViewController: BaseViewController, SetBudgetDisplayLogic {
    var interactor: SetBudgetBusinessLogic?
    var router: (NSObjectProtocol & SetBudgetRoutingLogic & SetBudgetDataPassing)?
    @IBOutlet weak var setBudgetField: UITextField!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: CustomiseView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var setBudgetView: UIView!
    @IBOutlet weak var setBudgetProgressView: UIView!
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var budgetLeftLabel: UILabel!
    @IBOutlet weak var nextTransSetLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    var category: BudgetCategory?
    var keyboardHeight: CGFloat?
    weak var bottomSheet: BottomSheetViewController?
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
        let interactor = SetBudgetInteractor()
        let presenter = SetBudgetPresenter()
        let router = SetBudgetRouter()
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
        currentMonthLabel.setLineSpacing(lineSpacing: 5.0, lineHeightMultiple: 0.0, alignment: .left)
        webView.scrollView.delegate = self
        webView.scrollView.bounces = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        showLoader()
        interactor?.fetchCategoryDescription()
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 1.5)
        progressView.layer.cornerRadius = progressView.frame.size.height / 2
        progressView.clipsToBounds = true
        setUpUI()
    }
    func setUpUI() {
        if AppUtils.setBudgetForCurrentMonth(date: category?.serverDate ?? "") {
            self.currentMonthLabel.text = String(format: .setbudgetCurrentMonthText, AppUtils.nexttMonth(date: AppUtils.fetchBudgetDate(fromStr: category?.serverDate ?? "")))
        } else {
            var dateComponents = DateComponents()
            dateComponents.month = +1
            let minDate = Calendar.current.date(byAdding: dateComponents, to: AppUtils.fetchBudgetDate(fromStr: category?.serverDate ?? "")) ?? Date()
            let nextMonth = AppUtils.nexttMonth(date: minDate)
            self.currentMonthLabel.text = String(format: .setbudgetCurrentMonthText, nextMonth)
        }
        let progress =  (category?.spend ?? 0) / (category?.setBudget ?? 0)
        if AppUtils.setBudgetForCurrentMonth(date: category?.serverDate ?? "") {
            setBudgetView.isHidden = false
            setBudgetProgressView.isHidden = true
        } else {
            if category?.setBudget ?? 0 == 0 && category?.nextMonthSetBudget ?? 0 == 0 {
                setBudgetView.isHidden = false
                setBudgetProgressView.isHidden = true
            } else {
                setBudgetView.isHidden = category?.setBudget ?? 0 == 0 ? false : true
                setBudgetProgressView.isHidden = category?.setBudget ?? 0 == 0 ? true : false
            }
        }
        self.titleLabel.text = String(format: .budgetTitleText, category?.categoryName ?? "")
        self.setBudgetField.placeholder =  String(format: "%@/month", AppUtils.getSymbol(forCurrencyCode: category?.isoCurrencyCode ?? "") ?? "$")
        self.setBudgetField.text = category?.setBudget != 0 ? String(format: "%d", Int(category?.setBudget ?? 0)) : category?.nextMonthSetBudget != 0 ? String(format: "%d", Int(category?.nextMonthSetBudget ?? 0)) : ""
        self.progressView.setProgress(progress, animated: false)
        self.spentLabel.text = progress >= 0.0 ? String(format: "%.2f%% SPENT", progress * 100) : ""
        let budgetLeft = (category?.setBudget ?? 0) - (category?.spend ?? 0)
        self.budgetLeftLabel.text = String(format: .budgetSetText, budgetLeft.formatNumber(code: category?.isoCurrencyCode ?? ""))
        var dateComponents = DateComponents()
        dateComponents.month = +1
        let minDate = Calendar.current.date(byAdding: dateComponents, to: AppUtils.fetchBudgetDate(fromStr: category?.serverDate ?? "")) ?? Date()
        let nextMonth = AppUtils.nexttMonth(date: minDate)
        self.nextTransSetLabel.text = String(format: .nextMonthText, nextMonth)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        bottomSheet?.removeBottomSheet()
    }
    func setBottomSheet() {
        if let controller = AppUtils.viewController(with: SetAnnualIncomeViewController.identifier, in: .tabbar) as? SetAnnualIncomeViewController {
            _ = controller.view //To load the objects from NIB
            controller.delegate = self
            controller.category = category
            let hgt = UIScreen.main.bounds.height - (controller.heightConstraint.constant + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            let midHgt = UIScreen.main.bounds.height - ((controller.heightConstraint.constant + (keyboardHeight ?? 0)) - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            let minHgt = UIScreen.main.bounds.height + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
            bottomSheet = BottomSheetViewController.initialize(
                parentViewController: self.navigationController ?? self,
                childViewController: controller, trackingScrollView: controller.scrollView,
                shouldDismissOnBackViewTap: true, topViewAnimateDelegateObj: nil,
                maxOffsetOfSheet: hgt, midOffsetOfSheet: midHgt, minOffsetOfSheet: minHgt,
                shouldShowOnMax: true)
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func setBudgetBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        if setBudgetField.text?.isEmpty ?? true || setBudgetField.text == "0" {
           setFieldBorderColor(isError: true, view: containerView)
        } else {
            showLoader()
            if AppUtils.setBudgetForCurrentMonth(date: category?.serverDate ?? "") {
                interactor?.setBudget(request: SetBudget.Request.init(categoryId: category?.categoryId ?? 0, budget: Float(setBudgetField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") ?? 0.0, nextMonthBudget: 0))
            } else {
                interactor?.setBudget(request: SetBudget.Request.init(categoryId: category?.categoryId ?? 0, budget: 0, nextMonthBudget: Float(setBudgetField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") ?? 0.0))
            }
        }
    }
    @IBAction func notSureBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        setFieldBorderColor(isError: false, view: containerView)
        bottomSheet?.removeBottomSheet()
        setBottomSheet()
    }
    func showAlertFor(text: String) {
        hideLoader()
        AppUtils.showBanner(with: text)
    }
    func setBudget(data: String?) {
        hideLoader()
        AppUtils.showBanner(with: data ?? "", type: .done)
        self.setBudgetField.text = String(format: "%d", Int(self.setBudgetField.text ?? "") ?? 0)
        Analytics.logEvent(.setBudget, parameters: [.userName: AppStateManager.shared.user?.fullName ?? "" as NSObject,
                                                     .userId: AppStateManager.shared.user?.id ?? 0 as NSObject, .categoryName: category?.categoryName ?? "" as NSObject])
    }
    func setAnnualIncome(data: UserData?) {
        hideLoader()
    }
    func fetchCategoryDescription(data: String?, category: BudgetCategory?) {
        if let descStr = data, let categoryObj = category {
            self.category = category
            self.categoryNameLabel.text = (categoryObj.categoryName ?? "") + "?"
            self.webView.navigationDelegate = self
            let fontSetting = """
                              <head>\
                              <link rel="stylesheet" type="text/css" href="Font.css">\
                              </head>
                              """
            if let resourcePath = Bundle.main.path(forResource: "Font", ofType: "css") {
                let url = URL.init(fileURLWithPath: resourcePath)
                self.webView.loadHTMLString(fontSetting + "<meta name=\"viewport\" content=\"initial-scale=1.0\" />" + descStr, baseURL: url)
            }
        }
    }
}
extension SetBudgetViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
extension SetBudgetViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.hideLoader()
            self.blurView.isHidden = true
            self.heightConstraint.constant = webView.scrollView.contentSize.height + 50
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            if let controller = AppUtils.viewController(with: LoaderController.identifier) as? LoaderController {
                controller.detailUrl = navigationAction.request.url
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.present(controller, animated: true, completion: nil)
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
extension SetBudgetViewController: SetAnnualIncomeDisplayLogic {
    func dismissController(annualIncome: String?) {
        self.setBudgetField.text = annualIncome
        if AppUtils.setBudgetForCurrentMonth(date: category?.serverDate ?? "") {
            interactor?.setBudget(request: SetBudget.Request.init(categoryId: category?.categoryId ?? 0, budget: Float(annualIncome ?? "") ?? 0.0, nextMonthBudget: 0.0))
        } else {
            interactor?.setBudget(request: SetBudget.Request.init(categoryId: category?.categoryId ?? 0, budget: 0, nextMonthBudget: Float(annualIncome ?? "") ?? 0.0))
        }
        bottomSheet?.removeBottomSheet()
    }
}
extension SetBudgetViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setFieldBorderColor(isError: false, view: containerView)
        let button = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        done.tintColor = .black
        let navTitle = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: toolBar.frame.size.height))
        navTitle.text = .setBudgetPlaceHolder
        navTitle.font = UIFont(font: (name: UIFont.FontName.karla, varient: UIFont.FontVarient.regular), size: 14)
        navTitle.textColor = .lightGray
        let titleItem = UIBarButtonItem.init(customView: navTitle)
        toolBar.items = [button, titleItem, button, done]
        textField.inputAccessoryView = toolBar
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.textInputMode?.primaryLanguage == .emoji || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        guard string != " " else {
            return false
        }
        setFieldBorderColor(isError: false, view: containerView)
        return true
    }
    @objc func doneTapped() {
        self.view.endEditing(true)
        if setBudgetField.text?.isEmpty ?? true || setBudgetField.text == "0" {
           setFieldBorderColor(isError: true, view: containerView)
        } else {
            showLoader()
            if AppUtils.setBudgetForCurrentMonth(date: category?.serverDate ?? "") {
                interactor?.setBudget(request: SetBudget.Request.init(categoryId: category?.categoryId ?? 0, budget: Float(setBudgetField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") ?? 0.0, nextMonthBudget: 0))
            } else {
                interactor?.setBudget(request: SetBudget.Request.init(categoryId: category?.categoryId ?? 0, budget: 0, nextMonthBudget: Float(setBudgetField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") ?? 0.0))
            }
        }
    }
}
extension SetBudgetViewController {
    func setFieldBorderColor(isError: Bool, view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = isError ? UIColor(name: .errorColor).cgColor : UIColor.white.cgColor
    }
}
