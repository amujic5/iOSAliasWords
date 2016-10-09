//
//  EditAnswersToReviewSegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 09/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class EditAnswersToReviewSegue: UIStoryboardSegue {
    
    override func perform() {
        let editAnswersViewController = source as! EditAnswersViewController
        let reviewViewController = destination as! ReviewViewController
        
        editAnswersViewController.navigationController?.delegate = self
        let _ = editAnswersViewController.navigationController?.popViewController(animated: true)
    }
    
}

extension EditAnswersToReviewSegue: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension EditAnswersToReviewSegue: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController: EditAnswersViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! EditAnswersViewController
        let toViewController: ReviewViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! ReviewViewController
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)
        
        UIView.animate(withDuration: 0.5, animations: {
            fromViewController.view.alpha = 0
            
        }) { (_) in
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
