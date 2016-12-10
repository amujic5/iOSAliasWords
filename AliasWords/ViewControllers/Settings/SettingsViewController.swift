//
//  SettingsViewController.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 13/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit
import UICountingLabel

final class SettingsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var rightStackView: UIStackView!
    
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rightStackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var vsParentView: UIView!
    @IBOutlet weak var vsLabel: UILabel!
    
    @IBOutlet weak var scoreSlider: UISlider!
    @IBOutlet weak var totalScoreLabel: UICountingLabel!
    @IBOutlet weak var scoreUnderscoreView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var timeLabel: UICountingLabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var dictionaryLabel: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var settingsToNewGameInteractiveSegue: SettingsToNewGameSegue?
    
    var teams: [Team] = []
    var dictionaries: [Dictionary] = []
    
    var game: Game {
        let time = Int(timeSlider.value)
        let goalScore = Int(scoreSlider.value)
        
        var selectedDictionary = dictionaries[0]
        if let selectedIndex = collectionView.indexPathsForSelectedItems?.first?.row {
            selectedDictionary = dictionaries[selectedIndex]
        }
        
        return Game(time: time, goalScore: goalScore, teams: teams, dictionary: selectedDictionary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDictionaries()
        fillStackView()
        
        //vs
        vsParentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        vsParentView.alpha = 0
        vsLabel.alpha = 0
        vsLabel.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2/3))
        
        UIView.animate(withDuration: 0.6, animations: { 
            self.vsParentView.transform = CGAffineTransform.identity
            self.vsParentView.alpha = 1
            }, completion: { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    
                }) 
        }) 
        
        UIView.animate(withDuration: 0.3, delay: 0.35, options: UIViewAnimationOptions(), animations: {
            self.vsLabel.transform = CGAffineTransform.identity
            self.vsLabel.alpha = 1
            }, completion: nil)
        
        
        animateScoreIntro()
        animateTimeIntro()

    }
    
    func animateTimeIntro() {
        timeLabel.format = "%d"
        timeLabel.method = .easeInOut
        timeLabel.count(from: 20, to: 60, withDuration: 0.9)
        
        self.timeSlider.value = 20;
        delay(seconds: 0.15) {
            UIView.animate(withDuration: 0.7, animations: {
                self.timeSlider.setValue(60, animated: true)
            })
        }

    }
    
    func animateScoreIntro() {
        totalScoreLabel.format = "%d"
        totalScoreLabel.method = .easeInOut
        totalScoreLabel.count(from: 60, to: 100, withDuration: 0.9)
        
        self.scoreSlider.value = 60;
        delay(seconds: 0.15) {
            UIView.animate(withDuration: 0.7, animations: {
                self.scoreSlider.setValue(100, animated: true)
            })
        }

    }
    
    func fillStackView() {
        
        for (index, team) in teams.enumerated() {
            let label = self.newLabel()
            label.text = team.teamName
            if index % 2 == 0 {
                leftStackView.addArrangedSubview(label)
            } else {
                rightStackView.addArrangedSubview(label)
            }
        }
        
        stackViewHeightConstraint.constant = CGFloat(leftStackView.arrangedSubviews.count * 50 - 10)
        rightStackViewHeightConstraint.constant = CGFloat(rightStackView.arrangedSubviews.count * 50 - 10)
    }
    
    func animateStackView() {
        let allTeamViews = leftStackView.arrangedSubviews + rightStackView.arrangedSubviews
        
        for (index, view) in allTeamViews.enumerated() {
            view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            view.alpha = 0
            UIView.animate(withDuration: 0.7, delay: 0.25 + Double(index) * 0.03, usingSpringWithDamping: 0.45, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: {
                view.transform = CGAffineTransform.identity
                view.alpha = 1
                }, completion: nil)
        }
    }
    
    func animateCollectionView() {
        collectionView.reloadDataWithCompletion {
            for (index, view) in self.collectionView.visibleCells.enumerated() {
                view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7) 
                view.alpha = 0
                UIView.animate(withDuration: 0.7, delay: 0.25 + Double(index) * 0.03, usingSpringWithDamping: 0.45, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: {
                    view.transform = CGAffineTransform.identity
                    view.alpha = 1
                    }, completion: nil)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
        
        super.viewDidLayoutSubviews()
    }
    
    func newLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.astral
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5.0
        
        return label
    }
    
    // MARK: Private

    func loadDictionaries() {
        DictionaryService.sharedInstance.dictionaries { (dictionaryResponse) in
            switch dictionaryResponse {
            case .success(let dictionaries):
                self.dictionaries = dictionaries
            case .failure(_):
                self.dictionaries = []
            }
        }
    }
    
    // MARK: Action
    
    @IBAction func scoreSliderChanged(_ sender: UISlider) {
        totalScoreLabel.text = String(Int(sender.value))
    }

    @IBAction func timeSliderChanged(_ sender: UISlider) {
        timeLabel.text = String(Int(sender.value))
    }
    @IBAction func swipeToBack(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            
            let viewControllers = navigationController!.viewControllers.filter {
                return $0.isKind(of: NewGameViewController.self)
            }
            if let toViewController = viewControllers.first as? NewGameViewController {
                settingsToNewGameInteractiveSegue = SettingsToNewGameSegue(identifier: nil, source: self, destination: toViewController, isInteractive: true)
            }
            settingsToNewGameInteractiveSegue?.perform()
            settingsToNewGameInteractiveSegue?.handlePan(recognizer: recognizer)
            
        case .ended:
            settingsToNewGameInteractiveSegue?.handlePan(recognizer: recognizer)
            settingsToNewGameInteractiveSegue = nil
            
        default:
            settingsToNewGameInteractiveSegue?.handlePan(recognizer: recognizer)
            break
        }
        
    }
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
        
        game.resetGame()
        performSegue(withIdentifier: "SettingsToPlaySegue", sender: nil)
    }
    
}

// MARK: UICollectionViewDataSource

extension SettingsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dictionaries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: DictionaryCollectionViewCell = collectionView.dequeueCellAtIndexPath(indexPath)
        
        let dictionary = dictionaries[indexPath.row]
        cell.configure(dictionary: dictionary)
        
        return cell
    }
    
}

// MARK: UICollectionViewDelegate

extension SettingsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.visibleCells.forEach {
            $0.layer.borderColor = UIColor.white.cgColor
        }
        collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.sunglow.cgColor
        
        let dictionary = dictionaries[indexPath.row]
        dictionaryLabel.text = dictionary.language
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 35)
    }
    
}
