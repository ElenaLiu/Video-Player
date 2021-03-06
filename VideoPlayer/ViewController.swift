//
//  ViewController.swift
//  VideoPlayer
//
//  Created by 劉芳瑜 on 2018/1/19.
//  Copyright © 2018年 Fang-Yu. Liu. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    // MARK: Properties
    var backgroundView: UIView = UIView()
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var playVideoView: UIView = UIView()
    var buttonView: UIView = UIView()

    var player: AVPlayer!
    let playButton = UIButton()
    let muteButton = UIButton()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpbackgroundView()
        setUpPlayVideoView()
        setUpSearchBar()
        setUpButtonView()
    }
    
    deinit {
        player.removeObserver(self, forKeyPath: "rate")
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            searchController.searchBar.isHidden = true
        } else {
            searchController.searchBar.isHidden = false
        }
    }

    func setUpbackgroundView() {

        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -20).isActive = true
        backgroundView.backgroundColor = UIColor(red: 8/255, green: 21/255, blue: 35/255, alpha: 1)
        self.view.backgroundColor = UIColor(red: 8/255, green: 21/255, blue: 35/255, alpha: 1)
    }

    func setUpSearchBar() {

        searchController.searchBar.delegate = self

        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Enter URL of video"
        setUpSearchBarBackgroundColor()
        self.backgroundView.addSubview(searchController.searchBar)
    }

    func setUpSearchBarBackgroundColor() {

        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }

        for view in searchController.searchBar.subviews {
            for subview in view.subviews {
                if subview.isKind(of: UISearchBarBackground) {
                    subview.alpha = 0
                }
            }
        }
    }

    func setUpPlayVideoView() {

        backgroundView.addSubview(playVideoView)
        playVideoView.translatesAutoresizingMaskIntoConstraints = false
        playVideoView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        playVideoView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        playVideoView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0).isActive = true
        playVideoView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 0).isActive = true
        playVideoView.widthAnchor.constraint(equalToConstant: backgroundView.frame.width).isActive = true
        playVideoView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    func setUpButtonView() {

        let playButton = setUpPlayButton()
        let muteButton = setUpMuteButton()

        backgroundView.addSubview(buttonView)
        buttonView.addSubview(playButton)
        buttonView.addSubview(muteButton)

        playButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor).isActive = true
        playButton.topAnchor.constraint(equalTo: buttonView.topAnchor).isActive = true
        playButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor).isActive = true

        muteButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor).isActive = true
        muteButton.topAnchor.constraint(equalTo: buttonView.topAnchor).isActive = true
        muteButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor).isActive = true

        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        buttonView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        buttonView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 0).isActive = true
        buttonView.widthAnchor.constraint(equalToConstant: backgroundView.frame.width).isActive = true
        buttonView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonView.backgroundColor = .black
    }

    func setUpPlayButton() -> UIButton {
        
        playButton.isUserInteractionEnabled = true
        playButton.backgroundColor = .black
        playButton.setTitle("Play", for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        playButton.addTarget(self, action: #selector(playAndPause), for: .touchUpInside)
        return playButton
    }
    
    @objc func playAndPause() {
        
        guard let avPlayer = player else { return }
        if avPlayer.rate > 0 {
            avPlayer.pause()
        }else {
            avPlayer.play()
        }
    }

    func setUpMuteButton() -> UIButton {

        muteButton.backgroundColor = .black
        muteButton.setTitle("Mute", for: .normal)
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        muteButton.addTarget(self, action: #selector(muteAndUnmute), for: .touchUpInside)
        return muteButton
    }
    
    @objc func muteAndUnmute() {
        
        guard let avplayer = player else { return }
        avplayer.isMuted = !avplayer.isMuted
        if avplayer.isMuted {
            muteButton.setTitle("Mute", for: .normal)
        } else {
            muteButton.setTitle("UnMute", for: .normal)
        }
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let urlString = searchBar.text ?? ""
        if let url = URL(string: urlString) {
            setUpAVPlayer(url: url)
        }
    }

    func setUpAVPlayer(url: URL) {
        
        let urlString = url
        player = AVPlayer(url: urlString)
        // Set up KVO
        player.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)

        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.playVideoView.addSubview(playerController.view)
        playerController.view.frame = self.playVideoView.frame
        player.play()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "rate" {
            if player.rate > 0 {
                playButton.setTitle("Pause", for: .normal)

                print("video started")
            }else {
                playButton.setTitle("Play", for: .normal)

            }
        }
    }
}
