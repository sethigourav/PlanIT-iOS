//
//  NetworkHandler.swift
//  i-Mar
//
//  Created by KiwiTech on 28/06/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
extension NetworkManager {
    /// Use this method to handle status code 401 where user is to be logged out of the app.
    @discardableResult
    func hitRequest<ModelClass>(urlRequest: URLRequest, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Response<ModelClass>) -> Void) -> URLSessionTask? where ModelClass: ParameterConvertible {
        let task = hitApi(urlRequest: urlRequest, decoder: decoder) { (response: Response<ModelClass>) in
            if !response.isSuccess {
                //check for 401 and logout
                if let statusCode = response.statusCode, statusCode == 401 {
                    AppStateManager.shared.logoutUser()
                } else {
                    completion(response)
                }
            } else {
                completion(response)
            }
        }
        return task
    }
    func errorString<Type: ParameterConvertible>(from response: Response<Type>) -> String? {
        if response.responseError?.errorValue != nil, let details = try? Details.objectFrom(json: response.responseError?.errorValue ?? ""), !(details.detail?.isEmpty ?? true) {
            return details.detail
        } else if let error = response.error?.localizedDescription {
            if (response.error as NSError?)?.code == NSURLErrorNotConnectedToInternet {
                return .noInternet
            } else {
                return error
            }
        } else if let error = response.error as NSError?, error.code == NSURLErrorNotConnectedToInternet {
            return .noInternet
        } else {
            return response.error?.localizedDescription
        }
    }
}
