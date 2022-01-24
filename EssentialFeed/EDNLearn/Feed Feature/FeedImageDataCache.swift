//
//  FeedImageDataCache.swift
//  EDNLearn
//
//  Created by Pankaj Mangotra on 11/01/22.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
