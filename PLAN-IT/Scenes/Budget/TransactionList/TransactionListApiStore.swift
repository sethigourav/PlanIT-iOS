//
//  TransactionListApiHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 05/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
class TransactionListApiStore {
    func fetchTransaction(request: TransactionList.Request, completion: @escaping Completion<TransactionResponse>) {
        do {
            let request = try TransactionListEndPoint.fetchTransaction(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
    func fetchPortfolioTransaction(request: TransactionList.Request, completion: @escaping Completion<PortfolioTransactionResponse>) {
        do {
            let request = try TransactionListEndPoint.fetchTransaction(request).asURLRequest()
            NetworkManager.shared.hitRequest(urlRequest: request, completion: completion)
        } catch {
            completion(Response.failed(APIError(error: error, statusCode: nil)))
        }
    }
}
enum TransactionListEndPoint: APIConfigurable {
    case fetchTransaction(TransactionList.Request)
    var type: RequestType {
        return .POST
    }
    var path: String {
        switch self {
        case .fetchTransaction:
            return APIConstants.URLs.transactionList.completePath
        }
    }
    var parameters: [String: Any] {
        switch self {
        case .fetchTransaction(let request):
            guard let params = try? request.toParams() else {
                return [:]
            }
            return params
        }
    }
}
