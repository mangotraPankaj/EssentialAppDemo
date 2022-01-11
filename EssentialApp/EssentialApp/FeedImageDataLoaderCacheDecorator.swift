//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Pankaj Mangotra on 11/01/22.
//

import EDNLearnMac

public final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader

    public init(decoratee: FeedImageDataLoader) {
        self.decoratee = decoratee
    }

    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url, completion: completion)
    }
}
