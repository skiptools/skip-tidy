// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import XCTest
import OSLog
import Foundation
@testable import SkipTidy

let logger: Logger = Logger(subsystem: "SkipTidy", category: "Tests")

@available(macOS 13, *)
final class SkipTidyTests: XCTestCase {
    func testSkipTidy() throws {
        logger.log("running testSkipTidy")
        XCTAssertEqual(1 + 2, 3, "basic test")
        
        // load the TestData.json file from the Resources folder and decode it into a struct
        let resourceURL: URL = try XCTUnwrap(Bundle.module.url(forResource: "TestData", withExtension: "json"))
        let testData = try JSONDecoder().decode(TestData.self, from: Data(contentsOf: resourceURL))
        XCTAssertEqual("SkipTidy", testData.testModuleName)
    }

    public func testTidyLibrary() throws {
        if isAndroid {
            XCTAssertEqual("Linux", Tidy.tidyPlatform)
        } else {
            XCTAssertEqual("Apple macOS", Tidy.tidyPlatform)
        }

        XCTAssertEqual("5.9.20", Tidy.tidyVersion)
        XCTAssertEqual("2022.01.25", Tidy.tidyReleaseDate)
    }

    public func testTidyHTML() throws {
        XCTAssertEqual(try "<html></html>".tidy(), "<html></html>")

//        XCTAssertEqual(try "<html></html>".tidy(), """
//        <!DOCTYPE html>
//        <html>
//        <head>
//        <meta name="generator" content=
//        "HTML Tidy for HTML5 for Apple macOS version 5.9.8">
//        <title></title>
//        </head>
//        <body>
//        </body>
//        </html>
//        
//        """)
    }
}

struct TestData : Codable, Hashable {
    var testModuleName: String
}
