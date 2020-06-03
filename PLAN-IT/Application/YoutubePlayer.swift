//
//  YoutubePlayer.swift
//  Pipelines
//
//  Created by KiwiTech on 08/07/19.
//  Copyright © 2019 KiwiTech. All rights reserved.
//

import UIKit
class YoutubePlayer: NSObject {
    enum PlayerState {
        case buffering,
        playing,
        stopped
    }
    static fileprivate let player = WKYTPlayerView(frame: CGRect(x: 0, y: 0, width: 0.1, height: 0.1))
    var check = false
    fileprivate var statusCallback: ((PlayerState) -> Void)?
    func showYoutube(from view: UIView, videoId: String, statusUpdates: ((PlayerState) -> Void)? = nil) {
        YoutubePlayer.player.stopVideo()
        YoutubePlayer.player.removeFromSuperview()
        let params = ["controls": 0,
                      "playsinline": 1,
                      "autohide": 1,
                      "showinfo": 0,
                      "autoplay": 1]
        YoutubePlayer.player.frame = CGRect(origin: CGPoint.zero, size: view.bounds.size)
        YoutubePlayer.player.alpha = 0 // for full screen
        view.addSubview(YoutubePlayer.player)
        DispatchQueue.main.async {
            self.check = true
            YoutubePlayer.player.webView?.loadHTMLString("", baseURL: nil)
            YoutubePlayer.player.load(withVideoId: videoId, playerVars: params)
        }
        self.statusCallback = statusUpdates
        YoutubePlayer.player.delegate = self
        _ = NotificationCenter.default.addObserver(
            forName: UIWindow.didBecomeKeyNotification,
            object: view.window,
            queue: nil
        ) {[weak self] _ in
            self?.removePlayer()
            self?.statusCallback?(.stopped)
            UIApplication.topViewController()?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    func removePlayer() {
        YoutubePlayer.player.stopVideo()
        YoutubePlayer.player.removeFromSuperview()
        YoutubePlayer.player.delegate = nil
    }
    deinit {
        YoutubePlayer.player.stopVideo()
        YoutubePlayer.player.removeFromSuperview()
        YoutubePlayer.player.delegate = nil
        NotificationCenter.default.removeObserver(self)
    }
}
extension YoutubePlayer: WKYTPlayerViewDelegate {
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        if state == .ended {
            playerView.removeFromSuperview()
            statusCallback?(.stopped)
        } else if state == .buffering {
            statusCallback?(.buffering)
        } else if state == .playing {
            statusCallback?(.playing)
        }
    }
    func playerView(_ playerView: WKYTPlayerView, receivedError error: WKYTPlayerError) {
    }
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        playerView.playVideo()
    }
    func playerView(_ playerView: WKYTPlayerView, didPlayTime playTime: Float) {
    }
}
