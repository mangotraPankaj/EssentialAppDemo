//
//  FeedPresenterTests.swift
//  EDNLearnMacTests
//
//  Created by Pankaj Mangotra on 17/11/21.
//

import EDNLearnMac
import XCTest

class FeedPresenterTests: XCTestCase {
    func test_title_isLocalized() {
        XCTAssertEqual(FeedPresenter.title, localized("FEED_VIEW_TITLE"))
    }

    func test_map_createsViewModel() {
        let feed = uniqueImageFeed().models

        let viewModel = FeedPresenter.map(feed)

        XCTAssertEqual(viewModel.feed, feed)
    }

    /// All the below tests are covered in generic presenter tests

//    func test_init_doesNotSendMessagesToView() {
//        let (_, view) = makeSUT()
//
//        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
//    }
//
//    func test_didStartLoadingFeed_displaysNoErrorMessageAndStartsLoading() {
//        let (sut, view) = makeSUT()
//
//        sut.didStartLoadingFeed()
//        XCTAssertEqual(view.messages, [
//            .display(errorMessage: .none),
//            .display(isLoading: true),
//
//        ])
//    }
//
//    func test_didFinishLoadingFeed_displaysFeedAndStopsLoading() {
//        let (sut, view) = makeSUT()
//        let feed = uniqueImageFeed().models
//        sut.didFinishLoadingFeed(with: feed)
//        XCTAssertEqual(view.messages, [
//            .display(feed: feed),
//            .display(isLoading: false),
//
//        ])
//    }
//
//    func test_didFinishLoadingFeedWithError_displaysLocalizedErrorMessageAndStopsLoading() {
//        let (sut, view) = makeSUT()
//        sut.didFinishLoadingFeed(with: anyError())
//        XCTAssertEqual(view.messages,
//                       [.display(errorMessage: localized("GENERIC_CONNECTION_ERROR", table: "Shared")),
//                        .display(isLoading: false)])
//    }

    // MARK: - Helpers

//    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
//        let view = ViewSpy()
//        let sut = FeedPresenter(feedView: view, loadingView: view, errorView: view)
//        trackForMemoryLeaks(view, file: file, line: line)
//        trackForMemoryLeaks(sut, file: file, line: line)
//        return (sut, view)
//    }

    private func localized(_ key: String, table: String = "Feed", file: StaticString = #file, line: UInt = #line) -> String {
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }

//    private class ViewSpy: ResourceErrorView, ResourceLoadingView, FeedView {
//        func display(_ viewModel: FeedViewModel) {
//            messages.insert(.display(feed: viewModel.feed))
//        }
//
//        enum Message: Hashable {
//            case display(errorMessage: String?)
//            case display(isLoading: Bool)
//            case display(feed: [FeedImage])
//        }
//
//        private(set) var messages = Set<Message>()
//
//        func display(_ viewModel: ResourceErrorViewModel) {
//            messages.insert(.display(errorMessage: viewModel.message))
//        }
//
//        func display(_ viewModel: ResourceLoadingViewModel) {
//            messages.insert(.display(isLoading: viewModel.isLoading))
//        }
//    }
}
