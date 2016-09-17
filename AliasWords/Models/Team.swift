//
//  Team.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 02/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import Foundation

final class Team: NSObject {
    var firstPlayer: String
    var secondPlayer: String
    var teamName: String
    var score: Int
    var playing: Bool
    
    init(firstPlayer: String, secondPlayer: String, teamName: String) {
        self.firstPlayer = firstPlayer
        self.secondPlayer = secondPlayer
        self.teamName = teamName
        score = 0
        playing = false
    }
}

