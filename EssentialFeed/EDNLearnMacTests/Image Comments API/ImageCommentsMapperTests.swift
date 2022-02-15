//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EDNLearnMacTests
//
//  Created by Pankaj Mangotra on 10/02/22.
//

import EDNLearnMac
import XCTest

class ImageCommentsMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
        let samples = [199, 150, 300, 400, 500]
        let json = makeItemsJSON([])
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorON2xxReponseWithInvalidJSON() throws {
        // let (sut, client) = makeSUT()

        let samples = [200, 201, 250, 280, 299]
        let invalidJSON = Data("invalid json".utf8)
        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: code))
            )
//            expect(sut, toCompleteWithResult: failure(.invalidData), when: {
//                let invalidJSON = Data("invalid json".utf8)
//                client.complete(withStatusCode: code, data: invalidJSON, at: index)
//            })
        }
    }

    func test_map_deliverNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
        let samples = [200, 201, 250, 280, 299]
        let emptyListJSON = makeItemsJSON([])
        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: code))
            XCTAssertEqual(result, [])
//            expect(sut, toCompleteWithResult: .success([]), when: {
//                let emptyListJSON = makeItemsJSON([])
//                client.complete(withStatusCode: code, data: emptyListJSON, at: index)
//            })
        }
    }

    func test_map_deliversItemsOn2xxHTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: UUID(),
            message: "a message",
            createdAt: (Date(timeIntervalSince1970: 1_598_754_333), "2020-08-30T02:25:33+00:00"),
            username: "a username"
        )

        let item2 = makeItem(
            id: UUID(),
            message: "a description",
            createdAt: (Date(timeIntervalSince1970: 1_598_754_322), "2020-08-30T02:25:22+00:00"),
            username: "another username"
        )

        let samples = [200, 201, 250, 280, 299]
        let json = makeItemsJSON([item1.json, item2.json])

        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(json, from: HTTPURLResponse(statusCode: code))

            XCTAssertEqual(result, [item1.model, item2.model])
//            expect(sut, toCompleteWithResult: .success(items), when: {
//                let json = makeItemsJSON([item1.json, item2.json])
//                client.complete(withStatusCode: code, data: json, at: index)
//            })
        }
    }

    // MARK: Helper

//    private func makeSUT(url: URL = URL(string: "https://a-url.com")!,
//                         file: StaticString = #filePath,
//                         line: UInt = #line) ->
//        (sut: RemoteImageCommentsLoader, client: HTTPClientSpy)
//    {
//        let client = HTTPClientSpy()
//        let sut = RemoteImageCommentsLoader(url: url, client: client)
//        trackForMemoryLeaks(sut, file: file, line: line)
//        trackForMemoryLeaks(client, file: file, line: line)
//        return (sut, client)
//    }

//    private func failure(_ error: RemoteImageCommentsLoader.Error) -> RemoteImageCommentsLoader.Result {
//        return .failure(error)
//    }

    private func makeItem(id: UUID,
                          message: String,
                          createdAt: (date: Date, iso8601String: String),
                          username: String) -> (model: ImageComment, json: [String: Any])
    {
        let item = ImageComment(id: id, message: message, createAt: createdAt.date, username: username)
        let json: [String: Any] =
            ["id": id.uuidString,
             "message": message,
             "created_at": createdAt.iso8601String,
             "author": [
                 "username": username,
             ]]

        return (item, json)
    }

    // Creating a helper class to load the errors and do an assertion

//    private func expect(_ sut: RemoteImageCommentsLoader,
//                        toCompleteWithResult expectedResult: RemoteImageCommentsLoader.Result,
//                        when action: () -> Void,
//                        file: StaticString = #filePath,
//                        line: UInt = #line)
//    {
//        let exp = expectation(description: "Wait for load completion")
//
//        sut.load { recievedResult in
//            switch (recievedResult, expectedResult) {
//            case let (.success(recievedItems), .success(expectedItems)):
//                XCTAssertEqual(recievedItems, expectedItems, file: file, line: line)
//
//            case let (.failure(receivedError as RemoteImageCommentsLoader.Error), .failure(expectedError as RemoteImageCommentsLoader.Error)):
//                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
//
//            default:
//                XCTFail("Expected result \(expectedResult) got \(recievedResult) instead", file: file, line: line)
//            }
//            exp.fulfill()
//        }
//        action()
//        wait(for: [exp], timeout: 1.0)
//    }
}
