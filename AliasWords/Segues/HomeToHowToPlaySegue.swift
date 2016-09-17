//
//  HomeToNewGameSegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 16/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class HomeToHowToPlaySegue: UIStoryboardSegue {
    
    override func perform() {
        let homeViewController = source as! HomeViewController
        homeViewController.navigationController?.delegate = self
        homeViewController.navigationController?.pushViewController(destination, animated: true)
    }
}

extension HomeToHowToPlaySegue: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension HomeToHowToPlaySegue: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController: HomeViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! HomeViewController
        let toViewController: HowToPlayViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! HowToPlayViewController
        let howToPlay = fromViewController.howToPlayButton.titleLabel!
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
       
        
        toViewController.titleLabel.setNeedsUpdateConstraints()
        containerView.updateConstraints()
        containerView.setNeedsDisplay()
        toViewController.view.alpha = 0
        
        let label = UILabel()
        containerView.addSubview(label)
        label.font = howToPlay.font
        label.text = howToPlay.text
        label.frame = howToPlay.frame
        label.center = fromViewController.howToPlayButton.center
        label.textColor = UIColor.black
        label.alpha = 0
        
        
        fromViewController.newGameButton.fadeDown()
        fromViewController.tellYourFriendsButton.fadeDown()
        fromViewController.titleLabel.fadeDown()
        
        UIView.animate(withDuration: 0.05, animations: {
            fromViewController.howToPlayButton.alpha = 0
            label.alpha = 1
            }) { (_) in
        }
        label.animateToFont(toViewController.titleLabel.font, withDuration: 0.4)
        
        delay(seconds: 0.02) {
            UIView.animate(withDuration: 0.4, animations: {
                label.center = toViewController.titleLabel.superview!.convert(toViewController.titleLabel.center, to: nil)
            }) { (_) in
                fromViewController.howToPlayButton.alpha = 1
                transitionContext.completeTransition(true)
                toViewController.titleLabel.alpha = 1
                fromViewController.newGameButton.fadeUp(duration: 0)
                fromViewController.tellYourFriendsButton.fadeUp(duration: 0)
                fromViewController.titleLabel.fadeUp(duration: 0)
                
                UIView.animate(withDuration: 0.2, animations: { 
                    label.alpha = 0
                    }, completion: { (_) in
                        label.removeFromSuperview()
                })
            }
        }
        
        
        toViewController.dialogView.alpha = 0
        toViewController.backgroundView.alpha = 0
        toViewController.dialogView.subviews.forEach{
            $0.alpha = 0
        }
        
        UIView.animate(withDuration: 0.8) { 
            toViewController.backgroundView.alpha = 1
        }
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            toViewController.view.alpha = 1
            
            }) { (_) in
                UIView.animate(withDuration: 0.2, animations: { 
                    toViewController.dialogView.alpha = 1
                })
                
                toViewController.dialogView.subviews.forEach{
                    if ($0 == toViewController.titleLabel) {
                        
                    } else {
                        $0.fadeUp()
                    }
                }
        }
        
    }
}





