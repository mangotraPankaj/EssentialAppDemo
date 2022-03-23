//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 13/09/21.
//

import EDNLearnMac
import UIKit

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
    public private(set) var errorView = ErrorView()

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

        configureErrorView()
        refresh()
    }

    private func configureErrorView() {
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(errorView)

        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: errorView.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: container.topAnchor),
            container.bottomAnchor.constraint(equalTo: errorView.bottomAnchor),
        ])

        tableView.tableHeaderView = container

        errorView.onHide = { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.sizeTableHeaderToFit()
            self?.tableView.endUpdates()
        }
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
        // errorView?.show("Errro")
        errorView.message = viewModel.message
    }

    override public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return tableModel.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return cellController(forRowAt: indexPath).view(in: tableView)
        let dataSource = cellController(forRowAt: indexPath).dataSource
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }

    override public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = removeLoadingController(forRowAt: indexPath)?.delegate
        dl?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }

    public func tableView(_: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = cellController(forRowAt: indexPath).dataSourcePreFetching
            dsp?.tableView(tableView, prefetchRowsAt: [indexPath])
            // cellController(forRowAt: indexPath).preload()
        }
    }

    public func tableView(_: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = removeLoadingController(forRowAt: indexPath)?.dataSourcePreFetching
            dsp?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
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
