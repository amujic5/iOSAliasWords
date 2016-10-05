//
//  PlayViewController.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 02/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit
import GoogleMobileAds

enum PlayState {
    case playing
    case pause
}

final class PlayViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var skippedLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
   
    @IBOutlet weak var extendedHeaderView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pauseResumeButtonWidthConstraint: NSLayoutConstraint!
    
    private var _playState: PlayState = .pause
    var skipCounter: Int = 0
    var correctCounter: Int = 0
    var time: Int = 0 {
        didSet(oldValue) {
            timeLabel.text = String(time)
        }
    }
    
    var game: Game!
    var timer: Timer?
    
    var animator: UIViewPropertyAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordLabel.alpha = 0
        loadBannerView()
        time = game.time
        registerForNotifications()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UIApplicationWillEnterForegroundNotification"), object: nil, queue: nil) { (_) in
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UIApplicationDidEnterBackgroundNotification"), object: nil, queue: nil) { (_) in
            self._pause()
        }
    }
    
    private func loadBannerView() {
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.adUnitID = "ca-app-pub-1489905432577426/4704470195" //prod
        //bannerView.adUnitID = "ca-app-pub-1489905432577426/3980544999" //android
        bannerView.rootViewController = self
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        let request = GADRequest()
        //request.testDevices = ["d3e0dc61958b32ff6b256dc384d82b2d"]
        bannerView.load(request)
    }
    
    private func startTimer() {
        if (self.time > 0) {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                self.time -= 1
                if self.time == 0 {
                    timer.invalidate()
                }
            }
            
            animator?.stopAnimation(true)
            let fractionCompleted = 1 - CGFloat(time) / CGFloat(game.time)
            backgroundView.transform = CGAffineTransform(translationX: -ScreenWidth * (1 - fractionCompleted), y: 0)
            animator = UIViewPropertyAnimator(duration: Double(time), curve: .linear) {
                self.backgroundView.transform = CGAffineTransform.identity
            }
            animator?.startAnimation()
        }
    }
    
    private func newWordLabel() {
        let newWord = game.newWord
        UIView.transition(with: wordLabel, duration: 0.2, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: { 
            self.wordLabel.text = newWord
            }) { (_) in
                
        }
    }
    
    private func _pause() {
        _playState = .pause
        
        self.timer?.invalidate()
        self.animator?.pauseAnimation()
        
        headerViewHeightConstraint.constant = 150
        
        UIView.transition(with: pauseButton, duration: 0.15, options: .transitionCrossDissolve, animations: {
            self.pauseButton.setTitle("Resume", for: .normal)
        }) { (_) in
        }
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3, options: [], animations: {
            self.overlayView.alpha = 1
            self.extendedHeaderView.alpha = 1
            self.wordLabel.alpha = 0
            self.view.layoutIfNeeded()

            }, completion: nil)

    }
    
    private func _resume() {
        _playState = .playing
        
        pauseResumeButtonWidthConstraint.constant = 40
        headerViewHeightConstraint.constant = 75
        
        self.startTimer()
        UIView.transition(with: pauseButton, duration: 0.15, options: .transitionCrossDissolve, animations: {
            
            self.pauseButton.setTitle("||", for: .normal)
            self.pauseButton.setTitleColor(UIColor.black, for: .normal)
            self.pauseButton.backgroundColor = UIColor.clear
            //self.pauseButton.setImage(UIImage(named: "ic_check_box_selected"), for: .normal)
        }) { (_) in
        }
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.8, options: [], animations: {
            self.overlayView.alpha = 0
            self.extendedHeaderView.alpha = 0
            self.wordLabel.alpha = 1
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    // MARK: Action
    
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        skipCounter += 1
        skippedLabel.text = "\(skipCounter) skipped"
        newWordLabel()
    }
    

    @IBAction func correctButtonClicked(_ sender: UIButton) {
        correctCounter += 1
        correctLabel.text = "\(correctCounter) correct"
        newWordLabel()
    }
    
    @IBAction func pauseResumeButtonClicked(_ sender: UIButton) {
        
        switch _playState {
        case .pause:
            _resume()
        case .playing:
            _pause()
        }
    }

    
}
