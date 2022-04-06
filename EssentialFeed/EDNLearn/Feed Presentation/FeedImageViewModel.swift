//
//  FeedImageViewModel.swift
//  EDNLearn
//
//  Created by Pankaj Mangotra on 26/11/21.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?

    public var hasLocation: Bool {
        return location != nil
    }
}
