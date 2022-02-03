//
//  FeedImageDataLoaderPresentationAdapater.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 10/11/21.
//

import Combine
import EDNLearnMac
import EssentialFeediOS
import Foundation

final class FeedImageDataLoaderPresentationAdapater<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    private let model: FeedImage
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private var cancellable: Cancellable?

    var presenter: FeedImagePresenter<View, Image>?

    init(model: FeedImage, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.model = model
        self.imageLoader = imageLoader
    }

    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)

        let model = self.model

        cancellable = imageLoader(model.url).sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished: break
            case let .failure(error):
                self?.presenter?.didFinishLoadingImageData(with: error, for: model)
            }
        }, receiveValue: { [weak self] data in
            self?.presenter?.didFinishLoadingImageData(with: data, for: model)
        })
    }

    func didCancelImageRequest() {
        cancellable?.cancel()
    }
}
