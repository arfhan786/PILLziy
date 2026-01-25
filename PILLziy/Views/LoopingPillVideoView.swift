//
//  LoopingPillVideoView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI
import AVFoundation

struct LoopingPillVideoView: UIViewRepresentable {
    func makeUIView(context: Context) -> PillVideoUIView {
        let view = PillVideoUIView()
        view.setupPlayer()
        return view
    }

    func updateUIView(_ uiView: PillVideoUIView, context: Context) {
        uiView.layoutPlayerLayer()
    }
}

private let videoPlayedKey = "PILLziyVideoHasBeenPlayed"

final class PillVideoUIView: UIView {
    private var player: AVPlayer?
    private var endObserver: NSObjectProtocol?
    private let playerLayer = AVPlayerLayer()

    private static var hasBeenPlayed: Bool {
        get { UserDefaults.standard.bool(forKey: videoPlayedKey) }
        set {
            UserDefaults.standard.set(newValue, forKey: videoPlayedKey)
            UserDefaults.standard.synchronize()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspect
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        if let token = endObserver {
            NotificationCenter.default.removeObserver(token)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutPlayerLayer()
    }

    func setupPlayer() {
        guard let url = Bundle.main.url(forResource: "PILLziyVideo", withExtension: "MP4", subdirectory: "Resources")
            ?? Bundle.main.url(forResource: "PILLziyVideo", withExtension: "MP4") else {
            return
        }

        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)

        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        let avPlayer = AVPlayer(playerItem: playerItem)

        player = avPlayer
        playerLayer.player = avPlayer
        avPlayer.isMuted = false

        if Self.hasBeenPlayed {
            seekToLastFrameAndPauseWhenReady(avPlayer, item: playerItem, asset: asset)
            return
        }

        Self.hasBeenPlayed = true
        avPlayer.play()

        endObserver = NotificationCenter.default.addObserver(
            forName: AVPlayerItem.didPlayToEndTimeNotification,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            self?.holdOnLastFrame()
        }
    }

    private func seekToLastFrameAndPauseWhenReady(_ avPlayer: AVPlayer, item: AVPlayerItem, asset: AVAsset) {
        asset.loadValuesAsynchronously(forKeys: ["duration"]) { [weak self] in
            var error: NSError?
            guard asset.statusOfValue(forKey: "duration", error: &error) == .loaded,
                  let player = self?.player else { return }
            let duration = asset.duration
            let seconds = CMTimeGetSeconds(duration)
            guard seconds.isFinite, seconds > 0 else { return }
            let seekTime = CMTime(seconds: max(0, seconds - 0.03), preferredTimescale: 600)
            player.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
                DispatchQueue.main.async { player.pause() }
            }
        }
    }

    private func holdOnLastFrame() {
        guard let avPlayer = player,
              let item = avPlayer.currentItem else { return }

        let duration = item.duration
        let seconds = CMTimeGetSeconds(duration)
        guard seconds.isFinite, seconds > 0 else {
            avPlayer.pause()
            removeEndObserver()
            return
        }

        let seekTime = CMTime(seconds: max(0, seconds - 0.03), preferredTimescale: 600)
        avPlayer.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            avPlayer.pause()
            self?.removeEndObserver()
        }
    }

    private func removeEndObserver() {
        if let token = endObserver {
            NotificationCenter.default.removeObserver(token)
            endObserver = nil
        }
    }

    func layoutPlayerLayer() {
        playerLayer.frame = bounds
    }
}
