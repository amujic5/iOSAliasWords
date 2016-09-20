//
//  HomeToNewGameSegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 16/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class NewGameToSettingsSegue: UIStoryboardSegue {
    
    override func perform() {
        let newGameViewController = source as! NewGameViewController
        let settingsViewController = destination as! SettingsViewController
        
        settingsViewController.teams = newGameViewController.playingTeams
        
        newGameViewController.navigationController?.delegate = self
        let _ = newGameViewController.navigationController?.pushViewController(settingsViewController, animated: true)
    }
}

extension NewGameToSettingsSegue: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

extension NewGameToSettingsSegue: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController: NewGameViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! NewGameViewController
        let toViewController: SettingsViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! SettingsViewController
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        
        // fade in out screens
        toViewController.animateStackView()
        toViewController.leftStackView.alpha = 0
        toViewController.rightStackView.alpha = 0
        
        delay(seconds: 0.1) { 
            toViewController.animateCollectionView()
        }
        
        UIView.animate(withDuration: 0.2, animations: { 
            fromViewController.subtitleLabel.alpha = 0
            fromViewController.createTeamButton.alpha = 0
            fromViewController.bottomParentView.alpha = 0
            }) { (_) in
                
                UIView.animate(withDuration: 0.2, animations: { 
                    toViewController.view.alpha = 1
                    }, completion: { (_) in
                        fromViewController.subtitleLabel.alpha = 1
                        fromViewController.createTeamButton.alpha = 1
                        fromViewController.bottomParentView.alpha = 1
                })
                
        }
        
        
        //bottom buttton animation
        let buttonLabel = UILabel()
        buttonLabel.text = fromViewController.startTheGameButton.titleLabel?.text
        buttonLabel.textColor = fromViewController.startTheGameButton.titleLabel?.textColor
        buttonLabel.backgroundColor = fromViewController.startTheGameButton.backgroundColor
        buttonLabel.layer.cornerRadius = fromViewController.startTheGameButton.layer.cornerRadius
        buttonLabel.layer.masksToBounds = fromViewController.startTheGameButton.layer.masksToBounds
        buttonLabel.textAlignment = .center
        containerView.addSubview(buttonLabel)
        buttonLabel.frame = fromViewController.startTheGameButton.superview!.convert(fromViewController.startTheGameButton.frame, to: nil)
        
        delay(seconds: 0.1) { 
            UIView.transition(with: buttonLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                buttonLabel.frame = toViewController.playButton.frame
                buttonLabel.text = toViewController.playButton.titleLabel?.text
                buttonLabel.font = toViewController.playButton.titleLabel?.font
            }) { (_) in
                buttonLabel.removeFromSuperview()
            }
        }
        
        // not playing
        let notPlayingCells = fromViewController.tableView.visibleCells.filter { cell -> Bool in
            let index = fromViewController.tableView.indexPath(for: cell)!.section
            return !fromViewController.teams[index].playing
        }
        
        UIView.animate(withDuration: 0.2) { 
            notPlayingCells.forEach {
                $0.alpha = 0.5
            }
        }
        
        // animate cells to labels
        let playingCells = fromViewController.tableView.visibleCells.filter { cell in
            let index = fromViewController.tableView.indexPath(for: cell)!.section
            return fromViewController.teams[index].playing
        } . flatMap { cell -> NewGameTableViewCell? in
            return cell as? NewGameTableViewCell
        }
        
        let firstCellPosition = Int(fromViewController.tableView.indexPath(for: playingCells[0])!.section)
        let offset = fromViewController.teams[0..<firstCellPosition].filter {
            return $0.playing
        }.count
        
        playingCells.enumerated().forEach { (index, cell) in
            // create animation view - cell
            let view = UIView()
            containerView.addSubview(view)
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            view.frame = cell.superview!.convert(cell.frame, to: nil)
            view.alpha = 0
            
            let label = UILabel()
            label.text = cell.teamNameLabel.text
            label.textColor = cell.teamNameLabel.textColor
            view.addSubview(label)
            label.frame = cell.teamNameLabel.frame
            
            UIView.animate(withDuration: 0.1, animations: {
                view.alpha = 1
                view.backgroundColor = UIColor.black
                label.textColor = UIColor.white
                cell.alpha = 0
                }, completion: { (_) in
                    
                    let indexWithOffset = index + offset

                    let stackView = (indexWithOffset % 2 == 0 ? toViewController.leftStackView : toViewController.rightStackView)!
                    let stackIndex = indexWithOffset/2
                    print(stackIndex)
                    
                    if let toLabel = stackView.arrangedSubviews[0] as? UILabel {
                        label.animateToFont(toLabel.font, withDuration: 0.3)
                        UIView.animate(withDuration: 0.3, animations: {
                            label.center = toLabel.center
                        })
                    }
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        view.frame = stackView.convert(stackView.arrangedSubviews[stackIndex].frame, to: nil)
                        }, completion: { (_) in
                            // end
                            cell.alpha = 1
                            toViewController.leftStackView.alpha = 1
                            toViewController.rightStackView.alpha = 1
                            view.removeFromSuperview()
                            transitionContext.completeTransition(true)
                            notPlayingCells.forEach {
                                $0.alpha = 1
                            }
                    })
            })
        }
    }

}





