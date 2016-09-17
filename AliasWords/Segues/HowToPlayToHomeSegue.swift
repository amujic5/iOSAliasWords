//
//  HomeToNewGameSegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 16/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class HowToPlayToHomeSegue: UIStoryboardSegue {
    
    override func perform() {
        let howToPlayViewController = source as! HowToPlayViewController
        howToPlayViewController.navigationController?.delegate = self
        howToPlayViewController.navigationController?.popViewController(animated: true)
    }
}

extension HowToPlayToHomeSegue: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension HowToPlayToHomeSegue: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController: HowToPlayViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! HowToPlayViewController
        let toViewController: HomeViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! HomeViewController
        let howToPlay = fromViewController.titleLabel!
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)
        
        
        let label = UILabel()
        containerView.addSubview(label)
        label.font = howToPlay.font
        label.text = howToPlay.text
        label.frame = howToPlay.frame
        label.center = howToPlay.superview!.convert(howToPlay.center, to: nil)
        label.textColor = UIColor.black
        label.alpha = 1
        howToPlay.alpha = 0
        
        
        fromViewController.dialogView.subviews.forEach{
            if ($0 != toViewController.titleLabel) {
                $0.fadeDown()
            }
        }
        
        label.animateToFont(toViewController.howToPlayButton.titleLabel!.font, withDuration: 0.4)
        
        UIView.animate(withDuration: 0.3) {
            fromViewController.dialogView.alpha = 0
            fromViewController.backgroundView.alpha = 0
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            label.center = toViewController.howToPlayButton.superview!.convert(toViewController.howToPlayButton.center, to: nil)
        }) { (_) in
            
            transitionContext.completeTransition(true)
            
            toViewController.newGameButton.fadeUp()
            toViewController.tellYourFriendsButton.fadeUp()
            toViewController.titleLabel.fadeUp()
            
            
            UIView.animate(withDuration: 0.2, animations: { 
                toViewController.howToPlayButton.alpha = 1
                label.alpha = 0
                }, completion: { (_) in
                    label.removeFromSuperview()
            })
            
        }
    }
}





