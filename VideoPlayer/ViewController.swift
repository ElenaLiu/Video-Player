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

class ViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: Properties
    var backgroundView: UIView!
    var searchController: UISearchController!
    var playVideoView: UIView!
    var buttonView: UIView!
    
    var playerItem:AVPlayerItem!
    var avplayer:AVPlayer!
    var playerLayer:AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpbackgroundView()
        setUpSearchBar()
        setUpPlayVideoView()
        setUpButtonView()

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            searchController.searchBar.isHidden = true
        } else {
            searchController.searchBar.isHidden = false
        }
    }
    
    func setUpbackgroundView() {
        
        backgroundView = UIView()
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo:self.view.heightAnchor).isActive = true
        backgroundView.backgroundColor = UIColor(red: 8/255, green: 21/255, blue: 35/255, alpha: 1)
        self.view.backgroundColor = UIColor(red: 8/255, green: 21/255, blue: 35/255, alpha: 1)
    }
    
    func setUpSearchBar() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Enter URL of video"
        clearSearchBarBackgroundColor()
        self.backgroundView.addSubview(searchController.searchBar)
    }
    
    func clearSearchBarBackgroundColor() {
        
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
        
        playVideoView = UIView()
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
        
        buttonView = UIView()
        
        let playButton = setUpPlayButton()
        let MuteButton = setUpMuteButton()
        
        backgroundView.addSubview(buttonView)
        buttonView.addSubview(playButton)
        buttonView.addSubview(MuteButton)
        
        playButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor).isActive = true
        playButton.topAnchor.constraint(equalTo: buttonView.topAnchor).isActive = true
        playButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor).isActive = true
        
        MuteButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor).isActive = true
        MuteButton.topAnchor.constraint(equalTo: buttonView.topAnchor).isActive = true
        MuteButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor).isActive = true
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        buttonView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        buttonView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20).isActive = true
        buttonView.widthAnchor.constraint(equalToConstant: backgroundView.frame.width).isActive = true
        buttonView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonView.backgroundColor = .black
    }
    
    func setUpPlayButton() -> UIButton {
        let playButton = UIButton()
        
        playButton.backgroundColor = .black
        playButton.setTitle("Play", for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        return playButton
    }
    
    func setUpMuteButton() -> UIButton {
        let MuteButton = UIButton()
        
        MuteButton.backgroundColor = .black
        MuteButton.setTitle("Mute", for: .normal)
        MuteButton.translatesAutoresizingMaskIntoConstraints = false
        MuteButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        return MuteButton
    }
}
