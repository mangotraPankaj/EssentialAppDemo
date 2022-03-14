//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 13/09/21.
//

import EDNLearnMac
import UIKit

public typealias CellController = UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching

/// cell controller is made from custom protocol to using UIKit tableview protocol to remove the dependency for imageCommentCellController and FeedImageCellcontroller on shared UI List controller.
// public protocol CellController {
//    func view(in tableView: UITableView) -> UITableViewCell
//    func preload()
//    func cancelLoad()
// }
//
// public extension CellController {
//    func preload() {}
//    func cancelLoad() {}
// }

public final class ListViewController: UITableViewController, UITableViewDataSourcePrefetching, ResourceLoadingView, ResourceErrorView {
    @IBOutlet public private(set) var errorView: ErrorView?

    private var loadingControllers = [IndexPath: CellController]()

    public var onRefresh: (() -> Void)?

    private var tableModel = [CellController]() {
        didSet {
            tableView.reloadData()
        }
    }

    private var tasks = [IndexPath: FeedImageDataLoaderTask]()

    override public func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeTableHeaderToFit()
    }

    @IBAction private func refresh() {
        onRefresh?()
    }

    public func display(_ cellControllers: [CellController]) {
        loadingControllers = [:]
        tableModel = cellControllers
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }

    public func display(_ viewModel: ResourceErrorViewModel) {
        if let message = viewModel.message {
            errorView?.show(message: message)
        } else {
            errorView?.hideMessage()
        }
    }

    override public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return tableModel.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return cellController(forRowAt: indexPath).view(in: tableView)
        let controller = cellController(forRowAt: indexPath)
        return controller.tableView(tableView, cellForRowAt: indexPath)
    }

    override public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let controller = removeLoadingController(forRowAt: indexPath)
        controller?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }

    public func tableView(_: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let controller = cellController(forRowAt: indexPath)
            return controller.tableView(tableView, prefetchRowsAt: [indexPath])
            // cellController(forRowAt: indexPath).preload()
        }
    }

    public func tableView(_: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let controller = removeLoadingController(forRowAt: indexPath)
            controller?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
        }
    }

    private func cellController(forRowAt indexPath: IndexPath) -> CellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }

    private func removeLoadingController(forRowAt indexPath: IndexPath) -> CellController? {
        let controller = loadingControllers[indexPath]
        // loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
        return controller
    }
}
