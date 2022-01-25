//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Pankaj Mangotra on 08/11/21.
//

import EssentialFeediOS
import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
