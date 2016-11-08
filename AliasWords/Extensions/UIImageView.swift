//
//  UIImageView.swift
//  Fashable
//
//  Created by Azzaro Mujic on 20/10/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(URLString: String?) {
        
        if let URLString = URLString {            
            let url = URL(string: URLString)
            kf.setImage(with: url)
        }
    }
    
}

extension UIButton {
    
    func setImage(URLString: String?, controlState: UIControlState = .normal) {
        
        if let URLString = URLString {
            let url = URL(string: URLString)
            kf.setImage(with: url, for: controlState)
        }
        
    }
    
}
