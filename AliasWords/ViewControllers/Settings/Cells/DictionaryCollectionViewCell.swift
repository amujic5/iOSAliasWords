//
//  DictionaryCollectionViewCell.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 16/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

final class DictionaryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private func makeRounded() {
        layer.masksToBounds = true
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
    }
    
    func configure(dictionary: Dictionary) {
        imageView.image = nil
        imageView.setImage(URLString: dictionary.imageURLString)
    }
    
    override func layoutSubviews() {
        makeRounded()
        super.layoutSubviews()
    }
    
}
