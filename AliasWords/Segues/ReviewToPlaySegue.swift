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
        
        reviewViewController.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
}
