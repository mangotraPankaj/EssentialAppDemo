//
//  SnapshotTests+Helpers.swift
//  EssentialFeediOSTests
//
//  Created by Pankaj Mangotra on 10/03/22.
//

import Foundation
import XCTest

extension XCTest {
    func assert(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
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

    func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
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

    func makeSnapShotURL(named name: String, file: StaticString = #file) -> URL {
        return URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
    }

    func makeSnapshotData(for snapshot: UIImage, file: StaticString = #file, line: UInt = #line) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }
        return data
    }
}
