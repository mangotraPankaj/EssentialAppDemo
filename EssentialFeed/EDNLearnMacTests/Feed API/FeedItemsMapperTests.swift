//
//  RemoteFeedLoaderTests.swift
//  EDNLearnMacTests
//
//  Created by Pankaj Mangotra on 07/06/21.
//

import EDNLearnMac
import XCTest

class FeedItemsMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        // Arrange

        let samples = [199, 201, 300, 400, 500]
        let json = makeItemsJSON([])
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorON200ReponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        XCTAssertThrowsError(
            try FeedItemMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliverNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        let result = try FeedItemMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(result, [])
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: UUID(),
            imageURL: URL(string: "http://a-url.com")!
        )

        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "http://another-url.com")!
        )

        let json = makeItemsJSON([item1.json, item2.json])
        let result = try FeedItemMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        XCTAssertEqual(result, [item1.model, item2.model])
    }

    // MARK: Helper

    /*
     MakeSUT method can be removed as there is no need to create infrastructure for testing the mappers. It is just input and output like a pure function

        private func makeSUT(url: URL = URL(string:
        "https://a-url.com")!,
                             file: StaticString = #filePath,
                             line: UInt = #line) ->
            (sut: RemoteFeedLoader, client: HTTPClientSpy)
        {
            let client = HTTPClientSpy()
            let sut = RemoteFeedLoader(url: url, client: client)
            trackForMemoryLeaks(sut, file: file, line: line)
            trackForMemoryLeaks(client, file: file, line: line)
            return (sut, client)
        }
     */
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }

    private func makeItem(id: UUID,
                          description: String? = nil,
                          location: String? = nil,
                          imageURL: URL) -> (model: FeedImage, json: [String: Any])
    {
        let item = FeedImage(id: id,
                             description: description,
                             location: location,
                             url: imageURL)
        let json = ["id": id.uuidString,
                    "description": description,
                    "location": location,
                    "image": imageURL.absoluteString].compactMapValues { $0 }

        return (item, json)
    }

    // Creating a helper class to load the errors and do an assertion

    /*
      expect method can be removed as it is not required when using the mapper

     private func expect(_ sut: RemoteFeedLoader,
                         toCompleteWithResult expectedResult: RemoteFeedLoader.Result,
                         when action: () -> Void,
                         file: StaticString = #filePath,
                         line: UInt = #line)
     {
         let exp = expectation(description: "Wait for load completion")

         sut.load { recievedResult in
             switch (recievedResult, expectedResult) {
             case let (.success(recievedItems), .success(expectedItems)):
                 XCTAssertEqual(recievedItems, expectedItems, file: file, line: line)

             case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
                 XCTAssertEqual(receivedError, expectedError, file: file, line: line)

             default:
                 XCTFail("Expected result \(expectedResult) got \(recievedResult) instead", file: file, line: line)
             }
             exp.fulfill()
         }
         action()
         wait(for: [exp], timeout: 1.0)
     }
      */
}
