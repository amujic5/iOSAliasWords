//
//  Dictionary.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 24/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import Foundation

final class Dictionary {
    var language: String!
    var languageCode: String!
    var words: [String] = []
    var imageURLString: String?
    
    init(jsonObject: AnyObject) {
        if let jsonObject = jsonObject as? [String: AnyObject] {
            map(map: jsonObject)
        }
    }
    
    func map(map: [String: AnyObject]) {
        language = map["language"] as! String!
        languageCode = map["languageCode"] as! String!
        words = map["words"] as! [String]!
        imageURLString = map["imageURLString"] as? String
    }

}
