//
//  PipManagerImp.swift
//  ExampleApp
//
//  Created by Ashish on 02/07/25.
//

import AVKit

class PipManagerImp: NSObject {
    
    static let shared: PipManagerImp = .init()
    
    private override init() {
        super.init()
        // Observe `willResignActiveNotification` notification to start Picture In Picture Mode
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        // Observe `didBecomeActiveNotification` notification to stop Picture In Picture Mode
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: - Private properties
    
    private var playerLayer: AVPlayerLayer?
    private var pipController: AVPictureInPictureController?
    private var _isShowingPip: Bool = false
    
    // MARK: - Private methods
    
    @objc private func appWillResignActive() {
        _startPip()
    }
    
    @objc private func appDidBecomeActive() {
        _stopPip()
    }
    
    private func _prewarmPip(playerLayer: AVPlayerLayer) {
        self.playerLayer = playerLayer
        // Check if avPlayerLayer avaialble and Picture In Picture Mode Supported
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            return
        }
        
        let contentSource = AVPictureInPictureController.ContentSource(playerLayer: playerLayer)
        // Creates a new Picture in Picture controller.
        pipController = AVPictureInPictureController(contentSource: contentSource)
        
        pipController?.canStartPictureInPictureAutomaticallyFromInline = true
        // Set Picture in Picture controller’s delegate object
        pipController?.delegate = self
    }
    
    private func _startPip() {
        guard let pipController, let playerLayer, playerLayer.player?.timeControlStatus == .playing else { return }
        pipController.startPictureInPicture()
        _isShowingPip = true
    }
    
    private func _stopPip() {
        guard let pipController, let playerLayer, playerLayer.player?.timeControlStatus == .playing else { return }
        pipController.stopPictureInPicture()
        _isShowingPip = false
    }
}

extension PipManagerImp: PipManager {
    
    func prewarmPip(playerLayer: AVPlayerLayer) {
        _prewarmPip(playerLayer: playerLayer)
    }
    
    func startPip() {
        _startPip()
    }
    
    func stopPip() {
        _stopPip()
    }
    
    func isShowingPip() -> Bool {
        return _isShowingPip
    }
    
    func resetPip() {
        _stopPip()
        pipController = nil
        playerLayer = nil
    }
}

extension PipManagerImp: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        debugPrint("[PiP] - Did Stop.")
    }
    
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        debugPrint("[PiP] - Did Start.")
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        debugPrint("[PiP] - Will Stop.")
    }
    
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        debugPrint("[PiP] - Will Start.")
        // force start playback again
        pictureInPictureController.playerLayer.player?.play()
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        debugPrint("[PiP] - Failed to Start. Error - \(error)")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        debugPrint("[PiP] - Restore User Interface.")
        completionHandler(true)
    }
}

func makeExampleViewController() -> ExampleViewController {
    return ExampleViewController(pipManager: PipManagerImp.shared)
}
