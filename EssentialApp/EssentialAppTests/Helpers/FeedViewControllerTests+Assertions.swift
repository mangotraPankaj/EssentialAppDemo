//
//  FeedViewControllerTests+Assertions.swift
//  EssentialFeediOSTests
//
//  Created by Pankaj Mangotra on 08/11/21.
//

import EDNLearnMac
import EssentialFeediOS
import XCTest

extension FeedUIIntegrationTests {
    func assertThat(_ sut: ListViewController, isRendering feed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        // TableView.reloadData does not get
        // executed immediately due to performance
        // reasons. So to make the tableView reload
        // forcefully, layoutIfNeeded method is
        // called and RunLoop is run.

        sut.tableView.layoutIfNeeded()
        RunLoop.main.run(until: Date())

        guard sut.numberOfRenderedFeedImageViews() == feed.count else {
            return XCTFail("Expected \(feed.count) images , got \(sut.numberOfRenderedFeedImageViews()) instead", file: file, line: line)
        }
        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }

    func assertThat(_ sut: ListViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedImageView(at: index)

        guard let cell = view as? FeedImageCell else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        let shouldLocationBeVisible = (image.location != nil)
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "expected 'isShowingLocation to be \(shouldLocationBeVisible) for image view at index: (\(index))", file: file, line: line)

        XCTAssertEqual(cell.descriptionText, image.description, "Expected description text to be \(String(describing: image.description)) for image view at index: (\(index))", file: file, line: line)

        XCTAssertEqual(cell.locationText, image.location, "Expected location text to be \(String(describing: image.location)) for image view at index: (\(index))", file: file, line: line)
    }
}
