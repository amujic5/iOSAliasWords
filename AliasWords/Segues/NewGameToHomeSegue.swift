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
        self.newGameToHomeAnimator.isInteractive = isInteractive
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
        
        let progressWidth = recognizer.view!.superview!.frame.width * 0.8
        
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
            
            newGameToHomeAnimator.isInteractive = false
            if progressVelocity > 0.5 || progress > 0.8 {
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
    var isInteractive: Bool = false
}

extension NewGameToHomeAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
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
        
        
        if isInteractive {
            // interactive
            label.animateToFont(toViewController.newGameButton.titleLabel!.font!, withDuration: 0.3)
            UIView.animate(withDuration: 0.3, animations: {
                label.center = toViewController.newGameButton.center
            })
            
            toViewController.howToPlayButton.fadeUp(duration: 0.4)
            toViewController.tellYourFriendsButton.fadeUp(duration: 0.4)
            toViewController.titleLabel.fadeUp(duration: 0.4)
            
            toViewController.newGameButton.alpha = 0
            UIView.animate(withDuration: 0.7, animations: {
                toViewController.newGameButton.alpha = 1
            })
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                fromViewController.view.alpha = 0
                label.alpha = 0
            }) { (_) in
                label.removeFromSuperview()
                if(transitionContext.transitionWasCancelled) {
                    toViewController.view.removeFromSuperview()
                    newGameLabel.alpha = 1
                } else {
                    fromViewController.view.removeFromSuperview()
                    toViewController.newGameButton.alpha = 1
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            // non interactive
            
            label.animateToFont(toViewController.newGameButton.titleLabel!.font!, withDuration: 0.33)
            UIView.animate(withDuration: 0.3, animations: {
                label.center = toViewController.newGameButton.center
                
            }) { (_) in
                toViewController.howToPlayButton.fadeUp()
                toViewController.tellYourFriendsButton.fadeUp()
                toViewController.titleLabel.fadeUp()
                
                label.alpha = 0
                fromViewController.view.alpha = 0
                
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                    toViewController.newGameButton.alpha = 1
                }) { (_) in
                    label.removeFromSuperview()
                    fromViewController.view.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        }
    }
}


