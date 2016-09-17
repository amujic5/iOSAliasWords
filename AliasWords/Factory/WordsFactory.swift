//
//  WordsFactory.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 03/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import Foundation

final class WordsFactory {
    
    fileprivate var dictionary: [String]
    
    init() {
        dictionary = [];
        reloadWords()
    }
    
    var newWord: Word {
        let randomIndex = self.randomValue(0, max: self.dictionary.count - 1)
        let wordString = self.dictionary[randomIndex]
        self.dictionary .remove(at: randomIndex)
        
        return Word(word: wordString)
    }
    
    func reloadWords() {
        let allWordBundle = Bundle.main.path(forResource: "words_hr", ofType: "txt")
        if let allWordsString = try? String(contentsOfFile: allWordBundle!, encoding: String.Encoding.utf8) {
            dictionary = allWordsString.components(separatedBy: "\n")
        }
        
    }
    
    fileprivate func randomValue(_ min: Int, max: Int) -> Int {
        let rand = max - min + 1
        return min + Int(arc4random_uniform(UInt32(rand)))
    }
    
}
