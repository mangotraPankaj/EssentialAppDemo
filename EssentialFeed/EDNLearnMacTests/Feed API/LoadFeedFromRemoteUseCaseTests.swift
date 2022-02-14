//
//  RemoteFeedLoaderTests.swift
//  EDNLearnMacTests
//
//  Created by Pankaj Mangotra on 07/06/21.
//

import EDNLearnMac
import XCTest

class LoadFeedFromRemoteUseCaseTests: XCTestCase {
    func test_load_deliversErrorOnNon200HTTPResponse() {
        // Arrange
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            let json = makeItemsJSON([])
            expect(sut, toCompleteWithResult: failure(.invalidData), when: {
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_deliverErrorON200ReponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithResult: failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliverNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithResult: .success([]), when: {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

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

        let items = [item1.model, item2.model]

        expect(sut, toCompleteWithResult: .success(items), when: {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }

    // MARK: Helper

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!,
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

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }

    // Creating a helper class to load the errors and do an assertion

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
}
