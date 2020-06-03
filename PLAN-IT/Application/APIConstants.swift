//
//  APIConstants.swift
//  PLAN-IT
//
//  Created by KiwiTech on 02/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
/// Base URLs for the the app for different environments
enum BaseURL: String {
    case qaServer = "https://planit-qa.kiwi-internal.com",
    dev = "https://planit-dev.kiwi-internal.com",
    production = "https://www.planit.money",
    staging = "https://planit-stage.kiwi-internal.com",
    local = "http://172.16.147.93:8000"
    static var urlStr: String {
        return BaseURL.production.rawValue
    }
    static var url: URL? {
        return URL(string: BaseURL.urlStr)
    }
}
enum APIConstants {
    /// Enum for URLs used in App
    enum URLs {
        var path: String {
            switch self {
            case .signUp:
                return "auth/signup/"
            case .login:
                return "auth/login/"
            case .forgotPassword:
                return "auth/forget-password"
            case .resend:
                return "auth/resend-email-verification"
            case .assessmentQusetions:
                return "assessment/question/"
            case .courseList:
                return "assessment/course/"
            case .assessmentScore:
                return "assessment/user-score-save/"
            case .lessonList(let courseId):
                return "assessment/course/\(courseId)/lesson/"
            case .termsPrivacy:
                return "auth/privacy-policy-tnc-url"
            case .lessonFeedback:
                return "assessment/lesson-feedback"
            case .lessonDetail(let lessonId):
                return "assessment/lesson-detail/\(lessonId)/"
            case .lessonCompleted:
                return "assessment/lesson-read/"
            case .subscription:
                return "auth/subscription/"
            case .searchCourse(let query, let limit, let offset):
                return "assessment/search-course/?limit=\(limit)&offset=\(offset)&search=\(query)"
            case .checkNewCourse(let courseId):
                return "assessment/course/\(courseId)/"
            case .getUserData:
                return "auth/user"
            case .sendPlaidToken:
                return "budget/token/"
            case .transactionList:
                return "budget/transaction/"
            case .createPin:
                return "budget/create-pin/"
            case .enterPassword:
                return "budget/reset-pin/"
            case .verifyPin:
                return "budget/pin-verification/"
            case .budgetCategory:
                return "budget/category/"
            case .budgetCategoryDetail:
                return "budget/category-detail/"
            case .setBudget:
                return "budget/set/"
            case .setAnnualIncome:
                return "auth/save-annual-income/"
            case .budgetAccountDelete:
                return "budget/account/"
            case .changePassword:
                return "auth/change-password/"
            case .registerDeviceToken:
                return "auth/devices/"
            case .logout:
                return "auth/logout/"
            case .lessonRead(let lessonId):
                return "/assessment/read-status/\(lessonId)/"
            case .validateReferenceCode(let code):
                return "assessment/promo-code/\(code)"
            }
        }
        var apiVersion: String {
            return "/api/v1/"
        }
        var completePath: String {
            return BaseURL.urlStr + apiVersion + path
        }
        case signUp,
        login,
        forgotPassword,
        resend,
        assessmentQusetions,
        assessmentScore,
        courseList,
        termsPrivacy,
        lessonFeedback,
        lessonList(courseId: Int),
        lessonDetail(lessonId: Int),
        lessonCompleted,
        subscription,
        searchCourse(query: String, limit: Int, offset: Int),
        checkNewCourse(courseId: Int),
        getUserData,
        sendPlaidToken,
        transactionList,
        createPin,
        enterPassword,
        verifyPin,
        budgetCategory,
        budgetCategoryDetail,
        setBudget,
        setAnnualIncome,
        budgetAccountDelete,
        changePassword,
        registerDeviceToken,
        logout,
        lessonRead(lessonId: Int),
        validateReferenceCode(code: String)
    }
    /// Enum for keys used for parameters in APIs
    enum Keys {
        static let email = "email"
        static let password = "password"
        static let name = "name"
    }
    /// Enum for mix keys/errors for APIs
    enum Mix {
        static let accessToken = "accessToken"
        static let email = "email"
        static let authorization = "Authorization"
        static let page = "page"
        static let search = "search"
    }
}
extension APIConfigurable {
    var headers: [String: String]? {
        guard let token = AppStateManager.shared.user?.token else {
            return [:]
        }
        return [APIConstants.Mix.authorization: .bearer + " " + token]
    }
}
