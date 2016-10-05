//
//  Game.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 02/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import Foundation

final class Game {
    
    private var _reverseExplaingAnsweringDirection: Bool
    private var _time: Int
    private var _goalScore: Int
    private var _teams: [Team]
    private var _currentTeamIndex: Int
    private let _dictionary: Dictionary
    private var _words: [String]
    
    var currentTeam: Team {
        return _teams[_currentTeamIndex]
    }
    
    var winnerTeam: Team? {
        return nil
    }
    
    var time: Int {
        return _time
    }
    
    var newWord: String {
        if (_words.count == 0) {
            _words = _dictionary.words
        }
        
        let randomIndex = randomValue(0, max: _words.count - 1)
        let wordString = _words[randomIndex]
        _words.remove(at: randomIndex)
        
        return wordString
    }
    
    init(time: Int, goalScore: Int, teams: [Team], dictionary: Dictionary) {
        _time = time
        _goalScore = goalScore
        _teams = teams
        _reverseExplaingAnsweringDirection = false
        _currentTeamIndex = 0
        _words = dictionary.words
        _dictionary = dictionary
    }
    
    func newRound() {
        _currentTeamIndex += 1
        if _currentTeamIndex >= _teams.count {
            _currentTeamIndex = 0
            _reverseExplaingAnsweringDirection = !_reverseExplaingAnsweringDirection
        }
    }
    
    private func randomValue(_ min: Int, max: Int) -> Int {
        let rand = max - min + 1
        return min + Int(arc4random_uniform(UInt32(rand)))
    }
}
