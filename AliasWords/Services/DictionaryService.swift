//
//  DictionaryService.swift
//  AliasWords
//
//  Created by Azzaro Mujic on 24/09/16.
//  Copyright © 2016 Azzaro Mujic. All rights reserved.
//

import UIKit
import FirebaseDatabase

enum DictionaryReponse {
    case success([Dictionary])
    case failure(Error)
}

final class DictionaryService {
    
    static let sharedInstance: DictionaryService = DictionaryService()
    
    private let childRef: FIRDatabaseReference = FIRDatabase.database().reference(withPath: "dictionaries")
    private var dictionaries: [Dictionary]?
    
    init() {
        childRef.observe(.value, with: { (snapshot) in
             if let jsonDictionary = snapshot.value as? [AnyObject] {
                self.dictionaries = jsonDictionary.flatMap {
                    print($0)
                    return Dictionary(jsonObject: $0)
                }
            }
            }, withCancel: { (error) in
        })

    }
    
    func dictionaries(completion: @escaping (_ dictionaryResponse: DictionaryReponse) -> Void) {
        
        if let dictionaries = dictionaries {
            completion(DictionaryReponse.success(dictionaries))
        } else {
            childRef.observe(.value, with: { (snapshot) in
                if let jsonDictionary = snapshot.value as? [AnyObject] {
                    self.dictionaries = jsonDictionary.flatMap {
                        return Dictionary(jsonObject: $0)
                    }
                    completion(DictionaryReponse.success(self.dictionaries!))
                }
                }, withCancel: { (error) in
                    completion(DictionaryReponse.failure(error))
            })
        }
        
    }
    
}
