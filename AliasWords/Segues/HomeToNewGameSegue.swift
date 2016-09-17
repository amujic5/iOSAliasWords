//
//  HomeToNewGameSegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 16/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class HomeToNewGameSegue: UIStoryboardSegue {
    
    override func perform() {
        let homeViewController = source as! HomeViewController
        homeViewController.navigationController?.delegate = self
        homeViewController.navigationController?.pushViewController(destination, animated: true)
    }
}

extension HomeToNewGameSegue: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension HomeToNewGameSegue: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController: HomeViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! HomeViewController
        let toViewController: NewGameViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! NewGameViewController
        let newGameLabel = fromViewController.newGameButton.titleLabel!
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        //containerView.sendSubview(toBack: toViewController.view)
        toViewController.view.alpha = 0
        
        let label = UILabel()
        containerView.addSubview(label)
        label.font = newGameLabel.font
        label.text = newGameLabel.text
        label.frame = newGameLabel.frame
        label.center = fromViewController.newGameButton.center
        label.textColor = UIColor.black
        label.alpha = 0
        
        fromViewController.howToPlayButton.fadeDown()
        fromViewController.tellYourFriendsButton.fadeDown()
        fromViewController.titleLabel.fadeDown()
        
        UIView.animate(withDuration: 0.05, animations: {
            fromViewController.newGameButton.alpha = 0
            label.alpha = 1
            }) { (_) in
        }
        label.animateToFont(UIFont.boldSystemFont(ofSize: 33), withDuration: 0.4)
        
        UIView.animate(withDuration: 0.4, animations: {
            label.frame.origin = CGPoint(x: 70, y: 40)
        }) { (_) in
            fromViewController.newGameButton.alpha = 1
            transitionContext.completeTransition(true)
            toViewController.titleLabel.alpha = 1
            label.removeFromSuperview()
            fromViewController.howToPlayButton.fadeUp(duration: 0)
            fromViewController.tellYourFriendsButton.fadeUp(duration: 0)
            fromViewController.titleLabel.fadeUp(duration: 0)
        }
        
        
        toViewController.view.subviews.forEach{
            $0.alpha = 0
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            toViewController.view.alpha = 1
            
            }) { (_) in
                toViewController.view.subviews.forEach{
                    if ($0 == toViewController.titleLabel) {
                        
                    } else {
                        $0.fadeUp()
                    }
                }
        }
        
    }
}





