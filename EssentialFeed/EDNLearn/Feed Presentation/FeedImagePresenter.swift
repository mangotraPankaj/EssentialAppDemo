//
//  FeedImagePresenter.swift
//  EDNLearn
//
//  Created by Pankaj Mangotra on 26/11/21.
//

import Foundation

public enum FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location
        )
    }
}
