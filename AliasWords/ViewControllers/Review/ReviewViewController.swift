//
//  ReviewViewController.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 07/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class ReviewViewController: UIViewController {

    @IBOutlet weak var currentTeamLabel: UILabel!
    @IBOutlet weak var currentTeamCorrectLabel: UILabel!
    @IBOutlet weak var currentTeamSkipLabel: UILabel!
    
    var markedWords:[(word: String, isCorrect: Bool)] {
        return game.currentTeamMarkedWords
    }
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.currentTeamHasFinishedTheRound()
        _updateViews()
        
    }
    
    private func _updateViews() {
        currentTeamLabel.text = game.currentTeam.teamName
        currentTeamSkipLabel.text = "\(game.currentSkipAnswers) skipped"
        currentTeamCorrectLabel.text = "\(game.currentCorrectAnswers) correct"
    }

    // MARK : Action
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        
        if let winnerTeam = game.winnerTeam {
            let _ = navigationController?.popViewController(animated: true)
            print(winnerTeam.teamName)
        } else {
            game.newRound()
            performSegue(withIdentifier: String(describing: ReviewToPlaySegue.self), sender: nil)
        }
        
    }
    
}


// MARK: UITableViewDataSource

extension ReviewViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.sortedTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ReviewTableViewCell = tableView.dequeueCellAtIndexPath(indexPath)
        //cell.configure(markedWord: markedWords[indexPath.row])
        let team = game.sortedTeams[indexPath.row]
        cell.titleLabel.text = "\(team.teamName): \(team.score)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "GAME STATS"
    }
    
}

// MARK: UITableViewDelegate

extension ReviewViewController: UITableViewDelegate {
    
}
