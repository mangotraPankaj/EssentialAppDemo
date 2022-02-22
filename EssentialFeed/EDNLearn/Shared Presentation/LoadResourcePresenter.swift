//
//  LoadResourcePresenter.swift
//  EDNLearn
//
//  Created by Pankaj Mangotra on 22/02/22.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel

    func display(_ viewModel: ResourceViewModel)
}

public final class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) -> View.ResourceViewModel
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView
    private let resourceView: View
    private let mapper: Mapper

    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }

    public init(resourceView: View, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.errorView = errorView
        self.loadingView = loadingView
        self.resourceView = resourceView
        self.mapper = mapper
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
    public func didFinishLoading(with resource: Resource) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    /// Error -> creates view models - > sends to UI
    public func didFinishLoadingFeed(with _: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(.error(message: feedLoadError))
    }
}
