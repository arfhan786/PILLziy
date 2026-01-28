//
//  LoopingPillVideoView.swift
//  PILLziy
//
//  Created by Arfhan Ahmad on 1/24/26.
//

import SwiftUI
import AVFoundation

struct LoopingPillVideoView: UIViewRepresentable {
    /// Video file name without extension (e.g. "DashboardVideo")
    var videoName: String = "DashboardVideo"

    /// Control playback without removing/hiding the video.
    var isPlaying: Bool = true

    func makeUIView(context: Context) -> PillVideoUIView {
        let view = PillVideoUIView()
        view.setupPlayer(videoName: videoName)
        return view
    }

    func updateUIView(_ uiView: PillVideoUIView, context: Context) {
        uiView.layoutPlayerLayer()
        uiView.setVideoIfNeeded(videoName: videoName)
        uiView.setPlaying(isPlaying)
    }
}

final class PillVideoUIView: UIView {
    private var player: AVPlayer?
    private var endObserver: NSObjectProtocol?
    private var currentVideoName: String?
    private let playerLayer = AVPlayerLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.backgroundColor = UIColor.clear.cgColor
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

    func setupPlayer(videoName: String) {
        currentVideoName = videoName
        removeEndObserver()
        player?.pause()
        player = nil
        playerLayer.player = nil

        let url = Bundle.main.url(forResource: videoName, withExtension: "MP4", subdirectory: "Resources")
            ?? Bundle.main.url(forResource: videoName, withExtension: "mp4", subdirectory: "Resources")
            ?? Bundle.main.url(forResource: videoName, withExtension: "MP4", subdirectory: "Videos")
            ?? Bundle.main.url(forResource: videoName, withExtension: "mp4", subdirectory: "Videos")
            ?? Bundle.main.url(forResource: videoName, withExtension: "MP4")
            ?? Bundle.main.url(forResource: videoName, withExtension: "mp4")

            // Back-compat fallback if old asset name still exists
            ?? Bundle.main.url(forResource: "Pill-video 2", withExtension: "MP4", subdirectory: "Resources")
            ?? Bundle.main.url(forResource: "Pill-video 2", withExtension: "MP4")
        guard let url = url else { return }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(.playback, mode: .default)
            try? session.setActive(true)
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            let avPlayer = AVPlayer(playerItem: playerItem)
            DispatchQueue.main.async {
                self.player = avPlayer
                self.playerLayer.player = avPlayer
                avPlayer.isMuted = false
                avPlayer.play()
                self.endObserver = NotificationCenter.default.addObserver(
                    forName: AVPlayerItem.didPlayToEndTimeNotification,
                    object: playerItem,
                    queue: .main
                ) { [weak self] _ in
                    self?.holdOnLastFrame()
                }
            }
        }
    }

    func setPlaying(_ isPlaying: Bool) {
        if isPlaying {
            if playerLayer.player == nil {
                // Reattach playerLayer if needed
                playerLayer.player = player
            }
            if player == nil {
                setupPlayer(videoName: currentVideoName ?? "DashboardVideo")
            } else {
                player?.play()
            }
        } else {
            // Pause but keep the last rendered frame visible
            player?.pause()
        }
    }

    func setVideoIfNeeded(videoName: String) {
        guard currentVideoName != videoName else { return }
        setupPlayer(videoName: videoName)
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
