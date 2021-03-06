//
//  TangPoetryTests.swift
//  TangPoetryTests
//
//  Created by huahuahu on 2018/6/30.
//  Copyright © 2018年 huahuahu. All rights reserved.
//

import XCTest
@testable import TangPoetry

class TangPoetryTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDataOK() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let dataProvider = DataProvider.init()
        assert(dataProvider.poetryCount == 319)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testAsItemProvider() {
        let poem = PoemClass.testPoem()
        let itemProvider = NSItemProvider.init(object: poem)

        let expectation = XCTestExpectation(description: "load")
        itemProvider.loadObject(ofClass: PoemClass.self) { (result, error) in
            XCTAssertNil(error)
            let poem = result as? PoemClass
            XCTAssertNotNil(poem)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

}
