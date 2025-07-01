//
//  ExampleViewController.swift
//  ExampleApp
//
//  Created by Ashish on 27/06/25.
//

import AVKit
import AVFoundation

class ExampleViewController: UIViewController {
    
    private let pipManager: PipManager
    private var playerLayer: AVPlayerLayer!
    
    init(pipManager: PipManager) {
        self.pipManager = pipManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pipButton)
        pipButton.addTarget(self, action: #selector(togglePip), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            pipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            pipButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        setupPlayer()
        
        pipManager.prewarmPip(playerLayer: playerLayer)
    }
    
    deinit {
        pipManager.resetPip()
    }
    
    // MARK: - Private properties
    
    private lazy var pipButton: UIButton! = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let startImage = AVPictureInPictureController.pictureInPictureButtonStartImage
        let stopImage = AVPictureInPictureController.pictureInPictureButtonStopImage
        
        button.setImage(startImage, for: .normal)
        button.setImage(stopImage, for: .selected)
        return button
    }()
    
    // MARK: - Private methods
    
    private func setupPlayer() {
        let url = URL(string: "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4")!
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch  {
            debugPrint("Error in setting audio session category. Error -\(error.localizedDescription)")
        }
        
        // Create the player layer (replace with your video player setup)
        let player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    @objc private func togglePip() {
        if pipManager.isShowingPip() {
            pipButton.isSelected = false
            pipManager.stopPip()
        } else {
            pipButton.isSelected = true
            pipManager.startPip()
        }
    }
}
