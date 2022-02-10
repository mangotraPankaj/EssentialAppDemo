//
//  ImageCommentsMapper.swift
//  EDNLearn
//
//  Created by Pankaj Mangotra on 10/02/22.
//

import Foundation

internal enum ImageCommentsMapper {
    private struct Root: Decodable {
        var items: [RemoteFeedItem]
    }

    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOk, let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw RemoteImageCommentsLoader.Error.invalidData
        }

        return root.items
    }
}
