//
//  CellController.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 14/03/22.
//

import UIKit

public struct CellController {
    let id: AnyHashable
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    let dataSourcePreFetching: UITableViewDataSourcePrefetching?

    public init(id: AnyHashable = UUID(), _ dataSource: UITableViewDataSource & UITableViewDataSourcePrefetching & UITableViewDelegate) {
        self.id = id
        self.dataSource = dataSource
        dataSourcePreFetching = dataSource
        delegate = dataSource
    }

    public init(id: AnyHashable = UUID(), _ dataSource: UITableViewDataSource) {
        self.id = id
        self.dataSource = dataSource
        dataSourcePreFetching = nil
        delegate = nil
    }
}

extension CellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CellController: Equatable {
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
}
