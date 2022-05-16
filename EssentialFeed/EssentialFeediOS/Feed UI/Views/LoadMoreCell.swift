//
//  LoadMoreCell.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 13/05/22.
//

import UIKit

public class LoadMoreCell: UITableViewCell {
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        contentView.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.heightAnchor.constraint(lessThanOrEqualToConstant: 40),
        ])
        return spinner
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.font = .preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true

        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 9),
            contentView.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 9),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 9),

        ])
        return label
    }()

    public var isLoading: Bool {
        get { spinner.isAnimating }
        set {
            if newValue {
                spinner.startAnimating()
            } else {
                spinner.stopAnimating()
            }
        }
    }

    public var message: String? {
        get { messageLabel.text }
        set {
            messageLabel.text = newValue
        }
    }
}
