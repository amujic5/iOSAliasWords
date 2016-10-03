//
//  SettingsToPlaySegue.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 02/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class SettingsToPlaySegue: UIStoryboardSegue {

    override func perform() {
        let settingsViewController = source as! SettingsViewController
        let playViewController = destination as! PlayViewController
        
        playViewController.game = settingsViewController.game
        
        let _ = settingsViewController.navigationController?.pushViewController(playViewController, animated: true)
    }
    
}
