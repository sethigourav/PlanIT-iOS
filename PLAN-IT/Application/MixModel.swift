//
//  MixModel.swift
//  i-Mar
//
//  Created by KiwiTech on 28/06/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
struct Details: ParameterConvertible {
    var detail: String?
}
struct Controller: ParameterConvertible {
    var identifier: String = ""
    var storyboard: Storyboards = .main
    init(identifier: String, storyboard: Storyboards = .main) {
        self.identifier = identifier
        self.storyboard = storyboard
    }
}
struct AuthenticationToken: ParameterConvertible {
    var accessToken: String
    var refreshToken: String
    var expiresIn: Date
    var clientId: String
    var clientSecret: String
    var authorizationHeaderValue: String? {
        return .bearer + " " + accessToken
    }
}
struct UserResponse: ParameterConvertible {
    var detail: String?
    var data: UserData?
}
struct PushResponse: ParameterConvertible {
    var detail: String?
    var data: PushStatus?
}
struct PushStatus: ParameterConvertible {
    var emailNotification: Bool?
    var pushNotification: Bool?
}
struct UserData: ParameterConvertible {
    var id: Int?
    var token: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var password: String?
    var subscriptionExpiry: String?
    var dob: String?
    var isVerified: Bool?
    var isFirstLogin: Bool?
    var isSubscribed: Bool?
    var createdAt: String?
    var isAccount: Bool?
    var isPinAdded: Bool?
    var annualIncome: Float?
    var emailNotification: Bool?
    var pushNotification: Bool?
    var isPromoSubscribed: Bool?
    var subscriptionPrice: String?
    var isPromoReference: Bool?
    var fullName: String {
        let fName = self.firstName ?? ""
        let lName = self.lastName ?? ""
        return fName + " " + lName
    }
}
struct AssesmentResponse: ParameterConvertible {
    var detail: String?
    var data: [Category]?
}
struct Category: ParameterConvertible {
    var categoryId: Int?
    var category: String?
    var question: [Question]?
    var imageUrl: String?
    var progress: Float?
}
struct Question: ParameterConvertible {
    var questionId: Int?
    var question: String?
    var options: [Answer]?
    var isTick: Bool?
}
struct Answer: ParameterConvertible {
    var answerId: Int?
    var answer: String?
    var isSelected: Bool?
    var score: Int?
}
struct CourseListResponse: ParameterConvertible {
    var detail: String?
    var data: [Course]?
}
struct LessonListResponse: ParameterConvertible {
    var detail: String?
    var data: [Lesson]?
}
struct LessonDetailResponse: ParameterConvertible {
    var detail: String?
    var data: Lesson?
}
struct SearchListResponse: ParameterConvertible {
    var count: Int?
    var results: [Course]?
}
struct Course: ParameterConvertible {
    var id: Int?
    var title: String?
    var description: String?
    var isNewCourse: Bool?
    var isModified: Bool?
    var courseThumbnail: String?
    var progress: Float?
    var category: Category?
    var totalLessonCount: Int?
    var readLessonCount: Int?
    var updatedAt: String?
}
struct Lesson: ParameterConvertible {
    var id: Int?
    var index: Int?
    var title: String?
    var description: String?
    var isPlaying: Bool?
    var isCompleted: Bool?
    var lessonVideo: [Video]?
    var categoryName: String?
    var courseName: String?
    var overSpentDesc: String?
    var overSpentPercent: Float?
    var budgetCategory: BudgetCategory?
    var updatedAt: String?
    var createdAt: String?
}
enum VideoDownloadStatus: String, Codable {
    case downloading = "Downloading",
    downloaded = "Downloaded",
    failure = "Failure",
    error = "Error"
}
struct Video: ParameterConvertible {
    var id: Int?
    var urlLink: String?
    var video: String?
    var thumbnail: String?
    var status: VideoDownloadStatus?
    var originalUrl: String?
}
struct TermsPolicyResponse: ParameterConvertible {
    var detail: String?
    var data: [TermsPolicyUrl]?
}
struct TermsPolicyUrl: ParameterConvertible {
    var policyUrl: String?
    var termsAndCondUrl: String?
}
struct StaticMessgaeResponse: ParameterConvertible {
    var detail: String?
    var data: String?
}
struct SubscriptionResponse: ParameterConvertible {
    var detail: String?
    var data: UserData?
}
struct TransactionResponse: ParameterConvertible {
    var detail: String?
    var data: [Transaction]?
}
struct Transaction: ParameterConvertible {
    var name: String?
    var amount: Float?
    var date: String?
    var pending: Bool?
    var isoCurrencyCode: String?
}
struct BudgetCategoryResponse: ParameterConvertible {
    var detail: String?
    var data: [BudgetCategory]?
}
struct BudgetCategory: ParameterConvertible {
    var categoryId: Int?
    var categoryName: String?
    var setBudget: Float?
    var nextMonthSetBudget: Float?
    var spend: Float?
    var lastMonthSpend: Float?
    var serverDate: String?
    var categoryCreatedAt: String?
    var categoryUpdatedAt: String?
    var isoCurrencyCode: String?
}
struct PortfolioTransactionResponse: ParameterConvertible {
    var detail: String?
    var data: [PortfolioTransaction]?
}
struct PortfolioTransaction: ParameterConvertible {
    var name: String?
    var institutionValue: Float?
    var institutionPrice: Float?
    var quantity: Float?
    var costBasis: Float?
    var isoCurrencyCode: String?
}
