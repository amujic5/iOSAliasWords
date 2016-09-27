//
//  HomeToNewGameSegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 16/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class SettingsToNewGameSegue: UIStoryboardSegue {
    
    var isInteractive: Bool = false
    let settingToNewGameAnimator: SettingsToNewGameAnimator = SettingsToNewGameAnimator()
    
    init(identifier: String?, source: UIViewController, destination: UIViewController, isInteractive: Bool = false) {
        super.init(identifier: identifier, source: source, destination: destination)
        self.isInteractive = isInteractive
    }
    
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
    }
    
    override func perform() {
        let settingsViewController = source as! SettingsViewController

        settingsViewController.navigationController?.delegate = self
        let _ = settingsViewController.navigationController?.popViewController(animated: true)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: recognizer.view!.superview!)
        guard let storedContext = settingToNewGameAnimator.storedContext else {
            return
        }
        
        let progressWidth = recognizer.view!.superview!.frame.width
        
        var progress: CGFloat = translation.x / progressWidth
        progress = min(max(progress, 0.01), 0.99)
        
        switch recognizer.state {
        case .changed:
            
            settingToNewGameAnimator.update(progress)
            
        case .cancelled, .ended:
            let transitionLayer = storedContext.containerView.layer
            transitionLayer.beginTime = CACurrentMediaTime()
            
            let translationVelocity = recognizer.velocity(in:recognizer.view!.superview!)
            let progressVelocity: CGFloat = translationVelocity.x / progressWidth
            
            print("prgores: \(progressVelocity)")
            if progressVelocity > 0.5 {
                settingToNewGameAnimator.completionSpeed = 1 - settingToNewGameAnimator.percentComplete
                settingToNewGameAnimator.finish()
            } else {
                print("cancel")
                settingToNewGameAnimator.completionSpeed = 1
                settingToNewGameAnimator.cancel()
            }

        default:
            break
        }
        
    }
}

extension SettingsToNewGameSegue: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return settingToNewGameAnimator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return isInteractive ? settingToNewGameAnimator : nil
    }
    
}


final class SettingsToNewGameAnimator: UIPercentDrivenInteractiveTransition {
    
    weak var storedContext: UIViewControllerContextTransitioning?
}

extension SettingsToNewGameAnimator: UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        storedContext = transitionContext
        
        let fromViewController: SettingsViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! SettingsViewController
        let toViewController: NewGameViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! NewGameViewController
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)
        
        // bottom buttton animation
        let buttonLabel = UILabel()
        buttonLabel.textAlignment = .center
        buttonLabel.backgroundColor = toViewController.startTheGameButton.backgroundColor
        // buttonLabel.text = fromViewController.playButton.titleLabel?.text
        buttonLabel.text = toViewController.startTheGameButton.titleLabel?.text
        buttonLabel.font = fromViewController.playButton.titleLabel?.font
        buttonLabel.textColor = fromViewController.playButton.titleLabel?.textColor
        containerView.addSubview(buttonLabel)
        buttonLabel.frame = fromViewController.playButton.frame
        buttonLabel.layer.cornerRadius = fromViewController.playButton.layer.cornerRadius
        buttonLabel.layer.masksToBounds = fromViewController.playButton.layer.masksToBounds

        buttonLabel.animateToFont(toViewController.startTheGameButton.titleLabel!.font, withDuration: 0.4)
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.1, options: [], animations: {
            fromViewController.playButton.alpha = 0
            buttonLabel.center = toViewController.startTheGameButton.superview!.convert(toViewController.startTheGameButton.center, to: nil)
            
            buttonLabel.transform = CGAffineTransform(scaleX: toViewController.startTheGameButton.frame.width/buttonLabel.frame.width, y: toViewController.startTheGameButton.frame.height/buttonLabel.frame.height)
            }) { (_) in
                buttonLabel.removeFromSuperview()
        }
        
        // not playing
        let notPlayingCells = toViewController.tableView.visibleCells.filter { cell -> Bool in
            let index = toViewController.tableView.indexPath(for: cell)!.section
            return !toViewController.teams[index].playing
        }
        
        notPlayingCells.forEach {
            $0.alpha = 0.5
        }
        toViewController.tableView.tableFooterView?.alpha = 0
        delay(seconds: 0.3) {
            toViewController.tableView.tableFooterView?.fadeUp()
        }
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
            fromViewController.view.alpha = 0
            notPlayingCells.forEach {
                $0.alpha = 1            }
            }, completion: nil)
        
        // animate cells to labels
        let playingCells = toViewController.tableView.visibleCells.filter { cell in
            let index = toViewController.tableView.indexPath(for: cell)!.section
            return toViewController.teams[index].playing
            } . flatMap { cell -> NewGameTableViewCell? in
                return cell as? NewGameTableViewCell
        }
        
        let firstCellPosition = Int(toViewController.tableView.indexPath(for: playingCells[0])!.section)
        let offset = toViewController.teams[0..<firstCellPosition].filter {
            return $0.playing
            }.count
        
        UIView.animate(withDuration: 0.01, animations: {
            fromViewController.vsParentView.alpha = 0
            fromViewController.leftStackView.alpha = 0
            fromViewController.rightStackView.alpha = 0
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            fromViewController.leftStackView.superview?.alpha = 0
        })
        
        playingCells.enumerated().forEach { (index, cell) in
            
            let indexWithOffset = index + offset
            let stackView = (indexWithOffset % 2 == 0 ? fromViewController.leftStackView : fromViewController.rightStackView)!
            let stackIndex = indexWithOffset/2
            
            let stackLabel = stackView.arrangedSubviews[stackIndex] as! UILabel
            
            // create animation view - cell
            let view = UIView()
            containerView.addSubview(view)
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            view.frame = stackView.convert(stackLabel.frame, to: nil)
            view.backgroundColor = stackLabel.backgroundColor
            
            let toLabel = UILabel()
            toLabel.text = stackLabel.text
            toLabel.textColor = cell.teamNameLabel.textColor
            view.addSubview(toLabel)
            toLabel.sizeToFit()
            toLabel.center = CGPoint(x: stackLabel.frame.width/2, y: stackLabel.frame.height/2)
            
            let fromLabel = UILabel()
            fromLabel.text = stackLabel.text
            fromLabel.textColor = stackLabel.textColor
            view.addSubview(fromLabel)
            fromLabel.sizeToFit()
            fromLabel.center = CGPoint(x: stackLabel.frame.width/2, y: stackLabel.frame.height/2)
            
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.1, delay: 0.3, options: [], animations: {
                
                
                }, completion: nil)
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: {
                
                stackLabel.alpha = 0
                fromLabel.alpha = 0
                
                view.backgroundColor = cell.backgroundColor
                view.frame = cell.superview!.convert(cell.frame, to: nil)
                fromLabel.frame = cell.teamNameLabel.frame
                toLabel.frame = cell.teamNameLabel.frame
                }, completion: { (_) in
                    // end
                    cell.alpha = 1
                    view.removeFromSuperview()
                    if index == 0 {
                        if(transitionContext.transitionWasCancelled) {
                            toViewController.view.removeFromSuperview()
                        } else {
                            fromViewController.view.removeFromSuperview()
                        }
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    }
            })
        }
    }
    
}






