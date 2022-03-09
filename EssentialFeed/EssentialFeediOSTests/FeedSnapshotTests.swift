//
//  FeedSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by Pankaj Mangotra on 24/01/22.
//

@testable import EDNLearnMac
import EssentialFeediOS
import XCTest

class FeedSnapshotTests: XCTestCase {
    func test_emptyFeed() {
        let sut = makeSUT()
        sut.display(emptyFeed())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_FEED_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_FEED_dark")
    }

    func test_feedWithContent() {
        let sut = makeSUT()
        sut.display(feedWithContent())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "FEED_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "FEED_WITH_CONTENT_dark")
    }

    func test_feedWithErrorMessage() {
        let sut = makeSUT()
        sut.display(.error(message: "This is a \nmultiline error \nmessage"))

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "FEED_WITH_ERROR_MESSAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "FEED_WITH_ERROR_MESSAGE_dark")
    }

    func test_feedWithFailedImageLoading() {
        let sut = makeSUT()
        sut.display(feedWithFailedImageLoading())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "FEED_WITH_FAILED_IMAGE_LOADING_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "FEED_WITH_FAILED_IMAGE_LOADING_dark")
    }

    // MARK: - Helpers

    private func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func emptyFeed() -> [FeedImageCellController] {
        return []
    }

    private func feedWithContent() -> [ImageStub] {
        return [
            ImageStub(
                description: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
                location: "East Side Gallery\nMemorial in Berlin, Germany",
                image: UIImage.make(withColor: .red)
            ),
            ImageStub(
                description: "Garth Pier is a Grade II listed structure in Bangor, Gwynedd, North Wales.",
                location: "Garth Pier",
                image: UIImage.make(withColor: .green)
            ),
        ]
    }

    private func feedWithFailedImageLoading() -> [ImageStub] {
        return [
            ImageStub(
                description: nil,
                location: "Cannon street, London",
                image: nil
            ),
            ImageStub(
                description: nil,
                location: "Seafront",
                image: nil
            ),
        ]
    }

    private func assert(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotURL = makeSnapShotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)

        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            XCTFail("Failed to load stored snapshot URL at \(snapshotURL). Use the record method to store a snapshot before asserting", file: file, line: line)
            return
        }
        if snapshotData != storedSnapshotData {
            let tempSnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(snapshotURL.lastPathComponent)
            try? snapshotData?.write(to: tempSnapshotURL)

            XCTFail("New snapshot does not match with the stored snapshot. New snapshot URL: \(tempSnapshotURL), stored snapshot URL:\(snapshotURL)", file: file, line: line)
        }
    }

    private func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotURL = makeSnapShotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try snapshotData?.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }

    private func makeSnapShotURL(named name: String, file: StaticString = #file) -> URL {
        return URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
    }

    private func makeSnapshotData(for snapshot: UIImage, file: StaticString = #file, line: UInt = #line) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }
        return data
    }
}

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

private extension ListViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [FeedImageCellController] = stubs.map { stub in
            let cellController = FeedImageCellController(viewModel: stub.viewModel, delegate: stub)
            stub.controller = cellController
            return cellController
        }
        display(cells)
    }
}

private class ImageStub: FeedImageCellControllerDelegate {
    var viewModel: FeedImageViewModel
    let image: UIImage?
    weak var controller: FeedImageCellController?

    init(description: String?, location: String?, image: UIImage?) {
        viewModel = FeedImageViewModel(
            description: description,
            location: location
        )
        self.image = image
    }

    func didRequestImage() {
        controller?.display(ResourceLoadingViewModel(isLoading: false))

        if let image = image {
            controller?.display(image)
            controller?.display(ResourceErrorViewModel(message: .none))
        } else {
            controller?.display(ResourceErrorViewModel(message: "any"))
        }
    }

    func didCancelImageRequest() {}
}
