//
//  YoutubeHelper.swift
//  YoutubeParser
//
//  Created by KiwiTech on 21/10/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit
import HCVimeoVideoExtractor

class VideoExtractor {
    enum VideoQuality {
        case low,
        medium,
        high
        func youtubeQuality(from values: [AnyHashable: URL]) -> XCDYouTubeVideoQuality {
            switch self {
            case .low:
                return .small240
            case .medium:
                if values[XCDYouTubeVideoQuality.medium360.rawValue] != nil {
                    return .medium360
                }
                return .small240
            case .high:
                if values[XCDYouTubeVideoQuality.HD720.rawValue] != nil {
                    return .HD720
                } else if values[XCDYouTubeVideoQuality.medium360.rawValue] != nil {
                    return .medium360
                }
                return .small240
            }
        }
        func vimeoQuality(from values: [HCVimeoVideoQuality: URL]) -> HCVimeoVideoQuality {
            switch self {
            case .low:
                return .Quality360p
            case .medium:
                if values[.Quality540p] != nil {
                    return .Quality540p
                }
                return .Quality360p
            case .high:
                if values[.Quality720p] != nil {
                    return .Quality720p
                } else if values[.Quality540p] != nil {
                    return .Quality540p
                }
                return .Quality360p
            }
        }
    }
    static let main = VideoExtractor()
    private weak var loadOpertaion: XCDYouTubeOperation?
    private init () {
    }
    func getDownloadURL(
        for url: String,
        with quality: VideoQuality = .medium,
        onCompletion: @escaping (URL?, Error?) -> Void) {
        if url.isYoutubeURL,
            let videoId = youtubeId(from: url) {
            self.getYoutubeDownloadURL(with: videoId, videoQuality: quality, onCompletion: onCompletion)
        } else if url.isVimeoURL {
            self.getVimeoDownloadURL(with: url, videoQuality: quality, onCompletion: onCompletion)
        } else {
            let url = URL(string: url)
            onCompletion(url, nil)
        }
    }
    func youtubeId(from url: String) -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: url.count)
        guard let result = regex?.firstMatch(in: url, range: range) else {
            return nil
        }
        return (url as NSString).substring(with: result.range)
    }
    func getYoutubeDownloadURL(
        with videoId: String,
        videoQuality: VideoQuality = .medium,
        onCompletion: @escaping (URL?, Error?) -> Void) {
        loadOpertaion = XCDYouTubeClient.default()
            .getVideoWithIdentifier(videoId) { (video, error) in
                guard error == nil else {
                    onCompletion(nil, error)
                    return
                }
                guard let urls = video?.streamURLs else {
                    let streamError = NSError(
                        domain: Bundle.main.bundleIdentifier ?? "com.app.ios", code: -800,
                        userInfo: [NSLocalizedDescriptionKey: "No stream URL available."])
                    onCompletion(nil, streamError)
                    return
                }
                let quality = videoQuality.youtubeQuality(from: urls)
                let url = urls[quality.rawValue]
                onCompletion(url, nil)
        }
    }
    func getVimeoDownloadURL(with url: String,
                             videoQuality: VideoQuality = .medium,
                             onCompletion: @escaping (URL?, Error?) -> Void) {
        guard let url = URL(string: url) else {
            let urlError = NSError(
                domain: Bundle.main.bundleIdentifier ?? "com.app.ios", code: -800,
                userInfo: [NSLocalizedDescriptionKey: "Invalid URL."])
            onCompletion(nil, urlError)
            return
        }
        HCVimeoVideoExtractor.fetchVideoURLFrom(url: url, completion: { (video: HCVimeoVideo?, error: Error?) -> Void in
            if let err = error {
                onCompletion(nil, err)
                return
            }
            guard let vid = video else {
                let videoError = NSError(
                    domain: Bundle.main.bundleIdentifier ?? "com.app.ios", code: -800,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid video object."])
                onCompletion(nil, videoError)
                return
            }
            let quality = videoQuality.vimeoQuality(from: vid.videoURL)
            if let videoURL = vid.videoURL[quality] {
                onCompletion(videoURL, nil)
            }
        })
    }
}
