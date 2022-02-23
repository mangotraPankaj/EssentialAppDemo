//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Pankaj Mangotra on 09/11/21.
//

@testable import EDNLearnMac
import XCTest

final class FeedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
