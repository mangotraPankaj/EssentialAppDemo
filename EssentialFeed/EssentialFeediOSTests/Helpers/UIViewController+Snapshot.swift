//
//  UIViewController+Snapshot.swift
//  EssentialFeediOSTests
//
//  Created by Pankaj Mangotra on 11/03/22.
//

import Foundation
import UIKit

extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        // return SnapshotWindow(root: self, userStyle: .dark).snapshot()
        return SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}

struct SnapshotConfiguration {
//    let size: CGSize
//    let safeAreaInsets: UIEdgeInsets
//    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection

    static func iPhone13(style: UIUserInterfaceStyle) -> SnapshotConfiguration {
        return SnapshotConfiguration(traitCollection: UITraitCollection(traitsFrom: [.init(userInterfaceStyle: style)]))
//        return SnapshotConfiguration(
//            size: CGSize(width: 390, height: 844),
//            safeAreaInsets: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
//            layoutMargins: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16),
//            traitCollection: UITraitCollection(traitsFrom: [
//                .init(forceTouchCapability: .unavailable),
//                .init(layoutDirection: .leftToRight),
//                .init(preferredContentSizeCategory: .large),
//                .init(userInterfaceIdiom: .phone),
//                .init(horizontalSizeClass: .compact),
//                .init(verticalSizeClass: .regular),
//                .init(displayScale: 3),
//                .init(displayGamut: .P3),
//                .init(userInterfaceStyle: style),
//            ])
//        )
    }
}

private final class SnapshotWindow: UIWindow {
    private var configuration: SnapshotConfiguration = .iPhone13(style: .light)

//    convenience init(root: UIViewController, userStyle: UIUserInterfaceStyle) {
//        self.init(frame: CGRect(origin: .zero, size: root.view.bounds.size))
//        rootViewController = root
//        overrideUserInterfaceStyle = userStyle
//        isHidden = false
//    }

    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: root.view.bounds.size))
        self.configuration = configuration
        // layoutMargins = configuration.layoutMargins
        rootViewController = root
        isHidden = false
        // root.view.layoutMargins = configuration.layoutMargins
    }

//    override var safeAreaInsets: UIEdgeInsets {
//        return configuration.safeAreaInsets
//    }
//
    override var traitCollection: UITraitCollection {
        return UITraitCollection(traitsFrom: [super.traitCollection, configuration.traitCollection])
    }

    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }
}
