//
//  UIControl+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Pankaj Mangotra on 25/01/22.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
