//
//  ReviewToPlaySegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 08/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class ReviewToPlaySegue: UIStoryboardSegue {
    
    override func perform() {
        let reviewViewController = source as! ReviewViewController
        let playViewController = destination as! PlayViewController
        
        playViewController.game = reviewViewController.game
        
        var viewControllers = reviewViewController.navigationController!.viewControllers.filter {
            return $0 != reviewViewController
        }
        viewControllers.append(playViewController)
        
        reviewViewController.navigationController?.delegate = self
        reviewViewController.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
}

extension ReviewToPlaySegue: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension ReviewToPlaySegue: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController: ReviewViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ReviewViewController
        let toViewController: PlayViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! PlayViewController
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)
        toViewController.view.alpha = 0
        
        let dialogView = fromViewController.dialogView!
        containerView.bringSubview(toFront: dialogView)

        toViewController.dialogView.alpha = 0
        
        delay(seconds: 0.01) {
          //  dialogView.frame = frame
            UIView.animate(withDuration: 0.35, animations: {
                dialogView.frame = toViewController.dialogView.frame
                }, completion: { (_) in
                    
                    UIView.animate(withDuration: 0.1, animations: { 
                        dialogView.alpha = 0
                        toViewController.dialogView.alpha = 1
                        }, completion: { (_) in
                            dialogView.removeFromSuperview()
                            transitionContext.completeTransition(true)
                    })
            })
            
            UIView.animate(withDuration: 0.3, delay: 0.3, options: [], animations: {
                toViewController.view.alpha = 1
                fromViewController.view.alpha = 0
                }, completion: { (_) in
                    fromViewController.view.removeFromSuperview()
            })
        }
        
    }
}


