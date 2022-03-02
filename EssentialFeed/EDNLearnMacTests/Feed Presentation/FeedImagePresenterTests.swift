//
//  FeedImagePresenterTests.swift
//  EDNLearnMacTests
//
//  Created by Pankaj Mangotra on 25/11/21.
//

import EDNLearnMac
import XCTest

class FeedImagePresenterTests: XCTestCase {
    func test_map_createsViewModel() {
        let image = uniqueImage()

        let viewModel = FeedImagePresenter.map(image)

        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location)
    }
}
