//
//  PlayViewController.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 02/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

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
   
    var skipCounter: Int = 0
    var correctCounter: Int = 0
    var time: Int = 0 {
        didSet(oldValue) {
            timeLabel.text = String(time)
        }
    }
    
    var game: Game!
    var timer: Timer!
    
    var animator: UIViewPropertyAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        time = game.time
        
        backgroundView.transform = CGAffineTransform(translationX: -ScreenWidth, y: 0)
        animator = UIViewPropertyAnimator(duration: Double(time), curve: .linear) {
            self.backgroundView.transform = CGAffineTransform.identity
        }
        animator?.startAnimation()
        
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.time -= 1
           // self.animator?.fractionComplete = CGFloat(self.time)/CGFloat(self.game.time)
            if self.time == 0 {
                timer.invalidate()
            }
        }
        
    }
    
    // MARK: Action
    
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        skipCounter += 1
        skippedLabel.text = "\(skipCounter) skipped"
    }
    

    @IBAction func correctButtonClicked(_ sender: UIButton) {
        correctCounter += 1
        correctLabel.text = "\(correctCounter) correct"
    }
    
    @IBOutlet weak var pauseButtonClicked: UIButton!
    
}
