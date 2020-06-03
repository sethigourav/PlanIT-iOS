//
//  AppUtils.swift
//  i-Mar
//
//  Created by KiwiTech on 28/06/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
class AppUtils {
    static let reachablityManager = NetworkReachabilityManager()
    static var dict = [String: UIImage]()
    class func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: 1, preferredTimescale: 1)
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let image = UIImage(cgImage: imageRef)
            return image
        } catch {
            print(error)
            return nil
        }
    }
    static func remove(file path: URL)throws {
        do {
            try FileManager.default.removeItem(at: path)
        } catch let error {
            throw error
        }
    }
    static func setBudgetForCurrentMonth(date: String) -> Bool {
        let serverDate = Calendar.current.dateComponents([.day], from: AppUtils.fetchBudgetDate(fromStr: date)).day ?? 0
        return serverDate >= 1 && serverDate <= 7
    }
    static func getSymbol(forCurrencyCode code: String) -> String? {
        return NSLocale(localeIdentifier: code).displayName(forKey: .currencySymbol, value: code)
    }
    static func getCurrencySymbol(forCurrencyCode code: String, amount: Float) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let symbol = NSLocale(localeIdentifier: code).displayName(forKey: .currencySymbol, value: code)
        formatter.currencySymbol = symbol
        return formatter.string(from: amount as NSNumber)
    }
    static func youtubeId(from url: String) -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: url.count)
        guard let result = regex?.firstMatch(in: url, range: range) else {
            return nil
        }
        return (url as NSString).substring(with: result.range)
    }
    class func identifyXSeries() -> Bool {
        if DeviceType.ISIPHONEX || DeviceType.ISIPHONEXSMax || DeviceType.ISIPHONEXR {
            return true
        }
        return false
    }
    class func viewController(with identifier: String, in storyboard: Storyboards = .main) -> UIViewController {
        let viewContoller = storyboard.file().instantiateViewController(withIdentifier: identifier)
        return viewContoller
    }
    fileprivate static var banner: BannerHandler?
    class func showBanner(with text: String, type: BannerType = .error) {
        if banner == nil {
            banner = BannerHandler()
        }
        banner?.showBanner(with: text, type: (text == .noInternet) ? .noInternet : type)
    }
    static func randomString(length: Int = 5) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map { _ in letters.randomElement()! })
    }
    static func image(name: String) -> UIImage? {
        if let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(name) {
            if let data = try? Data(contentsOf: imageURL) {
                let image = UIImage(data: data)
                return image
            }
        }
        return nil
    }
    static func remove(image path: URL)throws {
        do {
            try FileManager.default.removeItem(at: path)
        } catch let error {
            throw error
        }
    }
    static func dateConversion(strDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let date = formatter.date(from: strDate)
        formatter.dateFormat = "yyyy-MM-dd"
        var dateStr = ""
        if date != nil {
            dateStr = formatter.string(from: date!)
        }
        return dateStr
    }
    static func fetchBudgetDate(fromStr: String) -> Date {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = .budgetDateFormat
        return dateFormatter.date(from: fromStr) ?? Date()
    }
    static func fetchDate(fromStr: String) -> Date {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = .dateFormat
        return dateFormatter.date(from: fromStr) ?? Date()
    }
    static func fetchDateStr(fromDate: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = .dateFormat
        return dateFormatter.string(from: fromDate).uppercased()
    }
    static func getScreenBasedScaledValueOfConstant(_ constant: CGFloat) -> CGFloat {
        let scaleFactor = (UIScreen.main.bounds.size.height / 667.0)
        return constant * scaleFactor
    }
    static func currentMonthYear() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MMMM yyyy"
        let formattedDate = format.string(from: date)
        return formattedDate.uppercased()
    }
    static func nexttMonth(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "MMMM"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    static func transDateConversion(strDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: strDate)
        formatter.dateFormat = "MM/dd/yyyy"
        var dateStr = ""
        if date != nil {
            dateStr = formatter.string(from: date!)
        }
        return dateStr
    }
    @discardableResult
    static func saveImageInTemp(image file: UIImage, name: String)throws -> URL {
        guard let imageData = file.jpegData(
            compressionQuality: 0.8) else {
                throw ImageSaveErrors.dataConversionFailed
        }
        do {
            if let imageURL = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first?.appendingPathComponent(name) {
                try imageData.write(to: imageURL)
                return imageURL
            } else {
                throw ImageSaveErrors.invalidFilePath
            }
        } catch let error {
            throw error
        }
    }
    static func subscriptionDateFormat(
          date: String,
          currentFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ",
          toFormat changeFormat: String = "MMM d, yyyy"
      ) -> String {
          let formatter = DateFormatter()
          formatter.dateFormat = currentFormat
          let date = formatter.date(from: date)
          formatter.dateFormat = changeFormat
          var dateStr = ""
          if date != nil {
              dateStr = formatter.string(from: date!)
          }
          return dateStr
      }
    static func changeDateFormat(
        date: String,
        currentFormat: String = "yyyy-MM-dd",
        toFormat changeFormat: String = "MMM d, yyyy"
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = currentFormat
        let date = formatter.date(from: date)
        formatter.dateFormat = changeFormat
        var dateStr = ""
        if date != nil {
            dateStr = formatter.string(from: date!)
        }
        return dateStr
    }
    static func getTodayDate() -> String {
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let todayString = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        return todayString
    }
}
extension Date {
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
}
extension UIColor {
    var isLightColor: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
}
extension UserDefaults {
    func value(for key: UserDefaultsKeys) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
    func set(value: Any?, for key: UserDefaultsKeys) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    func set(object: ParameterConvertible, for key: UserDefaultsKeys) {
        let value = try? object.toParams()
        UserDefaults.standard.set(value ?? nil, forKey: key.rawValue)
    }
    func removeValue(for key: UserDefaultsKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
extension UIViewController {
    static var navIdentifier: String {
        return String(describing: self) + "Nav"
    }
    static func loadFromNib<T: UIViewController>() -> T {
        return T(nibName: String(describing: self), bundle: nil)
    }
    var embededInNavController: UINavigationController {
        let navCtrl = BaseNavController(rootViewController: self)
        return navCtrl
    }
}
extension NSObject {
    static var identifier: String {
        return String(describing: self)
    }
}
class CustomiseButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
}
class CustomiseView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
}
class CustomiseTextField: UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder!: "", attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor!])
        }
    }
}
extension UIView {
    func rounded(with radius: CGFloat? = nil) {
        layer.cornerRadius = radius ?? frame.height/2
        layer.masksToBounds = true
        clipsToBounds = true
    }
    func bordered(width: CGFloat = 1, color: UIColor = .white) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
extension UIButton {
    func disabled() {
        titleLabel?.alpha = 0.2
        isUserInteractionEnabled = false
    }
    func enabled() {
        titleLabel?.alpha = 1
        isUserInteractionEnabled = true
    }
}
extension UIImage {
    convenience init(named: ImageNameConstants) {
        self.init(named: named.rawValue)!
    }
    func normalizedImage() -> UIImage? {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        let normalizedImage =  UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
extension UIFont {
    enum FontName: String {
        case karla = "Karla"
    }
    enum FontVarient: String {
        case bold = "Bold",
        boldItalic = "BoldItalic",
        italic = "Italic",
        regular = "Regular"
    }
    convenience init?(font: (name: FontName, varient: FontVarient), size: CGFloat) {
        let name = font.name.rawValue + "-" + font.varient.rawValue
        self.init(name: name, size: size)
    }
}
enum ImageSaveErrors: Error {
    case dataConversionFailed,
    invalidFilePath
}
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}
extension UIAlertController {
    open override var shouldAutorotate: Bool {
        return false
    }
}
extension UIDevice {
    var isiPhone5: Bool {
        let maxValue = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        //check for iphone 5
        if maxValue == 568 {
            return true
        }
        return false
    }
    class func isiPhoneXVariant() -> Bool {
        if (UIScreen.main.bounds.width / UIScreen.main.bounds.height) == 0.4618226600985222 {
            return true
        }
        if (UIScreen.main.bounds.width / UIScreen.main.bounds.height) == 0.46205357142857145 {
            return true
        }
        return false
    }
}
