//
//  PlayToReviewSegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 07/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class PlayToReviewSegue: UIStoryboardSegue {

    override func perform() {
        let playViewController = source as! PlayViewController
        let reviewViewController = destination as! ReviewViewController
        
        reviewViewController.game = playViewController.game
        
        var viewControllers = playViewController.navigationController!.viewControllers.filter {
            return $0 != playViewController
        }
        viewControllers.append(reviewViewController)
        
        playViewController.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
}
