//
//  MediaPlayer.swift
//  MediaPlayer
//
//  Created by Fethi El Hassasna on 2017-11-11.
//  Copyright © 2017 Fethi El Hassasna (@fethica). All rights reserved.
//

import AVFoundation
import MediaPlayer
import Alamofire

// MARK: - MediaPlaybackState
@objc enum MediaPlaybackState: Int {
    
    case playing
    case paused
    case stopped
    
    var description: String {
        switch self {
        case .playing: return "Player is playing"
        case .paused: return "Player is paused"
        case .stopped: return "Player is stopped"
        }
    }
}

// MARK: - MediaPlayerState
@objc enum MediaPlayerState: Int {
    
    case urlNotSet
    case readyToPlay
    case loading
    case loadingFinished
    case error
    
    var description: String {
        switch self {
        case .urlNotSet: return "URL is not set"
        case .readyToPlay: return "Ready to play"
        case .loading: return "Loading"
        case .loadingFinished: return "Loading finished"
        case .error: return "Error"
        }
    }
}

// MARK: - FRadioPlayer
class MediaPlayer: NSObject {
    
    // MARK: - shared instance
    static let shared = MediaPlayer()

    // playback state
    static let playbackStateDidChangedNotification = NSNotification(name: NSNotification.Name(rawValue: "kPlaybackStateDidChangedNotification"), object: nil)
    // player state
    static let playerStateDidChangedNotification = NSNotification(name: NSNotification.Name(rawValue: "kPlayerStateDidChangedNotification"), object: nil)
    static let playerItemDidChangedNotification = NSNotification(name: NSNotification.Name(rawValue: "kPlayerItemDidChangedNotification"), object: nil)
    static let playerMetadataDidChangedNotification = NSNotification(name: NSNotification.Name(rawValue: "kPlayerMetadataDidChangedNotification"), object: nil)
    
    static let playerDurationDidChangedNotification = NSNotification(name: NSNotification.Name(rawValue: "kPlayerDurationDidChangedNotification"), object: nil)
    static let playerTimeDidChangedNotification = NSNotification(name: NSNotification.Name(rawValue: "kPlayerTimeDidChangedNotification"), object: nil)
    // track
    static let epsolideDidChangedNotification = NSNotification(name: NSNotification.Name(rawValue: "kEpsolideDidChangedNotification"), object: nil)
    static let currentTrackDidChangedNotification = NSNotification(name: NSNotification.Name(rawValue: "kCurrentTrackDidChangedNotification"), object: nil)
    static let trackListDidChangedNotification = NSNotification(name: NSNotification.Name(rawValue: "kTrackListDidChangedNotification"), object: nil)
    // sleep timer
    static let sleepTimerDidStartedNotification = NSNotification(name: NSNotification.Name(rawValue: "kSleepTimerDidStartedNotification"), object: nil)
    static let sleepTimerDidStoppedNotification = NSNotification(name: NSNotification.Name(rawValue: "kSleepTimerDidStoppedNotification"), object: nil)
    static let sleepTimerDidChangedNotification = NSNotification(name: NSNotification.Name(rawValue: "kSleepTimerDidChangedNotification"), object: nil)
    
    var volume: Float {
        get {
            return player.volume
        }
        set {
            player.volume = newValue
        }
    }
    
    // duration in seconds
    var duration: Double {
        if let playerItem = self.playerItem {
            let val = CMTimeGetSeconds(playerItem.duration)
            if val.isNaN || val.isInfinite {
                return 0
            }
            return val
        }
        else {
            return 0
        }
    }
    // current time in seconds
    var currentTime: Double {
        if let playerItem = self.playerItem {
            let val = CMTimeGetSeconds(playerItem.currentTime())
            if val.isNaN || val.isInfinite {
                return 0
            }
            return val
        }
        else {
            return 0
        }
    }
    
    var isPlaying: Bool {
        switch playbackState {
        case .playing:
            return true
        case .stopped, .paused:
            return false
        }
    }
    
    private(set) var state = MediaPlayerState.urlNotSet {
        didSet {
            guard oldValue != state else { return }
//            isLoading = (state == .loading) ? true : false
            NotificationCenter.default.post(name: MediaPlayer.playerStateDidChangedNotification.name, object: nil, userInfo: nil)
        }
    }
    
    private(set) var playbackState = MediaPlaybackState.stopped {
        didSet {
            guard oldValue != playbackState else { return }
            NotificationCenter.default.post(name: MediaPlayer.playbackStateDidChangedNotification.name, object: nil, userInfo: nil)
        }
    }
    
    var tracks = [Track]() {
        didSet {
            guard oldValue != tracks else { return }
            NotificationCenter.default.post(name: MediaPlayer.trackListDidChangedNotification.name, object: nil, userInfo: nil)
        }
    }
    
    private(set) var currentTrack: Track? {
        didSet {
            guard oldValue != currentTrack else { return }
            NotificationCenter.default.post(name: MediaPlayer.currentTrackDidChangedNotification.name, object: nil, userInfo: nil)
        }
    }
    
    // observerable property
    @objc dynamic var isLoadingTrack: Bool = false
    @objc dynamic var isLoading: Bool = false
    
    func playTrackAt(_ index: Int) {
        self.currentTrack = tracks[index]
        
        self.currentTrack!.loadArtworkImage(completion: {
            self.updateNowPlayingInfo()
            NotificationCenter.default.post(name: MediaPlayer.playerMetadataDidChangedNotification.name, object: nil, userInfo: nil)
        })
        
        self._preparePlay()
    }
    
    // MARK: - Private properties
    private var player = AVPlayer()
    private var headphonesConnected: Bool = false
    private var playerItem: AVPlayerItem? {
        willSet {
            guard newValue != playerItem else {
                return
            }
            
            if let item = playerItem {
                pause()
                
                item.removeObserver(self, forKeyPath: "status")
                item.removeObserver(self, forKeyPath: "playbackBufferEmpty")
                item.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
                item.removeObserver(self, forKeyPath: "timedMetadata")
                item.removeObserver(self, forKeyPath: "duration")
            }
        }
        
        didSet {
            guard oldValue != playerItem else {
                return
            }
            timedMetadataDidChange(rawValue: nil)
            
            if let item = playerItem {
                item.canUseNetworkResourcesForLiveStreamingWhilePaused = true
                item.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
                item.addObserver(self, forKeyPath: "playbackBufferEmpty", options: NSKeyValueObservingOptions.new, context: nil)
                item.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: NSKeyValueObservingOptions.new, context: nil)
                item.addObserver(self, forKeyPath: "timedMetadata", options: NSKeyValueObservingOptions.new, context: nil)
                item.addObserver(self, forKeyPath: "duration", options: NSKeyValueObservingOptions.new, context: nil)
                
                player.replaceCurrentItem(with: item)
                play()
            }
            
            NotificationCenter.default.post(name: MediaPlayer.playerItemDidChangedNotification.name, object: nil, userInfo: nil)
        }
    }
    
    private func _preparePlay() {
        self.stop()
        guard let url = currentTrack?.url else {
            state = .urlNotSet
            return
        }
        
        state = .loading
        
        let asset = AVAsset(url: url)
        let requestedKey = ["playable"]
        asset.loadValuesAsynchronously(forKeys: requestedKey) {
            DispatchQueue.main.async {
                var error: NSError?
                
                let keyStatus = asset.statusOfValue(forKey: "playable", error: &error)
                if keyStatus == AVKeyValueStatus.failed || !asset.isPlayable {
                    print("Error prepare player !!!!!")
                    return
                }
                self.playerItem = AVPlayerItem(asset: asset)
            }
        }
    }
    
    private let reachability = Reachability()!
    private var isConnected = false
    
    // MARK: - Sleep timer
    private var _sleepTimer: Timer?
    private var _timerCount: UInt = 0
    private var _sleepDuration: UInt = 0
    
    func scheduleSleepTimerWithDuration(_ seconds: UInt) {
        stopSleepTimer()
        _sleepDuration = seconds
        
        _sleepTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(_handleSleepTimerStick), userInfo: nil, repeats: true)
        NotificationCenter.default.post(name: MediaPlayer.sleepTimerDidStartedNotification.name, object: nil, userInfo: nil)
    }
    var isSleepTimerEnabled : Bool {
        return _sleepDuration != 0
    }
    var remainingSleepCount: UInt {
        return _sleepDuration - _timerCount
    }
    func stopSleepTimer() {
        _sleepDuration = 0
        _timerCount = 0
        
        if _sleepTimer != nil {
            _sleepTimer?.invalidate()
            _sleepTimer = nil
            NotificationCenter.default.post(name: MediaPlayer.sleepTimerDidStoppedNotification.name, object: nil, userInfo: nil)
        }
    }
    
    @objc private func _handleSleepTimerStick() {
        _timerCount += 1
        NotificationCenter.default.post(name: MediaPlayer.sleepTimerDidChangedNotification.name, object: nil, userInfo: nil)
        if _timerCount == _sleepDuration {
            stopSleepTimer()
            self.pause()
        }
    }
    
    // MARK: - Initialization
    private override init() {
        super.init()
                
        // Register notifications for audio session
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
        
        // Check for headphones
        checkHeadphonesConnection(outputs: AVAudioSession.sharedInstance().currentRoute.outputs)
        
        // Setup Remote Command Center Controls
        self.setupRemoteCommandCenter()
        
        // timed observer
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: nil) { (cmtime) in
            if self.playerItem?.status == .readyToPlay {
                NotificationCenter.default.post(name: MediaPlayer.playerTimeDidChangedNotification.name, object: nil, userInfo: nil)
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        // Reachability config
        try? reachability.startNotifier()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        isConnected = reachability.connection != .none
        
        // Enable bluetooth playback
        let audioSession = AVAudioSession.sharedInstance()
        if #available(iOS 10.0, *) {
            try? audioSession.setCategory(AVAudioSession.Category.playback, mode: .default)
        } else {
            try? audioSession.setMode(.default)
        }
        try? audioSession.setActive(true)
    }
    
    @objc func playerDidFinishPlaying(note: Notification) {
        if let currentTrack = self.currentTrack, currentTrack.isPodcast == true {
            next()
        }
    }
    // MARK: - deint
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("------- deinit MediaPlayer Object ---------")
    }
    
    // MARK: - Control Methods
    func play() {
        print("Status of player: \(player.status.rawValue)")
        print("Status of playerItem: \(String(describing: playerItem?.status.rawValue))")
        print("isPlaybackBufferFull of playerItem: \(String(describing: playerItem?.isPlaybackBufferFull))")
        print("isPlaybackBufferEmpty of playerItem: \(String(describing: playerItem?.isPlaybackBufferEmpty))")
        print("isPlaybackLikelyToKeepUp of playerItem: \(String(describing: playerItem?.isPlaybackLikelyToKeepUp))")
        player.play()
        playbackState = .playing
    }

    func pause() {
        player.pause()
        playbackState = .paused
    }
    
    func stop() {
        player.replaceCurrentItem(with: nil)
        playerItem = nil
        timedMetadataDidChange(rawValue: nil)
        playbackState = .stopped
    }
    
    func togglePlaying() {
        isPlaying ? pause() : play()
    }
    
    func seek(_ to: Double) {
        player.seek(to: CMTimeMakeWithSeconds(to, preferredTimescale: 1))
    }
    
    func next() {
       
    }
    
    
    func previous() {
        
    }
    
    // MARK: - Private helpers
    private func timedMetadataDidChange(rawValue: String?) {
        guard let rawValue = rawValue else {
            return
        }
        let parts = rawValue.components(separatedBy: " - ")
        currentTrack?.moreTitle1 = parts.first
        currentTrack?.moreTitle2 = parts.last
        
        updateNowPlayingInfo()
        NotificationCenter.default.post(name: MediaPlayer.playerMetadataDidChangedNotification.name, object: nil, userInfo: nil)
    }
    
    // MARK: - Responding to Interruptions
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        
        switch type {
        case .began:
            DispatchQueue.main.async { self.pause() }
        case .ended:
            guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { break }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            DispatchQueue.main.async {
                options.contains(.shouldResume) ? self.play() : self.pause()
            }
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        guard let reachability = note.object as? Reachability else { return }
        
        // Check if the internet connection was lost
        if reachability.connection != .none, !isConnected {
            checkNetworkInterruption()
        }
        
        isConnected = reachability.connection != .none
    }
    
    // Check if the playback could keep up after a network interruption
    private func checkNetworkInterruption() {
        guard
            let item = playerItem,
            !item.isPlaybackLikelyToKeepUp,
            reachability.connection != .none else { return }
        
        player.pause()
        
        // Wait 1 sec to recheck and make sure the reload is needed
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            if !item.isPlaybackLikelyToKeepUp {
                self.player.replaceCurrentItem(with: nil)
                self.player.replaceCurrentItem(with: self.playerItem)
            }
            self.isPlaying ? self.player.play() : self.player.pause()
        }
    }
    
    // MARK: - Responding to Route Changes
    private func checkHeadphonesConnection(outputs: [AVAudioSessionPortDescription]) {
        for output in outputs where output.portType == AVAudioSession.Port.headphones {
            headphonesConnected = true
            break
        }
        headphonesConnected = false
    }
    
    @objc private func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else { return }
        
        switch reason {
        case .newDeviceAvailable:
            checkHeadphonesConnection(outputs: AVAudioSession.sharedInstance().currentRoute.outputs)
        case .oldDeviceUnavailable:
            guard let previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription else { return }
            checkHeadphonesConnection(outputs: previousRoute.outputs);
            DispatchQueue.main.async { self.headphonesConnected ? () : self.pause() }
        default: break
        }
    }
    
    // MARK: - Remote Command Center Controls
    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { event in
            if self.player.rate == 0.0 {
                self.play()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { event in
            if self.player.rate == 1.0 {
                self.pause()
                return .success
            }
            return .commandFailed
        }
    }
    
    func updateNowPlayingInfo() {
        // Define Now Playing Info
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String : Any]()

        if let image = currentTrack?.artworkImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
        }
        if let title = currentTrack?.moreTitle1 {
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
        }
        if let artist = currentTrack?.moreTitle2 {
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        }

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let item = object as? AVPlayerItem, let keyPath = keyPath, item == self.playerItem {
            
            switch keyPath {
                
            case "status":
                
                if player.status == AVPlayer.Status.readyToPlay {
                    self.state = .readyToPlay
                } else if player.status == AVPlayer.Status.failed {
                    self.state = .error
                }
                
            case "playbackBufferEmpty":
                
                if item.isPlaybackBufferEmpty {
                    self.state = .loading
                    self.checkNetworkInterruption()
                }
                
            case "playbackLikelyToKeepUp":
                
                self.state = item.isPlaybackLikelyToKeepUp ? .loadingFinished : .loading
            
            case "timedMetadata":
                let rawValue = item.timedMetadata?.first?.value as? String
                timedMetadataDidChange(rawValue: rawValue)
            case "duration":
                NotificationCenter.default.post(name: MediaPlayer.playerDurationDidChangedNotification.name, object: nil, userInfo: nil)
            default:
                break
            }
        }
    }
}
