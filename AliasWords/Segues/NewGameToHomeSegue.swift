//
//  HomeToNewGameSegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 16/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class NewGameToHomeSegue: UIStoryboardSegue {
    
    override func perform() {
        let newGameViewController = source as! NewGameViewController
        newGameViewController.navigationController?.delegate = self
        let _ = newGameViewController.navigationController?.popViewController(animated: true)
    }
}

extension NewGameToHomeSegue: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension NewGameToHomeSegue: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController: NewGameViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! NewGameViewController
        let toViewController: HomeViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! HomeViewController
        let newGameLabel = fromViewController.titleLabel!
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)
        
        let label = UILabel()
        containerView.addSubview(label)
        label.font = newGameLabel.font
        label.text = newGameLabel.text
        label.frame = newGameLabel.frame
        label.textColor = UIColor.black
        
        newGameLabel.alpha = 0
        fromViewController.view.subviews.forEach{
            $0.fadeDown()
        }
        
        
        label.animateToFont(toViewController.newGameButton.titleLabel!.font!, withDuration: 0.43)
        UIView.animate(withDuration: 0.4, animations: {
            label.center = toViewController.newGameButton.center
        }) { (_) in
            
            fromViewController.view.alpha = 0
            fromViewController.view.removeFromSuperview()
            
            toViewController.howToPlayButton.fadeUp()
            toViewController.tellYourFriendsButton.fadeUp()
            toViewController.titleLabel.fadeUp()
            label.alpha = 0.3
            
            UIView.animate(withDuration: 0.2, animations: {
                toViewController.newGameButton.alpha = 1
                label.alpha = 0
                }, completion: { (_) in
                    label.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
            
        }
    }
}





