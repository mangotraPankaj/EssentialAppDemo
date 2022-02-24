//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 04/10/21.
//

import Combine
import EDNLearnMac
import EssentialFeediOS
import UIKit

public final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(feedLoader: @escaping () -> FeedLoader.Publisher, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> FeedViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>(loader:
            { feedLoader().dispatchOnMainQueue() })
        let feedController = makeFeedViewController(
            delegate: presentationAdapter,
            title: FeedPresenter.title
        )

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageloader: { imageLoader($0).dispatchOnMainQueue() }
            ),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController), mapper: FeedPresenter.map
        )

        return feedController
    }

    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) ->
        FeedViewController
    {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}
