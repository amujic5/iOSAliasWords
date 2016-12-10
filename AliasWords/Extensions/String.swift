//
//  String.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 10/12/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var utf8Data: Data {
        return data(using: .utf8)!
    }
    
    var isNotEmpty: Bool {
        return characters.count > 0
    }
    
    func hasMoreThan(numberOfCharacters: Int) -> Bool {
        return characters.count > numberOfCharacters
    }
    
}
