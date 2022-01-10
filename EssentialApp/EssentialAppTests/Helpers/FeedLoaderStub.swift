//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Pankaj Mangotra on 10/01/22.
//

import EDNLearnMac
import Foundation

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result

    init(result: FeedLoader.Result) {
        self.result = result
    }

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
