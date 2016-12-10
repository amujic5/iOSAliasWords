//
//  SettingsToPlaySegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 02/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class SettingsToPlaySegue: UIStoryboardSegue {

    override func perform() {
        let settingsViewController = source as! SettingsViewController
        let playViewController = destination as! PlayViewController
        
        playViewController.game = settingsViewController.game
        
        settingsViewController.navigationController?.delegate = self
        let _ = settingsViewController.navigationController?.pushViewController(playViewController, animated: true)
    }
    
}

extension SettingsToPlaySegue: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension SettingsToPlaySegue: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController: SettingsViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! SettingsViewController
        let toViewController: PlayViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! PlayViewController
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        
        containerView.updateConstraints()
        containerView.setNeedsDisplay()
        //toViewController.view.alpha = 0
        toViewController.view.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        toViewController.dialogParenView.transform = CGAffineTransform(translationX: 0, y: -ScreenHeight)
        toViewController.dialogParenView.alpha = 0
        
        // team label
        let fromTeamLabel = fromViewController.leftStackView.arrangedSubviews.first as! UILabel
        let teamLabel = UILabel()
        containerView.addSubview(teamLabel)
        teamLabel.font = fromTeamLabel.font
        teamLabel.text = fromTeamLabel.text
        teamLabel.frame = fromTeamLabel.frame
        teamLabel.center = fromTeamLabel.superview!.convert(fromTeamLabel.center, to: nil)
        teamLabel.backgroundColor = UIColor.clear
        teamLabel.textColor = UIColor.black
        teamLabel.textAlignment = fromTeamLabel.textAlignment
        teamLabel.alpha = 0
        
        UIView.animate(withDuration: 0.05, animations: {
            fromTeamLabel.alpha = 0
            teamLabel.alpha = 1
        }) { (_) in
        }
        
        teamLabel.animateToFont(toViewController.teamNameLabel.font, withDuration: 0.20)
        
        delay(seconds: 0.05) {
            
            UIView.animate(withDuration: 0.2, animations: {
                teamLabel.center = toViewController.teamNameLabel.superview!.convert(toViewController.teamNameLabel.center, to: nil)
                
                
            // to vc stuff
                let bannerView = toViewController.bannerView!
                bannerView.transform = CGAffineTransform(translationX: 0, y: -bannerView.frame.height)
                
                let dialogView = toViewController.dialogView!
                dialogView.transform = CGAffineTransform(scaleX: 0.2, y: 0)

                toViewController.teamNameLabel.alpha = 0
                toViewController.overlayView.alpha = 0
                
                let timeLabel = toViewController.timeLabel!
                timeLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
                
                let buttonsView = toViewController.buttonsContainerView!
                buttonsView.transform = CGAffineTransform(scaleX: 0, y: 0)
                
                toViewController.dialogParenView.alpha = 1
                
                delay(seconds: 0.05, completion: {
                    
                    UIView.animate(withDuration: 0.3, animations: { 
                        bannerView.transform = .identity
                        timeLabel.transform = .identity
                    })
                    
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.25, initialSpringVelocity: 1, options: [], animations: {
                        dialogView.transform = .identity
                        }, completion: nil)

                    
                    UIView.animate(withDuration: 0.8, delay: 0.5, options: [], animations: {
                        toViewController.overlayView.alpha = 1
                        }, completion: nil)
                    
                    UIView.animate(withDuration: 1.2, animations: {
                        fromViewController.view.transform = CGAffineTransform(translationX: 0, y: -ScreenHeight)
                    })
                    
                    UIView.animate(withDuration: 1, animations: {
                        
                        toViewController.dialogParenView.transform = .identity
                        toViewController.view.alpha = 1
                        toViewController.view.transform = .identity
                        teamLabel.alpha = 0
                        toViewController.teamNameLabel.alpha = 1
                        }, completion: { (_) in
                            fromViewController.view.transform = .identity
                            fromViewController.scrollView.alpha = 1
                            fromViewController.playButton.alpha = 1
                            fromTeamLabel.alpha = 1
                            teamLabel.removeFromSuperview()
                            toViewController.view.clipsToBounds = true
                            transitionContext.completeTransition(true)
                    })
                    
                    UIView.animate(withDuration: 0.35, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [], animations: {
                        buttonsView.transform = .identity
                        }, completion: nil)
                    
                })

                
                
            }) { (_) in
            
            }
        }
    }
}
