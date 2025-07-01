//
//  PipManager.swift
//  ExampleApp
//
//  Created by Ashish on 02/07/25.
//

import AVKit

protocol PipManager {
    func prewarmPip(playerLayer: AVPlayerLayer)
    func startPip()
    func stopPip()
    func isShowingPip() -> Bool
    func resetPip()
}
