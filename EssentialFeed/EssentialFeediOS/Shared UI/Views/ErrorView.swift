//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 16/11/21.
//

import UIKit

public final class ErrorView: UIView {
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    public var message: String? {
        get { return isVisible ? errorLabel.text : nil }
        set { setMessageAnimated(newValue) }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configure() {
        backgroundColor = .errorBackgroundColor
        configureLabel()
        hideMessageAnimated()
    }

    private func configureLabel() {
        addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            trailingAnchor.constraint(equalTo: errorLabel.trailingAnchor, constant: 8),
            errorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            bottomAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 8),
        ])
    }

    private var isVisible: Bool {
        return alpha > 0
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        hideMessageAnimated()
    }

    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            show(message)
        } else {
            hideMessage()
        }
    }

    private func show(_ message: String) {
        errorLabel.text = message
        // button.setTitle(message, for: .normal)

        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    @IBAction func hideMessage() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed {
                    self.errorLabel.text = nil
                }
            }
        )
    }

    private func hideMessageAnimated() {
        errorLabel.text = nil

        alpha = 0
    }
}

extension UIColor {
    static var errorBackgroundColor: UIColor {
        UIColor(red: 0.9951, green: 0.4176, blue: 0.4154, alpha: 1)
    }
}
