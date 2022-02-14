//
//  RemoteFeedLoader.swift
//  EDNLearn
//
//  Created by Pankaj Mangotra on 08/06/21.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemMapper.map)
    }
}
