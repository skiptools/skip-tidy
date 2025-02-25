// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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
            if Tidy.tidyPlatform == "Linux/x86" { // Android Intel emulator
                XCTAssertEqual("Linux/x86", Tidy.tidyPlatform)
            } else {
                XCTAssertEqual("Linux", Tidy.tidyPlatform)
            }
        } else {
            XCTAssertEqual(isJava || isMacOS ? "Apple macOS" : "Apple iOS", Tidy.tidyPlatform)
        }

        //XCTAssertEqual("5.9.8", Tidy.tidyVersion)
        //XCTAssertEqual("5.9.20", Tidy.tidyVersion)
        //XCTAssertEqual("2022.01.25", Tidy.tidyReleaseDate)
    }

    public func testTidyHTML() throws {
        XCTAssertEqual(try "<html></html>".tidy(), """
        <!DOCTYPE html>
        <html>
        <head>
        <title></title>
        </head>
        <body>
        </body>
        </html>
        
        """)

        XCTAssertEqual(try "<html><body><h1>Header</BADTAG></body></html>".tidy(), """
        <!DOCTYPE html>
        <html>
        <head>
        <title></title>
        </head>
        <body>
        <h1>Header</h1>
        </body>
        </html>

        """)
    }
}

struct TestData : Codable, Hashable {
    var testModuleName: String
}
