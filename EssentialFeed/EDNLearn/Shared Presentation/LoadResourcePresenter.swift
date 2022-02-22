//
//  LoadResourcePresenter.swift
//  EDNLearn
//
//  Created by Pankaj Mangotra on 22/02/22.
//

import Foundation

public final class LoadResourcePresenter {
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView
    private let feedView: FeedView

    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }

    public init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.errorView = errorView
        self.loadingView = loadingView
        self.feedView = feedView
    }

    /// Data in -> transforms(creates view models) -> data out to the UI

    /// Void -> creates view models -> sends to UI
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    // [FeedImage] -> creates view models -> send to UI
    // [ImageComment] -> creates view models -> send to UI - For image comments

    // REsource -> create ResourceViewModel -> sends to UI - Generic resource
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    /// Error -> creates view models - > sends to UI
    public func didFinishLoadingFeed(with _: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(.error(message: feedLoadError))
    }
}
