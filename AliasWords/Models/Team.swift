//
//  Team.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 02/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import Foundation

final class Team: NSObject {

    private var _score: Int
    
    var firstPlayer: String
    var secondPlayer: String
    var teamName: String
    var playing: Bool
    
    var isKnockedOut: Bool
    var roundsPlayed: Int
    var deltaScoreRound: Int

    var score: Int {
        return _score + deltaScoreRound
    }
    
    init(firstPlayer: String, secondPlayer: String, teamName: String) {
        self.firstPlayer = firstPlayer
        self.secondPlayer = secondPlayer
        self.teamName = teamName
        _score = 0
        playing = false
        isKnockedOut = false
        roundsPlayed = 0
        deltaScoreRound = 0
    }
    
    func updateScore() {
        _score += deltaScoreRound
        deltaScoreRound = 0
        if _score < 0 {
            _score = 0
        }
    }
}

