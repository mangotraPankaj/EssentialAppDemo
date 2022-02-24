//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 10/11/21.
//

import Combine
import EDNLearnMac
import EssentialFeediOS
import Foundation

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    private let feedLoader: () -> FeedLoader.Publisher
    private var cancellable: Cancellable?
    var presenter: LoadResourcePresenter<[FeedImage], FeedViewAdapter>?

    init(feedLoader: @escaping () -> FeedLoader.Publisher) {
        self.feedLoader = feedLoader
    }

    func didRequestFeedRefresh() {
        presenter?.didStartLoading()

        cancellable = feedLoader().sink(receiveCompletion: { [weak self] completion in
                                            switch completion {
                                            case .finished: break
                                            case let .failure(error):
                                                self?.presenter?.didFinishLoading(with: error)
                                            }
                                        },
                                        receiveValue: { [weak self] feed in
                                            self?.presenter?.didFinishLoading(with: feed)
                                        })
    }
}
