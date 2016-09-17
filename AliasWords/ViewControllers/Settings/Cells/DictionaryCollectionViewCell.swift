//
//  DictionaryCollectionViewCell.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 16/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class DictionaryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private func makeRounded() {
        layer.masksToBounds = true
        layer.cornerRadius = 5.0
    }
    
    override func layoutSubviews() {
        makeRounded()
        super.layoutSubviews()
    }
    
}
