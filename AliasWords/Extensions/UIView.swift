//
//  UIView.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 02/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit

var ScreenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

var ScreenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

extension UIView {
    
    var isOnMainWindow: Bool {
        if let windowFrame = UIApplication.shared.keyWindow?.frame {
            return windowFrame.contains(frame)
        } else {
            return false
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set(borderWidth) {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        
        set(borderColor) {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set(cornerRadius) {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
}


extension UILabel {
    func animateToFont(_ font: UIFont, withDuration duration: TimeInterval) {
        let oldFont = self.font
        let labelScale =  font.pointSize/oldFont!.pointSize
        UIView.animate(withDuration: duration, animations: { 
            self.transform = CGAffineTransform(scaleX: labelScale, y: labelScale)
            }) { (_) in
                self.font = font
        }
    }
}

extension UIButton {
    
    func animateToFont(_ font: UIFont, withDuration duration: TimeInterval) {
        let oldFont = self.titleLabel?.font
        let labelScale = font.pointSize/oldFont!.pointSize
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: labelScale, y: labelScale)
        }) { (_) in
        }
    }
    
}

// animation
extension UIView {
    
    func fadeDown(duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration) { 
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: 30)
        }
    }
    
    func fadeUp(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform(translationX: 0, y: 30)
        self.alpha = 0
        UIView.animate(withDuration: duration) {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }
        if (duration == 0) {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }
    }
    
}
