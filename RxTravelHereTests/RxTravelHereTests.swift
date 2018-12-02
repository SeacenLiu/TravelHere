//
//  RxTravelHereTests.swift
//  RxTravelHereTests
//
//  Created by SeacenLiu on 2018/11/28.
//  Copyright © 2018 SeacenLiu. All rights reserved.
//

import XCTest
@testable import RxTravelHere

class RxTravelHereTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    let testJSON = """
{
  "code": 200,
  "info": "接口使用正常",
  "data": {
    "user": {
      "userId": "18933399561",
      "userNickname": "小明",
      "userAvatar": "http://119.23.47.182:8088/group1/M00/00/00/rBMAA1v_SSqAFth9AAQT_cj4Z9w974.jpg"
    },
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE4OTMzMzk5NTYxIn0.UXzmuAfHjK9zaqXwGt8OW07Rnk8W4Y4N1pB9fB4gSmw"
  }
}
"""
    
    func test_Account_Model_JSON() {
        let decoder = JSONDecoder()
        let data = testJSON.data(using: .utf8)!
        let model = try! decoder.decode(Account.Model.self, from: data)
        print(model)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
