//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Pankaj Mangotra on 04/01/22.
//

import EDNLearnMac
import Foundation

func anyNSError() -> Error {
    return NSError(domain: "error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://a-url.com")!
}

func anyData() -> Data {
    return Data("anydata".utf8)
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}
