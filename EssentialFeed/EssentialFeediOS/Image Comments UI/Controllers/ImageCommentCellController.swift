//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 11/03/22.
//

import EDNLearnMac
import UIKit

public class ImageCommentCellController: CellController {
    private let model: ImageCommentViewModel

    public init(model: ImageCommentViewModel) {
        self.model = model
    }

    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.dateLabel.text = model.date
        cell.usernameLabel.text = model.username
        return cell
    }
}
