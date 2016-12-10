//
//  HomeViewController.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 02/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tellYourFriendsButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    var storyboardSegue: UIStoryboardSegue?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
   
    }
    
    @IBAction func shareAppButtonClicked(_ sender: UIButton) {
        
        // text to share
        let text = "This game is so cool. Try it!!!"
        let link = URL(string: "https://itunes.apple.com/us/app/alias-words/id1185251362?ls=1&mt=8")!
        
        // set up activity view controller
        let textToShare = [ text, link ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
//        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

}
