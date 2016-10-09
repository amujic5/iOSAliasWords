//
//  EditAnswersViewController.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 09/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class EditAnswersViewController: UIViewController {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var correctAnswersLabel: UILabel!
    @IBOutlet weak var skippedAnswersLabel: UILabel!
    
    var markedWords: [(word: String, isCorrect: Bool)] = []
    var game: Game!
    
    private var _currentCorrectAnswers: Int {
        return markedWords.filter {return $0.isCorrect}.count
    }
    
    private var _currentSkipAnswers: Int {
        return markedWords.filter {return !$0.isCorrect}.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markedWords = game.currentTeamMarkedWords
        _updateViews()
    }

    // MARK: Private
    
    fileprivate func _updateViews() {
        teamNameLabel.text = game.currentTeam.teamName
        correctAnswersLabel.text = "\(_currentCorrectAnswers) correct"
        skippedAnswersLabel.text = "\(_currentSkipAnswers) skipped"
    }
    
    // MARK: Action
    
    @IBAction func xButtonClicked(_ sender: UIButton) {
        game.currentTeamMarkedWords = markedWords
        performSegue(withIdentifier: "EditAnswersToReviewSegue", sender: nil)
    }
}

// MARK: UITableViewDataSource

extension EditAnswersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EditAnswersTableViewCell = tableView.dequeueCellAtIndexPath(indexPath)
        
        let markedWord = markedWords[indexPath.row]
        cell.titleLabel.text = markedWord.word
        cell.backgroundColor = markedWord.isCorrect ? UIColor.blue : UIColor.red
        
        return cell
    }
    
}

// MARK: UITableViewDelegate

extension EditAnswersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        var markedWord = markedWords[index]
        markedWord.isCorrect = !markedWord.isCorrect
        
        markedWords[index] = markedWord
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        _updateViews()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
        
    }
    
}
