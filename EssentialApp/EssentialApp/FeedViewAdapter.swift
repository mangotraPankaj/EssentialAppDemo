//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 10/11/21.
//

import EDNLearnMac
import EssentialFeediOS
import UIKit

final class FeedViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher

    init(controller: ListViewController, imageloader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.controller = controller
        imageLoader = imageloader
    }

    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            /// the below code is written to convert imageLoader which takes
            /// one parameter and LoadResourcePresentationAdapter loader
            /// which does not take any parameter.We are adapting
            /// imageLoader method of
            /// FeedImageDataLoaderPresentationAdapater that takes one
            /// parameter to a method that takes no parameters. This is
            /// known as partial application of functions .

            let adapter = LoadResourcePresentationAdapter<Data,
                WeakRefVirtualProxy<FeedImageCellController>>(loader: { [imageLoader] in
                imageLoader(model.url)
            })

//            let adapter = FeedImageDataLoaderPresentationAdapater<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)

            /// Parameters that dont change can be passed at intialization time whereas the params which dynamically change are passed by property injection or method injection.
            let view = FeedImageCellController(
                viewModel: FeedImagePresenter.map(model),
                delegate: adapter
            )

            // adapter.presenter = FeedImagePresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(view),
                loadingView: WeakRefVirtualProxy(view),
                errorView: WeakRefVirtualProxy(view),
                mapper: { data in
                    guard let image = UIImage(data: data) else {
                        throw InvalidImageData()
                    }
                    return image
                }
            )

            return CellController(view)
        })
    }
}

private struct InvalidImageData: Error {}
