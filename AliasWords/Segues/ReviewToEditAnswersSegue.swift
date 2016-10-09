//
//  ReviewToEditAnswersSegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 09/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class ReviewToEditAnswersSegue: UIStoryboardSegue {
    
    override func perform() {
        let reviewViewController = source as! ReviewViewController
        let editAnswersViewController = destination as! EditAnswersViewController
        
        editAnswersViewController.game = reviewViewController.game
        
        reviewViewController.navigationController?.delegate = self
        reviewViewController.navigationController?.pushViewController(editAnswersViewController, animated: true)
    }
    
}

extension ReviewToEditAnswersSegue: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension ReviewToEditAnswersSegue: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController: ReviewViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ReviewViewController
        let toViewController: EditAnswersViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! EditAnswersViewController
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            toViewController.view.alpha = 1
            
            }) { (_) in
                transitionContext.completeTransition(true)
        }
    }
}
