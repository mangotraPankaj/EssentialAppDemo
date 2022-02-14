//
//  RemoteImageCommentsLoader.swift
//  EDNLearn
//
//  Created by Pankaj Mangotra on 10/02/22.
//

import Foundation

public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
