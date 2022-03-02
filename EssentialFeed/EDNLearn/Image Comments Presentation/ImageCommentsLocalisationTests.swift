//
//  ImageCommentsLocalisationTests.swift
//  EDNLearnMacTests
//
//  Created by Pankaj Mangotra on 02/03/22.
//

import EDNLearnMac
import XCTest
class ImageCommentsLocalisationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
