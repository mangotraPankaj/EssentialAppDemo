//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 04/10/21.
//

import EDNLearnMac
import UIKit

public protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class FeedImageCellController: ResourceView, ResourceErrorView, ResourceLoadingView {
    public typealias ResourceViewModel = UIImage
    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageCell?
    private let viewModel: FeedImageViewModel

    public init(viewModel: FeedImageViewModel, delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
    }

    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.locationContainer.isHidden = !viewModel.hasLocation
        cell?.descriptionLabel.text = viewModel.description
        cell?.locationLabel.text = viewModel.location
        cell?.onRetry = delegate.didRequestImage
        delegate.didRequestImage()
        return cell!
    }

    func preload() {
        delegate.didRequestImage()
    }

    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }

    public func display(_ viewModel: UIImage) {
        cell?.feedImageView.setImageAnimated(viewModel)
    }

    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.feedImageRetryButton.isHidden = viewModel.message == nil
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.feedImageContainer.isShimmering = viewModel.isLoading
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}
