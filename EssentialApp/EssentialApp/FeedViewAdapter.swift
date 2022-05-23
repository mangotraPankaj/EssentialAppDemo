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

    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<FeedImageCellController>>
    private typealias LoadMorePresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>

    init(controller: ListViewController, imageloader: @escaping (URL) -> FeedImageDataLoader.Publisher, selection: @escaping (FeedImage) -> Void) {
        self.controller = controller
        imageLoader = imageloader
        self.selection = selection
    }

    /// the below code is written to convert imageLoader which takes
    /// one parameter and LoadResourcePresentationAdapter loader
    /// which does not take any parameter.We are adapting
    /// imageLoader method of
    /// FeedImageDataLoaderPresentationAdapater that takes one
    /// parameter to a method that takes no parameters. This is
    /// known as partial application of functions .
    ///
    ///
    ////// Parameters that dont change can be passed at intialization time whereas the params which dynamically change are passed by property injection or method injection.
    func display(_ viewModel: Paginated<FeedImage>) {
        let feed: [CellController] = viewModel.items.map { model in

            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(model.url)
            })

            let view = FeedImageCellController(
                viewModel: FeedImagePresenter.map(model),
                delegate: adapter,
                selection: { [selection] in
                    selection(model)
                }
            )

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
        }

        guard let loadMorePublisher = viewModel.loadMorePublisher else {
            controller?.display(feed)
            return
        }

        let loadMoreAdapter = LoadMorePresentationAdapter(loader: loadMorePublisher)
        let loadMore = LoadMoreCellController(callback: loadMoreAdapter.loadResource)

        loadMoreAdapter.presenter = LoadResourcePresenter(
            resourceView: self,
            loadingView: WeakRefVirtualProxy(loadMore),
            errorView: WeakRefVirtualProxy(loadMore),
            mapper: { $0 })

        let loadMoreSection = [CellController(id: UUID(), loadMore)]

        controller?.display(feed, loadMoreSection)
    }
}

private struct InvalidImageData: Error {}
