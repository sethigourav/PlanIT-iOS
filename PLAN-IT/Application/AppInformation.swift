//
//  AppInformation.swift
//  PLAN-IT
//
//  Created by KiwiTech on 27/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
internal enum AppInfoKeys: String {
    case appName = "CFBundleDisplayName"
    case appVersion = "CFBundleShortVersionString"
    case sandBox = "sandboxReceipt"
    case buildNumber = "CFBundleVersion"
}

// MARK: - Provides details of the current app.
public protocol AppInfo { }
public extension AppInfo {
    /// App's name.
    var appDisplayName: String? {
        return Bundle.main.object(forInfoDictionaryKey: AppInfoKeys.appName.rawValue) as? String
            ?? Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
    }
    /// App's bundle ID.
    var appBundleID: String? {
        return Bundle.main.bundleIdentifier
    }
    /// App's current version.
    var appVersion: String? {
        return Bundle.main.infoDictionary?[AppInfoKeys.appVersion.rawValue] as? String
    }
    var buildVersionNumber: String? {
        return Bundle.main.infoDictionary?[AppInfoKeys.buildNumber.rawValue] as? String
    }
    /// App current build number.
    var appBuild: String? {
        return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String
    }
}

// MARK: - Environment
public extension AppInfo {
    /// Check if app is running in TestFlight mode.
    var isInTestFlight: Bool {
        return Bundle.main.appStoreReceiptURL?.path.contains(AppInfoKeys.sandBox.rawValue) == true
    }
    /// Check if application is running on simulator (read-only).
    var isRunningOnSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
