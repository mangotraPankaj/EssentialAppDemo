//
//  XCTestCase+FeedLoader.swift
//  EssentialAppTests
//
//  Created by Pankaj Mangotra on 10/01/22.
//

import EDNLearnMac
import Foundation
import XCTest

protocol FeedLoaderTestCase: XCTestCase {}

extension FeedLoaderTestCase {
    func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { recievedResult in
            switch (recievedResult, expectedResult) {
            case let (.success(recievedFeed), .success(expectedFeed)):
                XCTAssertEqual(recievedFeed, expectedFeed, file: file, line: line)

            case (.failure, .failure):
                break
            default:
                XCTFail("expected \(expectedResult), got \(recievedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}
