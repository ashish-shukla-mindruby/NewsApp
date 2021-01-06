//
//  IdeaVateNewsTests.swift
//  IdeaVateNewsTests
//
//  Created by Ashish Shukla on 06/01/21.
//  Copyright © 2021 Ashish. All rights reserved.
//

import XCTest

class IdeaVateNewsTests: XCTestCase {
    
    var sut: URLSession!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = URLSession(configuration: .default)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidCallToNewsHTTPSAPI() {
        
        let url =
            URL(string: "https://newsapi.org/v2/everything?q=bitcoin&apiKey=3a08b194bc2c4e17913dc1d397a97c0e")
        
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }
}
