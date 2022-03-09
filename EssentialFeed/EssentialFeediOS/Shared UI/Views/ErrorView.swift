//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 16/11/21.
//

import UIKit

public final class ErrorView: UIView {
    @IBOutlet public private(set) var errorLabel: UILabel!

    public var message: String? { return isVisible ? errorLabel.text : nil }

    private var isVisible: Bool {
        return alpha > 0
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        errorLabel.text = nil

        alpha = 0
    }

    func show(message: String) {
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
}
