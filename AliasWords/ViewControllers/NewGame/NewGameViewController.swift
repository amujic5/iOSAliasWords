//
//  NewGameViewController.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 02/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class NewGameViewController: UIViewController {

    var newGameToHomeInteractiveSegue: NewGameToHomeSegue?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var teamVSLabel: UILabel!
    @IBOutlet weak var createTeamButton: UIButton!
    
    @IBOutlet weak var bottomParentView: UIView!
    @IBOutlet weak var startTheGameButton: UIButton!
    var teams: [Team] = []
    var playingTeams: [Team] {
        return teams.filter { return $0.playing }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateVSLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let layer = createTeamButton.addDashedBorder()
        layer.marchLayer()
    }

    // MARK: Private
    
    fileprivate func updateVSLabel() {
        
        let attributedString = NSMutableAttributedString()
        let VSAttributedString = NSAttributedString(string: " VS ", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)])
        
        for (index, team) in playingTeams.enumerated() {
            if (index > 0 ) {
                attributedString.append(VSAttributedString)
            }
            
            let attributedTeamName = NSAttributedString(string: team.teamName, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 17)])
            attributedString.append(attributedTeamName)
        }
        
        teamVSLabel.attributedText = attributedString
    }

    // MARK: action
    
    @IBAction func swipeToBack(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            
            let viewControllers = navigationController!.viewControllers.filter {
                return $0.isKind(of: HomeViewController.self)
            }
            if let toViewController = viewControllers.first as? HomeViewController {
                newGameToHomeInteractiveSegue = NewGameToHomeSegue(identifier: nil, source: self, destination: toViewController, isInteractive: true)
            }
            newGameToHomeInteractiveSegue?.perform()
            newGameToHomeInteractiveSegue?.handlePan(recognizer: recognizer)
            
        case .ended:
            newGameToHomeInteractiveSegue?.handlePan(recognizer: recognizer)
            newGameToHomeInteractiveSegue = nil
            
        default:
            newGameToHomeInteractiveSegue?.handlePan(recognizer: recognizer)
            break
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createNewTeamButtonClicked(_ sender: UIButton) {
        let addEditTeamView: AddEditTeamView = AddEditTeamView.initViewWithOwner(self)
        view.addSubview(addEditTeamView)
        addEditTeamView.createTeam(createButton: sender)
        addEditTeamView.delegate = self
    }
    
    @IBAction func startGameButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: SettingsViewController.identifier, sender: sender)
        if playingTeams.count > 1 {
        } else {
            // show alert
        }
    }
    

}

// MARK: AddEditTeamViewDelegate

extension NewGameViewController: AddEditTeamViewDelegate {
    
    func deletedTeam(_ team: Team, addEditTeamView: AddEditTeamView) {
        if let teamIndex = teams.index(of: team) {
            teams.remove(at: teamIndex)
            let indexSet = IndexSet(integer: teamIndex)
            tableView.deleteSections(indexSet, with: .automatic)
        }
    }
    
    func createdNewTeam(_ team: Team, addEditTeamView: AddEditTeamView) {
        
        var cell: NewGameTableViewCell!
        if let index = teams.index(of: team) {
            tableView.reloadSections(IndexSet(integer: index), with: UITableViewRowAnimation.automatic)
            cell = tableView.cellForRow(at: IndexPath(item: 0, section: index)) as! NewGameTableViewCell
        } else {
            teams.append(team)
            tableView.insertSections(IndexSet(integer: teams.count - 1), with: UITableViewRowAnimation.top)
            cell = tableView.visibleCells.last! as! NewGameTableViewCell
        }
        
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: teams.count - 1), at: UITableViewScrollPosition.none, animated: true)
        
        // custom animation
        let teamLabel = addEditTeamView.teamLabel()
        teamLabel.animateToFont(cell.teamNameLabel.font, withDuration: 0.3)
        let firstPlayerLabel = addEditTeamView.firstPlayerLabel()
        let secondPlayerLabel = addEditTeamView.secondPlayerLabel()
        
        
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            teamLabel.alpha = 0.5
            firstPlayerLabel.alpha = 0.5
            secondPlayerLabel.alpha = 0.5
        }
        
        UIView.animate(withDuration: 0.3) {
            teamLabel.frame = cell.teamNameLabel.frame
            firstPlayerLabel.frame = cell.firstPlayerLabel.frame
            secondPlayerLabel.frame = cell.secondPlayerLabel.frame
            
            addEditTeamView.dialogView.backgroundColor = cell.backgroundColor
            addEditTeamView.backgroundView.alpha = 0
            addEditTeamView.dialogView.frame = cell.superview!.convert(cell.frame, to: nil)
            addEditTeamView.cancelButton.alpha = 0
            addEditTeamView.createButton.alpha = 0
            addEditTeamView.deleteButton.alpha = 0
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.25, options: [], animations: {
            cell.alpha = 1
            addEditTeamView.alpha = 0
            }) { (_) in
                addEditTeamView.removeFromSuperview()
        }
    }
    
}

// MARK: UITableViewDataSource

extension NewGameViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewGameTableViewCell = tableView.dequeueCellAtIndexPath(indexPath)
        cell.configureWithTeam(teams[(indexPath as NSIndexPath).section])
        cell.delegate = self
        
        return cell
    }
    
}

// MARK: UITableViewDelegate

extension NewGameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addEditTeamView: AddEditTeamView = AddEditTeamView.initViewWithOwner(self)
        addEditTeamView.isHidden = false
        view.addSubview(addEditTeamView)
        addEditTeamView.delegate = self
        
        addEditTeamView.setNeedsUpdateConstraints()
        addEditTeamView.layoutIfNeeded()
        
        let team = teams[indexPath.section]
        addEditTeamView.teamNameTextField.text = team.teamName
        addEditTeamView.firstPlayerTextField.text = team.firstPlayer
        addEditTeamView.secondPLayerTextField.text = team.secondPlayer
        addEditTeamView.editingTeam = team
        
        let cell = tableView.cellForRow(at: indexPath)! as! NewGameTableViewCell
        
        let oldFrame = addEditTeamView.dialogView.frame
        addEditTeamView.dialogView.backgroundColor = cell.backgroundColor
        addEditTeamView.backgroundView.alpha = 0
        addEditTeamView.dialogView.frame = cell.superview!.convert(cell.frame, to: nil)
        addEditTeamView.cancelButton.alpha = 0
        addEditTeamView.createButton.alpha = 0
        addEditTeamView.deleteButton.alpha = 0
        
        let teamLabel = addEditTeamView.teamLabel()
        teamLabel.font = cell.teamNameLabel.font
        
        let firstPlayerLabel = addEditTeamView.firstPlayerLabel()
        let secondPlayerLabel = addEditTeamView.secondPlayerLabel()
        
        let teamOldFrame = teamLabel.frame
        teamLabel.frame = cell.teamNameLabel.frame
        let firstPlayerOldFrame = firstPlayerLabel.frame
        firstPlayerLabel.frame = cell.firstPlayerLabel.frame
        let secondPlayerOldFrame = secondPlayerLabel.frame
        secondPlayerLabel.frame = cell.secondPlayerLabel.frame

        
        UIView.animate(withDuration: 0.3, animations: { 
            addEditTeamView.dialogView.backgroundColor = UIColor.white
            addEditTeamView.backgroundView.alpha = 1
            addEditTeamView.cancelButton.alpha = 1
            addEditTeamView.createButton.alpha = 1
            addEditTeamView.deleteButton.alpha = 1
            
            addEditTeamView.dialogView.frame = oldFrame
            teamLabel.frame = teamOldFrame
            firstPlayerLabel.frame = firstPlayerOldFrame
            secondPlayerLabel.frame = secondPlayerOldFrame
            }) { (_) in
                addEditTeamView.teamNameTextField.alpha = 1
                addEditTeamView.firstPlayerTextField.alpha = 1
                addEditTeamView.secondPLayerTextField.alpha = 1
                
                teamLabel.removeFromSuperview()
                firstPlayerLabel.removeFromSuperview()
                secondPlayerLabel.removeFromSuperview()
        }
        
    }
    
}

// MARK: NewGameTableViewCellDelegate

extension NewGameViewController: NewGameTableViewCellDelegate {
    func checkBoxClickedOnCell(_ cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            teams[(indexPath as NSIndexPath).section].playing = !teams[(indexPath as NSIndexPath).section].playing
            updateVSLabel()
        }
    }
}


