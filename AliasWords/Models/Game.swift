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
    private let _dictionary: Dictionary
    private var _words: [String]
    private var _currentTeamIndex: Int
    
    private var _playingTeams: [Team] {
        return _teams.filter {
            return !$0.isKnockedOut
        }
    }
    
    // MARK: Public vars
    var currentTeamMarkedWords:[(word: String, isCorrect: Bool)] = []
    var currentRoundScore: Int {
        return currentCorrectAnswers - currentSkipAnswers
    }
    var currentCorrectAnswers: Int {
        return currentTeamMarkedWords.filter {return $0.isCorrect}.count
    }
    
    var currentSkipAnswers: Int {
        return currentTeamMarkedWords.filter {return !$0.isCorrect}.count
    }
    
    // MARK: Public getters
    
    var sortedTeams: [Team] {
        return _teams.sorted {
            return $0.0.score > $0.1.score
        }
    }
    
    var currentTeam: Team {
        return _teams[_currentTeamIndex]
    }
    
    var explainingPlayerName: String {
        return _reverseExplaingAnsweringDirection ? currentTeam.secondPlayer : currentTeam.firstPlayer
    }
    
    var answeringPlayerName: String {
        return _reverseExplaingAnsweringDirection ? currentTeam.firstPlayer : currentTeam.secondPlayer
    }
    
    var winnerTeam: Team? {
        knockOutTeamsIfNeeded()
        if _playingTeams.count == 1 {
            return _playingTeams.first
        }
        
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
    
    // MARK: Public functionc
    
    init(time: Int, goalScore: Int, teams: [Team], dictionary: Dictionary) {
        _time = time
        _goalScore = goalScore
        _teams = teams
        _reverseExplaingAnsweringDirection = false
        _currentTeamIndex = 0
        _words = dictionary.words
        _dictionary = dictionary
    }
    
    func currentTeamHasFinishedTheRound() {
        currentTeam.roundsPlayed += 1
        currentTeam.deltaScoreRound = currentRoundScore
    }
    
    func newRound() {
        currentTeam.updateScore()
        currentTeamMarkedWords = []
        knockOutTeamsIfNeeded()

        if _isLastTeamInRound() {
            _reverseExplaingAnsweringDirection = !_reverseExplaingAnsweringDirection
        }
        _increaseCurrentTeamIndex()
    }
    
    func knockOutTeamsIfNeeded() {
        
        let shouldKnockOutTeams =
                _isLastTeamInRound()
                    &&
                _teams.contains {
                    
            return $0.score >= _goalScore
        }
        
        if !shouldKnockOutTeams {
            return
        }
        
        let bestScoreTeam = _teams.max {
            return $0.0.score < $0.1.score
        }!
        let maxCurrentScore = bestScoreTeam.score
        
        _teams.forEach {
            $0.isKnockedOut = $0.score < maxCurrentScore
        }
        
    }
    
    func reviewWord(at index: Int) {
        var markedWord = currentTeamMarkedWords[index]
        markedWord.isCorrect = !markedWord.isCorrect
        
        currentTeamMarkedWords[index] = markedWord
        currentTeam.deltaScoreRound = currentRoundScore
    }
    
    func addMarkedWord(_ markedWord: (word: String, isCorrect: Bool)) {
        currentTeamMarkedWords.append(markedWord)
    }
    
    // MARK: Private
    
    private func _increaseCurrentTeamIndex() {
        var searchOffset = 0
        
        if !_isLastTeamInRound() {
            searchOffset = _currentTeamIndex + 1
        }
        
        let nextTeam = _teams
            .dropFirst(searchOffset)
            .filter {
                return !$0.isKnockedOut
        }
            .first!
        
        _currentTeamIndex = _teams.index(of: nextTeam)!
    }
    
    private func _isLastTeamInRound() -> Bool {
        let searchOffset = _currentTeamIndex + 1
        return _teams
            .dropFirst(searchOffset)
            .filter { return !$0.isKnockedOut }
            .count == 0
            
    }
    
    
    private func randomValue(_ min: Int, max: Int) -> Int {
        let rand = max - min + 1
        return min + Int(arc4random_uniform(UInt32(rand)))
    }
}
