//
//  ReviewTableViewCell.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 07/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with team: Team, at position: Int) {
        teamLabel.text = team.teamName
        scoreLabel.text = "Score: \(team.score)"
        positionLabel.text = "\(position)."
    }
    
}
