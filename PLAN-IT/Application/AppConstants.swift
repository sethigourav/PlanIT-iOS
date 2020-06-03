//
//  AppConstants.swift
//  i-Mar
//
//  Created by KiwiTech on 28/06/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation

let plaidPublicKey = "a0d7705ff5c59d524e4540014d3cca"
let productID = "com.imar.planit.monthly"
let supportEmail = "planitappmobi@gmail.com"
let ACCEPTABLECHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

enum UserDefaultsKeys: String {
    case loggedIn,
    userDetails,
    initialViewController,
    userFeedback,
    fcmToken
}
enum ImageNameConstants: String {
    case iconBack,
    iconError,
    iconAgree,
    iconAgree2,
    iconAgree2Sel,
    iconAgreeSel,
    iconNotAgree,
    iconNotAgree2,
    iconNotAgree2Sel,
    iconNotAgreeSel,
    iconBlacktick,
    iconGreentick,
    iconSuccess,
    iconLock,
    iconPlay,
    iconTick,
    iconSubscribeLib,
    cross,
    network,
    transactions,
    library,
    radioSelected,
    radioGray,
    course
}
enum Storyboards: String, ParameterConvertible {
    case main = "Main",
    tabbar = "TabBar"
    func file() -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
// MARk: Screen Size
struct ScreenSize {
    static let screenWidth         = UIScreen.main.bounds.size.width
    static let screenHeight        = UIScreen.main.bounds.size.height
    static let screenMaxLength     = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength    = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}
// MARk: Device Type
struct DeviceType {
    static let IsIPhone4OrLess  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength < 568.0
    static let IsIPhone5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength <= 568.0
    static let IsIphone6Or7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
    static let IsIphone6Por7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 736.0
    static let IsIPad              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.screenMaxLength == 1024.0
    static let IsIpadPro          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.screenMaxLength == 1366.0
    static let ISIPHONEX         = UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
    static let ISIPHONEXSMax        = UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2688
    static let ISIPHONEXR        = UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height >= 1792
}
struct ThumbnailUrl {
    static let youtubeThumbnailURL: (String) -> String = { (videoId) in
        let urlStr = "https://img.youtube.com/vi/\(videoId)/mqdefault.jpg"
        return urlStr
    }
}
