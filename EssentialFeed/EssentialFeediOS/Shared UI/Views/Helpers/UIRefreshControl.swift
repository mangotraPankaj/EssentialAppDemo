//
//  UIRefreshControl.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 09/03/22.
//

import Foundation
import UIKit
extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
