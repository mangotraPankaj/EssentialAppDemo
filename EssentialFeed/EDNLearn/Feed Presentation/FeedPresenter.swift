//
//  FeedPresenter.swift
//  EDNLearn
//
//  Created by Pankaj Mangotra on 25/11/21.
//

import Foundation

/// The commented code below is not required as the FeedView has be replaced by ResourceView *&*
/* public protocol FeedView {
     func display(_ viewModel: FeedViewModel)
 } */

public final class FeedPresenter {
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Title for the feed view")
    }

    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }

    /// The commented code below is not required as the functionality has moved to shared presenter *&*

    //  *&*  private let errorView: ResourceErrorView
//    private let loadingView: ResourceLoadingView
//    private let feedView: FeedView

    /// *&*
    /*
     private var feedLoadError: String {
         return NSLocalizedString("GENERIC_CONNECTION_ERROR",
                                  tableName: "Shared",
                                  bundle: Bundle(for: FeedPresenter.self),
                                  comment: "Error message displayed when we can't load the image feed from the server")
     }

     public init(feedView: FeedView, loadingView: ResourceLoadingView, errorView: ResourceErrorView) {
         self.errorView = errorView
         self.loadingView = loadingView
         self.feedView = feedView
     }

     /// Data in -> transforms(creates view models) -> data out to the UI

     /// Void -> creates view models -> sends to UI
     public func didStartLoadingFeed() {
         errorView.display(.noError)
         loadingView.display(ResourceLoadingViewModel(isLoading: true))
     }

     // [FeedImage] -> creates view models -> send to UI
     // [ImageComment] -> creates view models -> send to UI - For image comments

     // REsource -> create ResourceViewModel -> sends to UI - Generic resource
     public func didFinishLoadingFeed(with feed: [FeedImage]) {
         feedView.display(Self.map(feed))
         loadingView.display(ResourceLoadingViewModel(isLoading: false))
     }

     /// Error -> creates view models - > sends to UI
     public func didFinishLoadingFeed(with _: Error) {
         loadingView.display(ResourceLoadingViewModel(isLoading: false))
         errorView.display(.error(message: feedLoadError))
     }
     */
}
