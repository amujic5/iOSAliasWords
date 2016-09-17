//
//  NewGameTableViewCell.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 07/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

protocol NewGameTableViewCellDelegate: class {
    func checkBoxClickedOnCell(_ cell: UITableViewCell)
}

final class NewGameTableViewCell: UITableViewCell {

    weak var delegate: NewGameTableViewCellDelegate?
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var firstPlayerLabel: UILabel!
    @IBOutlet weak var secondPlayerLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    
    let selectedCheckboxImage: UIImage = UIImage(named: "ic_check_box_selected")!
    let unSelectedCheckboxImage: UIImage = UIImage(named: "ic_check_box")!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWithTeam(_ team: Team) {
        teamNameLabel.text = team.teamName
        firstPlayerLabel.text = team.firstPlayer
        secondPlayerLabel.text = team.secondPlayer
    }

    @IBAction func checkboxButtonClicked(_ sender: UIButton) {
        
        delegate?.checkBoxClickedOnCell(self)
        
        if (checkboxButton.currentImage == selectedCheckboxImage) {
            checkboxButton .setImage(unSelectedCheckboxImage, for: UIControlState())
        } else {
            checkboxButton .setImage(selectedCheckboxImage, for: UIControlState())
        }
        
    }
}
