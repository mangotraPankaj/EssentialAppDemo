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
    private var selection: (FeedImage) -> Void

    init(controller: ListViewController, imageloader: @escaping (URL) -> FeedImageDataLoader.Publisher, selection: @escaping (FeedImage) -> Void) {
        self.controller = controller
        imageLoader = imageloader
        self.selection = selection
    }

    func display(_ viewModel: Paginated<FeedImage>) {
        controller?.display(viewModel.items.map { model in
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
                delegate: adapter,
                selection: { [selection] in
                    selection(model)
                }
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

            return CellController(id: model, view)
        })
    }
}

private struct InvalidImageData: Error {}
