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

}
