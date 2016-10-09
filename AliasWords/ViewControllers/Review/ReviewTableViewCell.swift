//
//  ReviewTableViewCell.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 07/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(markedWord: (word: String, isCorrect: Bool)) {
        titleLabel.text = markedWord.word
        titleLabel.textColor = markedWord.isCorrect ? UIColor.black : UIColor.red
    }
    
}
