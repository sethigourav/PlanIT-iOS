//
//  LoaderController.swift
//  PLAN-IT
//
//  Created by KiwiTech on 26/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
import WebKit
class LoaderController: BaseViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var urlLabel: UILabel!
    var detailUrl: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
        setupUI()
    }
    func setupUI() {
        showLoader()
        if let url = detailUrl {
            webview.navigationDelegate = self
            webview.load(URLRequest(url: url))
        }
    }
    func setWebView() {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, shrink-to-fit=YES, initial-scale=0.0;" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webview.configuration.userContentController.addUserScript(script)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        if webview.canGoBack {
            webview.goBack()
        } else {
           hideLoader()
           self.dismiss(animated: true, completion: nil)
        }
    }
}
extension LoaderController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            webView.load(navigationAction.request)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideLoader()
        AppUtils.showBanner(with: error.localizedDescription)
        self.dismiss(animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
            webView.evaluateJavaScript(jscript)
            self.hideLoader()
            self.urlLabel.text = webView.title
        }
    }
}
