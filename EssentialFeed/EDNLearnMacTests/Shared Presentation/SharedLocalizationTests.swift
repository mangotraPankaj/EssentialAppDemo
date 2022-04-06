//
//  SharedLocalizationTests.swift
//  EDNLearn
//
//  Created by Pankaj Mangotra on 23/02/22.
//

import EDNLearnMac
import XCTest

class SharedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

    private class DummyView: ResourceView {
        func display(_: Any) {}
    }
}
