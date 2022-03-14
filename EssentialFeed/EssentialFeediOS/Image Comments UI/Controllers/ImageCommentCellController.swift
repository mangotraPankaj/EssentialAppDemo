//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 11/03/22.
//

import EDNLearnMac
import UIKit

public class ImageCommentCellController: NSObject, CellController {
    private let model: ImageCommentViewModel

    public init(model: ImageCommentViewModel) {
        self.model = model
    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.dateLabel.text = model.date
        cell.usernameLabel.text = model.username
        return cell
    }

    public func tableView(_: UITableView, prefetchRowsAt _: [IndexPath]) {}
}
