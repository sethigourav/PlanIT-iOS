//
//  IAPHelper.swift
//  PLAN-IT
//
//  Created by KiwiTech on 21/08/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
import StoreKit
import FirebaseAnalytics
class IAPHelper: NSObject {
    private let productList: Set<String>
    private var purchasedProductIdentifiers: Set<String> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ((Bool, [SKProduct]?) -> Void)?
    private var productPurchaseRequestCompletionHandler: ((Bool, String) -> Void)?
    init(productIds: Set<String>) {
        productList = productIds
        super.init()
        SKPaymentQueue.default().add(self)
    }
    func getProductInfo(completionHandler: @escaping (Bool, [SKProduct]?) -> Void) {
        if canPurchase() {
            productsRequest?.cancel()
            productsRequestCompletionHandler = completionHandler
            productsRequest = SKProductsRequest(productIdentifiers: productList)
            productsRequest?.delegate = self
            productsRequest?.start()
        } else {
            print("Cannot perform In App Purchases.")
        }
    }
    func buyProduct(product: SKProduct, completionHandler: @escaping (Bool, String) -> Void) {
        productPurchaseRequestCompletionHandler = completionHandler
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(SKPayment(product: product))
    }
    func restorePurchasedProducts(completionHandler: @escaping (Bool, String) -> Void) {
        productPurchaseRequestCompletionHandler = completionHandler
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    //If an error occurs, the code will go to this function
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        //Handle Error
        productPurchaseRequestCompletionHandler?(false, error.localizedDescription)
    }
    func canPurchase() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    func isPurchased(productId: String) -> Bool {
        return purchasedProductIdentifiers.contains(productId)
    }
    private func complete(transaction: SKPaymentTransaction) {
        print("Purchased: \(transaction.payment.productIdentifier)")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    private func restore(transaction: SKPaymentTransaction) {
        print("restore: \(transaction.payment.productIdentifier)")
        productPurchaseRequestCompletionHandler?(true, "")
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    private func fail(transaction: SKPaymentTransaction) {
        print("fail: \(transaction.payment.productIdentifier)")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        productPurchaseRequestCompletionHandler?(false, transaction.error?.localizedDescription ?? "")
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        validateReceipt { [weak self](isValid, msg)  in
            if isValid {
                self?.productPurchaseRequestCompletionHandler?(true, msg)
            } else {
                self?.productPurchaseRequestCompletionHandler?(false, msg)
            }
            self?.clearRequestAndCompletionHandler()
        }
    }
    // MARK: Receipt Validation
    private func validateReceipt(completion: @escaping (Bool, String) -> Void) {
        let receiptUrl = Bundle.main.appStoreReceiptURL
        if let receipt: Data? = try? Data(contentsOf: receiptUrl!) {
            let receiptdata: String = (receipt?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)))!
            do {
                let request = try IAPRecieptVerificationEndPoint.recieptRequest(recieptData: receiptdata).asURLRequest()
                NetworkManager.shared.hitApi(urlRequest: request) {(response: Response<SubscriptionResponse>) in
                    if response.isSuccess, let value = response.value {
                        AppStateManager.shared.user?.isSubscribed = value.data?.isSubscribed
                        AppStateManager.shared.user?.subscriptionExpiry = value.data?.subscriptionExpiry
                        completion(true, value.detail ?? "Success!!!")
                        Analytics.logEvent(.userSubscribed, parameters: [.userName: AppStateManager.shared.user?.fullName ?? "",
                                                                             .userId: AppStateManager.shared.user?.id ?? 0])
                    } else {
                        let msg = NetworkManager.shared.errorString(from: response)
                        completion(false, msg ?? "")
                    }
                }
            } catch {
                completion(false, "IAP Receipt Validation Request Is Not In Correct Format")
            }
        }
    }
    private func clearRequestAndCompletionHandler() {
        productsRequestCompletionHandler = nil
        productPurchaseRequestCompletionHandler = nil
        productsRequest?.cancel()
        productsRequest = nil
    }
}
extension IAPHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndCompletionHandler()
        for product in response.products {
            let price = product.localizedPrice
            AppStateManager.shared.user?.subscriptionPrice = price
            print("PRODUCTID: \(product.productIdentifier) , PRICE: \(price)")
        }
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndCompletionHandler()
    }
    func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}
extension IAPHelper: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred, .purchasing:
                break
            case .failed:
                fail(transaction: transaction)
            case .purchased:
                complete(transaction: transaction)
            case .restored:
                restore(transaction: transaction)
            @unknown default:
                fail(transaction: transaction)
            }
        }
    }
}
enum IAPRecieptVerificationEndPoint: APIConfigurable {
    var path: String {
        return APIConstants.URLs.subscription.completePath
    }
    case recieptRequest(recieptData: String)
    var headers: [String: String]? {
        guard let token = AppStateManager.shared.user?.token else {
            return [:]
        }
        return [APIConstants.Mix.authorization: .bearer + " " + token]
    }
    var type: RequestType {
        return .POST
    }
    var parameters: [String: Any] {
        switch self {
        case .recieptRequest(let recieptData):
            return ["receipt": recieptData,
                    "platform": "IOS",
                    "amount": appDelegate?.product?.price ?? 4.99]
        }
    }
}
extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
