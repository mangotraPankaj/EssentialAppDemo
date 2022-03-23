//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 16/11/21.
//

import UIKit

public final class ErrorView: UIButton {
    public var message: String? {
        get { return isVisible ? title(for: .normal) : nil }
        set { setMessageAnimated(newValue) }
    }

    public var onHide: (() -> Void)?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configure() {
        backgroundColor = .errorBackgroundColor

        addTarget(self, action: #selector(hideMessage), for: .touchUpInside)
        configureLabel()
        hideMessageAnimated()
    }

    private func configureLabel() {
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
        titleLabel?.font = .systemFont(ofSize: 17)
    }

    private var isVisible: Bool {
        return alpha > 0
    }

    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            show(message)
        } else {
            hideMessage()
        }
    }

    private func show(_ message: String) {
        setTitle(message, for: .normal)
        contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    @objc private func hideMessage() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed {
                    self.hideMessageAnimated()
                }
            }
        )
    }

    private func hideMessageAnimated() {
        setTitle(nil, for: .normal)
        alpha = 0
        contentEdgeInsets = .init(top: -2.5, left: 0, bottom: -2.5, right: 0)
        onHide?()
    }
}

extension UIColor {
    static var errorBackgroundColor: UIColor {
        UIColor(red: 0.9951, green: 0.4176, blue: 0.4154, alpha: 1)
    }
}
