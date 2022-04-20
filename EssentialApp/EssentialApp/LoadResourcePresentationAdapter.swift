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

final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: Cancellable?
    var presenter: LoadResourcePresenter<Resource, View>?

    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }

    func loadResource() {
        presenter?.didStartLoading()

        cancellable = loader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: {
                    [weak self] completion in
                        switch completion {
                        case .finished: break
                        case let .failure(error):
                            self?.presenter?.didFinishLoading(with: error)
                        }
                },
                receiveValue: { [weak self] resource in
                    self?.presenter?.didFinishLoading(with: resource)
                }
            )
    }
}

extension LoadResourcePresentationAdapter: FeedImageCellControllerDelegate {
    func didRequestImage() {
        loadResource()
    }

    func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
}
