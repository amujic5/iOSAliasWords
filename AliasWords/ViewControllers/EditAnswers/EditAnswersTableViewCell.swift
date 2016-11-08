//
//  EditAnswersTableViewCell.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 09/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

protocol EditAnswersTableViewCellDelegate: class {
    func swticherClicked(on cell: EditAnswersTableViewCell)
}

final class EditAnswersTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var correctSwitch: UISwitch!
    
    weak var delegate: EditAnswersTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(markedWord: (word: String, isCorrect: Bool)) {
        titleLabel.text = markedWord.word
        titleLabel.textColor = markedWord.isCorrect ? UIColor.black : UIColor.red
        correctSwitch.isOn = markedWord.isCorrect
    }

    @IBAction func switcherChangedValue(_ sender: UISwitch) {
        delegate?.swticherClicked(on: self)
    }
    
    
}
