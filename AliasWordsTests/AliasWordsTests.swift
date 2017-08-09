//
//  AliasWordsTests.swift
//  AliasWordsTests
//
//  Created by Azzaro Mujic on 09/08/2017.
//  Copyright © 2017 Azzaro Mujic. All rights reserved.
//

import XCTest
import Firebase
@testable import AliasWords

class AliasWordsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let expectation = self.expectation(description: "app call")
        
        let dictionaryService = DictionaryService()
        dictionaryService.dictionaries { (response) in
            switch response {
            case .success(let dictionary):
                dictionary.forEach({ (dictionary) in
                    
                    var testMap: [String: Bool] = [String: Bool]()
                    
                    for word in dictionary.words {
                        if testMap[word] != nil {
                            XCTAssert(false, "\(word) is duplicated")
                        } else {
                            testMap[word] = true
                        }
                    }
                    
                })
                expectation.fulfill()
            case .failure(_):
                expectation.fulfill()
                break
            }
        }
        
        self.waitForExpectations(timeout: 100) { (error) in
            if let error = error {
                print("timeout error")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
