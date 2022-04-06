//
//  ErrorViewModel.swift
//  EDNLearn
//
//  Created by Pankaj Mangotra on 25/11/21.
//

import Foundation

public struct ResourceErrorViewModel {
    public var message: String?

    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }

    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
