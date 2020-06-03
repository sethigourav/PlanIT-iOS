//
//  LessonDetailDownloadHandler.swift
//  PLAN-IT
//
//  Created by KiwiTech on 27/09/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import Foundation
import Photos
extension LessonDetailViewController {
    func downloadVideoLinkAndCreateAsset(_ videoId: Int64, _ videoLink: String, _ completion: @escaping (URL?, Int64, Bool) -> Void) {
        // use guard to make sure you have a valid url
        guard let videoURL = URL(string: videoLink) else { return }
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        // check if the file already exist at the destination folder if you don't want to download it twice
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent).path) {
            // set up your download task
            downloadSession.downloadTask(with: videoURL) { (location, _, error) -> Void in
                // use guard to unwrap your optional url
                guard let location = location, error == nil else {
                    if error?._code == 28 {
                        DispatchQueue.main.async {
                            AppUtils.showBanner(with: "Sorry, we could not download as you have consumed 100% of your memory.")
                        }
                    }
                    completion(nil, videoId, false)
                    return
                }
                // create a deatination url
                let destinationURL = documentsDirectoryURL.appendingPathComponent(AppUtils.randomString() + ".mp4")
                do {
                    try FileManager.default.moveItem(at: location, to: destinationURL)
                    completion(destinationURL, videoId, true)
                } catch {
                    print(error)
                    completion(nil, videoId, false)
                }}.resume()
        } else {
            let videoUrl = documentsDirectoryURL.appendingPathComponent(videoURL.lastPathComponent)
            completion(videoUrl, videoId, true)
            print("File already exists at destination url")
        }
    }
    func dowloadImageFromServer(url: URL, completion: @escaping (UIImage?) -> (Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            if data.count > 0 {
                completion(image)
            } else {
                completion(nil)
            }
            }.resume()
    }
}
