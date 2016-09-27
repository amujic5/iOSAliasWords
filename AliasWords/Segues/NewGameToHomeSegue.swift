//
//  HomeToNewGameSegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 16/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class NewGameToHomeSegue: UIStoryboardSegue {
    
    var isInteractive: Bool = false
    let newGameToHomeAnimator: NewGameToHomeAnimator = NewGameToHomeAnimator()
    
    init(identifier: String?, source: UIViewController, destination: UIViewController, isInteractive: Bool = false) {
        super.init(identifier: identifier, source: source, destination: destination)
        self.isInteractive = isInteractive
    }
    
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
    }
    
    override func perform() {
        let newGameViewController = source as! NewGameViewController
        newGameViewController.navigationController?.delegate = self
        let _ = newGameViewController.navigationController?.popViewController(animated: true)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: recognizer.view!.superview!)
        guard let storedContext = newGameToHomeAnimator.storedContext else {
            return
        }
        
        let progressWidth = recognizer.view!.superview!.frame.width
        
        var progress: CGFloat = translation.x / progressWidth
        progress = min(max(progress, 0.01), 0.99)
        
        switch recognizer.state {
        case .changed:
            
            newGameToHomeAnimator.update(progress)
            
        case .cancelled, .ended:
            let transitionLayer = storedContext.containerView.layer
            transitionLayer.beginTime = CACurrentMediaTime()
            
            let translationVelocity = recognizer.velocity(in:recognizer.view!.superview!)
            let progressVelocity: CGFloat = translationVelocity.x / progressWidth
            
            print("prgores: \(progressVelocity)")
            if progressVelocity > 0.5 {
                newGameToHomeAnimator.completionSpeed = 1 - newGameToHomeAnimator.percentComplete
                newGameToHomeAnimator.finish()
            } else {
                print("cancel")
                newGameToHomeAnimator.completionSpeed = 1
                newGameToHomeAnimator.cancel()
            }
            
        default:
            break
        }
        
    }
}

extension NewGameToHomeSegue: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return newGameToHomeAnimator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return isInteractive ? newGameToHomeAnimator : nil
    }
    
    
}

// MARK: Animator

final class NewGameToHomeAnimator: UIPercentDrivenInteractiveTransition {
    
    weak var storedContext: UIViewControllerContextTransitioning?
}

extension NewGameToHomeAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        storedContext = transitionContext
        
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
                    if(transitionContext.transitionWasCancelled) {
                        toViewController.view.removeFromSuperview()
                    } else {
                        fromViewController.view.removeFromSuperview()
                    }
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        }
    }
}


