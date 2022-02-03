//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 10/11/21.
//

import EDNLearnMac
import EssentialFeediOS
import UIKit

final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher

    init(controller: FeedViewController, imageloader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.controller = controller
        imageLoader = imageloader
    }

    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapater<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = FeedImageCellController(delegate: adapter)
            adapter.presenter = FeedImagePresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            return view
        })
    }
}
