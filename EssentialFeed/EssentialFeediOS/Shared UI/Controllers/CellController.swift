//
//  CellController.swift
//  EssentialFeediOS
//
//  Created by Pankaj Mangotra on 14/03/22.
//

import UIKit

public struct CellController {
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    let dataSourcePreFetching: UITableViewDataSourcePrefetching?

    public init(_ dataSource: UITableViewDataSource & UITableViewDataSourcePrefetching & UITableViewDelegate) {
        self.dataSource = dataSource
        dataSourcePreFetching = dataSource
        delegate = dataSource
    }

    public init(_ dataSource: UITableViewDataSource) {
        self.dataSource = dataSource
        dataSourcePreFetching = nil
        delegate = nil
    }
}
