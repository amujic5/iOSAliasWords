//
//  Word.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 03/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import Foundation

enum AnswerType {
    case correct
    case wrong
    case notAnswered
    case ignore
}

struct Word {
    let word: String
    var answer: AnswerType
    
    init(word: String) {
        self.word = word
        answer = .notAnswered
    }
}
